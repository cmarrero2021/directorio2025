const jwt = require("jsonwebtoken");
const pool = require("./db");
const {
  hashPassword,
  comparePassword,
  generateToken,
  generateSecureToken,
  sendEmail,
  validatePassword,
  getSessionTimeout,
} = require("./utils");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const moment = require("moment-timezone");
const previousTime = parseInt(process.env.SESSION_PREVIOUS_TIME || "10"); // segundos
// Configuración de Multer para el upload de imágenes
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    // All portada files go to public/portadas directory
    const dir = path.join(__dirname, "../public/portadas");
    if (!fs.existsSync(dir)) {
      fs.mkdirSync(dir, { recursive: true });
    }
    cb(null, dir);
  },
  filename: function (req, file, cb) {
    // Filename will be determined later in uploadPortada handler
    cb(null, file.originalname);
  },
});

const fileFilter = (req, file, cb) => {
  // Solo aceptar imágenes JPG
  if (file.mimetype === "image/jpeg" || file.mimetype === "image/jpg") {
    cb(null, true);
  } else {
    cb(new Error("Solo se permiten archivos JPG"), false);
  }
};

const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 1024 * 1024 * 5, // Limitar a 5MB
  },
});
// ================================
// Usuarios
// ================================

// Crear Usuario
exports.createUser = async (req, res) => {
  const { username, email, password } = req.body;

  // Validar el formato del password
  const passwordErrors = validatePassword(password);
  if (passwordErrors.length > 0) {
    return res.status(400).json({ errors: passwordErrors });
  }

  const hashedPassword = await hashPassword(password);

  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    // Crear usuario
    const result = await client.query(
      "INSERT INTO users (username, email, password_hash) VALUES ($1, $2, $3) RETURNING id",
      [username, email, hashedPassword]
    );
    const userId = result.rows[0].id;

    // Generar token de verificación
    const token = generateSecureToken();
    // Enviar correo de verificación
    const verificationLink = `http://intranet.minaamp.gob.ve/verify-email?token=${token}`;
    await sendEmail(
      email,
      "Verifica tu correo",
      `Haz clic en el siguiente enlace para verificar tu correo: ${verificationLink}`
    );

    await client.query("COMMIT");
    res.status(201).json({
      message:
        "Usuario creado exitosamente. Se ha enviado un correo de verificación.",
    });
  } catch (err) {
    await client.query("ROLLBACK");
    res.status(500).json({ error: "Error al crear el usuario." });
  } finally {
    client.release();
  }
};
exports.fastChangePassworwd = async (req, res) => {
  const { email, password } = req.body;

  // Validar el formato del password
  const passwordErrors = validatePassword(password);
  if (passwordErrors.length > 0) {
    return res.status(400).json({ errors: passwordErrors });
  }

  const hashedPassword = await hashPassword(password);

  const client = await pool.connect();
  try {
    // await client.query('BEGIN');

    // Crear usuario
    const result = await client.query(
      "UPDATE users SET password_hash = $2 where email = $1",
      [email, hashedPassword]
      // 'INSERT INTO users (username, email, password_hash) VALUES ($1, $2, $3) RETURNING id',
      // [username, email, hashedPassword]
    );
    // const userId = result.rows[0].id;

    // // Generar token de verificación
    // const token = generateSecureToken();
    // // Enviar correo de verificación
    // const verificationLink = `http://intranet.minaamp.gob.ve/verify-email?token=${token}`;
    // await sendEmail(email, 'Verifica tu correo', `Haz clic en el siguiente enlace para verificar tu correo: ${verificationLink}`);

    // await client.query('COMMIT');
    res.status(201).json({ message: "Clave cambiada." });
  } catch (err) {
    await client.query("ROLLBACK");
    res.status(500).json({ error: "Error al cambiar la clave." });
  } finally {
    client.release();
  }
};

// Verificar Correo Electrónico
exports.verifyEmail = async (req, res) => {
  const { token } = req.body;
  const client = await pool.connect();

  try {
    const result = await client.query(
      "SELECT user_id, expires_at FROM email_verifications WHERE token = $1",
      [token]
    );
    if (
      !result.rows.length ||
      new Date(result.rows[0].expires_at) < new Date()
    ) {
      return res.status(400).json({ error: "Token inválido o expirado." });
    }

    await client.query("UPDATE users SET is_verified = TRUE WHERE id = $1", [
      result.rows[0].user_id,
    ]);
    await client.query("DELETE FROM email_verifications WHERE token = $1", [
      token,
    ]);

    res.status(200).json({ message: "Correo verificado exitosamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al verificar el correo." });
  } finally {
    client.release();
  }
};

// Cambiar Contraseña
exports.changePassword = async (req, res) => {
  const { userId } = req; // Obtenido del middleware de autenticación
  const { oldPassword, newPassword } = req.body;

  // Validar el formato del nuevo password
  const passwordErrors = validatePassword(newPassword);
  if (passwordErrors.length > 0) {
    return res.status(400).json({ errors: passwordErrors });
  }

  const client = await pool.connect();
  try {
    // Verificar la contraseña actual
    const result = await client.query(
      "SELECT password_hash FROM users WHERE id = $1",
      [userId]
    );
    const isMatch = await comparePassword(
      oldPassword,
      result.rows[0].password_hash
    );
    if (!isMatch) {
      return res
        .status(400)
        .json({ error: "La contraseña actual es incorrecta." });
    }

    // Hashear y actualizar la nueva contraseña
    const hashedPassword = await hashPassword(newPassword);
    await client.query("UPDATE users SET password_hash = $1 WHERE id = $2", [
      hashedPassword,
      userId,
    ]);

    res.status(200).json({ message: "Contraseña cambiada exitosamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al cambiar la contraseña." });
  } finally {
    client.release();
  }
};

// Listar Usuarios
exports.listUsers = async (req, res) => {
  const client = await pool.connect();
  try {
    const result = await client.query(
      "SELECT id, first_name,last_name,cedula,email, is_email_verified, status, session_timeout_min FROM users WHERE deleted_at IS NULL"
    );
    res.status(200).json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error al listar los usuarios." });
  } finally {
    client.release();
  }
};

// Actualizar Usuario
exports.updateUser = async (req, res) => {
  const { userId } = req.params;
  const { username, email } = req.body;

  const client = await pool.connect();
  try {
    await client.query(
      "UPDATE users SET username = $1, email = $2, updated_at = NOW() WHERE id = $3",
      [username, email, userId]
    );
    res.status(200).json({ message: "Usuario actualizado exitosamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al actualizar el usuario." });
  } finally {
    client.release();
  }
};

// Eliminar Usuario (Borrado Lógico)
exports.deleteUser = async (req, res) => {
  const { userId } = req.params;

  const client = await pool.connect();
  try {
    await client.query("UPDATE users SET deleted_at = NOW() WHERE id = $1", [
      userId,
    ]);
    res.status(200).json({ message: "Usuario eliminado lógicamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al eliminar el usuario." });
  } finally {
    client.release();
  }
};

// Eliminar Usuario (Borrado Físico)
exports.deleteUserPermanently = async (req, res) => {
  const { userId } = req.params;

  const client = await pool.connect();
  try {
    await client.query("DELETE FROM users WHERE id = $1", [userId]);
    res.status(200).json({ message: "Usuario eliminado permanentemente." });
  } catch (err) {
    res
      .status(500)
      .json({ error: "Error al eliminar el usuario permanentemente." });
  } finally {
    client.release();
  }
};

// ================================
// Roles
// ================================

// Crear Rol
exports.createRole = async (req, res) => {
  const { name, description } = req.body;
  const client = await pool.connect();
  try {
    const result = await client.query(
      "INSERT INTO roles (name, description) VALUES ($1, $2) RETURNING id",
      [name, description]
    );
    res
      .status(201)
      .json({ message: "Rol creado exitosamente.", roleId: result.rows[0].id });
  } catch (err) {
    res.status(500).json({ error: "Error al crear el rol." });
  } finally {
    client.release();
  }
};
// Listar Roles
exports.listRoles = async (req, res) => {
  const client = await pool.connect();
  try {
    const result = await client.query(
      "SELECT id, name, description FROM roles WHERE deleted_at IS NULL"
    );
    res.status(200).json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error al listar los roles." });
  } finally {
    client.release();
  }
};

// Actualizar Rol
exports.updateRole = async (req, res) => {
  const { roleId } = req.params;
  const { name, description } = req.body;

  const client = await pool.connect();
  try {
    await client.query(
      "UPDATE roles SET name = $1, description = $2, updated_at = NOW() WHERE id = $3",
      [name, description, roleId]
    );
    res.status(200).json({ message: "Rol actualizado exitosamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al actualizar el rol." });
  } finally {
    client.release();
  }
};

// Eliminar Rol (Borrado Lógico)
exports.deleteRole = async (req, res) => {
  const { roleId } = req.params;

  const client = await pool.connect();
  try {
    await client.query("UPDATE roles SET deleted_at = NOW() WHERE id = $1", [
      roleId,
    ]);
    res.status(200).json({ message: "Rol eliminado lógicamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al eliminar el rol." });
  } finally {
    client.release();
  }
};

// Eliminar Rol (Borrado Físico)
exports.deleteRolePermanently = async (req, res) => {
  const { roleId } = req.params;

  const client = await pool.connect();
  try {
    await client.query("DELETE FROM roles WHERE id = $1", [roleId]);
    res.status(200).json({ message: "Rol eliminado permanentemente." });
  } catch (err) {
    res
      .status(500)
      .json({ error: "Error al eliminar el rol permanentemente." });
  } finally {
    client.release();
  }
};

// ================================
// Permisos
// ================================

// Crear Permiso
exports.createPermission = async (req, res) => {
  const { name, description } = req.body;

  const client = await pool.connect();
  try {
    const result = await client.query(
      "INSERT INTO permissions (name, description) VALUES ($1, $2) RETURNING id",
      [name, description]
    );
    res.status(201).json({
      message: "Permiso creado exitosamente.",
      permissionId: result.rows[0].id,
    });
  } catch (err) {
    res.status(500).json({ error: "Error al crear el permiso." });
  } finally {
    client.release();
  }
};

// Listar Permisos
exports.listPermissions = async (req, res) => {
  const client = await pool.connect();
  try {
    const result = await client.query(
      "SELECT id, name, description FROM permissions"
    );
    res.status(200).json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error al listar los permisos." });
  } finally {
    client.release();
  }
};
exports.listRolesPermissions = async (req, res) => {
  const client = await pool.connect();
  try {
    const result = await client.query(
      "SELECT a.role_id,b.name AS rol,a.permission_id,c.name AS permission,c.description FROM role_permissions a LEFT JOIN roles b ON b.id = a.role_id LEFT JOIN permissions c ON c.id = a.permission_id ORDER BY b.name,  c.name"
    );
    res.status(200).json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error al listar los permisos." });
  } finally {
    client.release();
  }
};

exports.listUserssPermissions = async (req, res) => {
  const client = await pool.connect();
  try {
    const result = await client.query(
      "SELECT a.user_id,b.email AS rol,a.permission_id,c.name AS PERMISSION,c.description FROM user_permissions a LEFT JOIN users b ON b.id = a.user_id LEFT JOIN permissions c ON c.id = a.permission_id ORDER BY b.email,c.name"
    );
    res.status(200).json(result.rows);
  } catch (err) {
    res.status(500).json({ error: "Error al listar los permisos." });
  } finally {
    client.release();
  }
};

// Actualizar Permiso
exports.updatePermission = async (req, res) => {
  const { permissionId } = req.params;
  const { name, description } = req.body;

  const client = await pool.connect();
  try {
    await client.query(
      "UPDATE permissions SET name = $1, description = $2, updated_at = NOW() WHERE id = $3",
      [name, description, permissionId]
    );
    res.status(200).json({ message: "Permiso actualizado exitosamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al actualizar el permiso." });
  } finally {
    client.release();
  }
};

// Eliminar Permiso (Borrado Lógico)
exports.deletePermission = async (req, res) => {
  const { permissionId } = req.params;

  const client = await pool.connect();
  try {
    await client.query(
      "UPDATE permissions SET deleted_at = NOW() WHERE id = $1",
      [permissionId]
    );
    res.status(200).json({ message: "Permiso eliminado lógicamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al eliminar el permiso." });
  } finally {
    client.release();
  }
};

// Eliminar Permiso (Borrado Físico)
exports.deletePermissionPermanently = async (req, res) => {
  const { permissionId } = req.params;

  const client = await pool.connect();
  try {
    await client.query("DELETE FROM permissions WHERE id = $1", [permissionId]);
    res.status(200).json({ message: "Permiso eliminado permanentemente." });
  } catch (err) {
    res
      .status(500)
      .json({ error: "Error al eliminar el permiso permanentemente." });
  } finally {
    client.release();
  }
};

// ================================
// Asignaciones
// ================================

// Asignar Rol a Usuario
exports.assignRoleToUser = async (req, res) => {
  const { userId, roleId } = req.body;

  const client = await pool.connect();
  try {
    await client.query(
      "INSERT INTO user_roles (user_id, role_id) VALUES ($1, $2)",
      [userId, roleId]
    );
    res.status(200).json({ message: "Rol asignado al usuario exitosamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al asignar el rol al usuario." });
  } finally {
    client.release();
  }
};

// Remover Rol de Usuario
exports.removeRoleFromUser = async (req, res) => {
  const { userId, roleId } = req.body;

  const client = await pool.connect();
  try {
    await client.query(
      "DELETE FROM user_roles WHERE user_id = $1 AND role_id = $2",
      [userId, roleId]
    );
    res.status(200).json({ message: "Rol removido del usuario exitosamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al remover el rol del usuario." });
  } finally {
    client.release();
  }
};

// Asignar Permiso a Rol
exports.assignPermissionToRole = async (req, res) => {
  const { role_id, permission_id } = req.body;
  const client = await pool.connect();
  try {
    await client.query(
      "INSERT INTO role_permissions (role_id, permission_id) VALUES ($1, $2)",
      [role_id, permission_id]
    );
    res.status(200).json({ message: "Permiso asignado al rol exitosamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al asignar el permiso al rol." });
  } finally {
    client.release();
  }
};

// Remover Permiso de Rol
exports.removePermissionFromRole = async (req, res) => {
  const { roleId, permissionId } = req.body;

  const client = await pool.connect();
  try {
    await client.query(
      "DELETE FROM role_permissions WHERE role_id = $1 AND permission_id = $2",
      [roleId, permissionId]
    );
    res.status(200).json({ message: "Permiso removido del rol exitosamente." });
  } catch (err) {
    res.status(500).json({ error: "Error al remover el permiso del rol." });
  } finally {
    client.release();
  }
};

// ================================
// Login y Logout
// ================================

exports.prueba = async (req, res) => {
  res.status(200).json({ message: "Prueba exitosa." });
};
// Login
exports.login = async (req, res) => {
  const { username, password } = req.body;
  const ip = req.headers["x-forwarded-for"] || req.connection.remoteAddress; // Obtener IPv4

  const client = await pool.connect();
  try {
    console.log("🔍 Verificando sesiones activas para:", username);

    // Verificar si el usuario ya tiene una sesión activa en la tabla sessions
    const activeSession = await client.query(
      "SELECT * FROM sessions WHERE user_id = (SELECT id FROM users WHERE email = $1) AND is_revoked = false",
      [username]
    );

    if (activeSession.rows.length > 0) {
      const session = activeSession.rows[0];
      const sessionExpiration = moment.tz(
        session.expires_at,
        "America/Caracas"
      ); // Convertir a America/Caracas
      const currentTime = moment.tz("America/Caracas"); // Obtener hora actual en America/Caracas

      console.log(
        "session.expires_at (America/Caracas): ",
        sessionExpiration.format()
      );
      console.log("currentTime (America/Caracas): ", currentTime.format());

      if (currentTime.isBefore(sessionExpiration)) {
        console.log(1);
        // Si la sesión no ha expirado, no permitir el acceso
        console.log("🔒 Sesión ya activa y no ha expirado para:", username);
        return res.status(403).json({
          error: "La sesión del usuario ya está abierta y no ha expirado.",
        });
      } else {
        // Marcar la sesión como revocada
        console.log(2);
        await client.query(
          "UPDATE sessions SET is_revoked = true WHERE id = $1",
          [session.id]
        );
        console.log("🔓 Sesión expirada revocada para:", username);
      }
    }

    console.log("👤 Buscando usuario:", username);
    // Buscar al usuario por nombre de usuario
    const result = await client.query(
      "SELECT id, password_hash, status, failed_login_attempts, last_failed_login FROM users WHERE email = $1",
      [username]
    );

    if (!result.rows.length) {
      console.log("❌ Usuario no encontrado:", username);
      await client.query(
        "INSERT INTO login_logs (username, ip_address, login_status) VALUES ($1, $2, $3)",
        [username, ip, "failed"]
      );
      return res
        .status(400)
        .json({ error: "Nombre de usuario o contraseña incorrectos." });
    }

    const user = result.rows[0];

    // Verificar si el usuario está dado de baja
    if (user.status === "deleted") {
      console.log("🗑️ Usuario dado de baja:", username);
      await client.query(
        "INSERT INTO login_logs (username, ip_address, login_status) VALUES ($1, $2, $3)",
        [username, ip, "failed"]
      );
      return res
        .status(403)
        .json({ error: "El usuario ha sido dado de baja." });
    }

    // Verificar si el usuario está suspendido
    if (user.status === "suspended") {
      console.log("🚫 Usuario suspendido:", username);
      await client.query(
        "INSERT INTO login_logs (username, ip_address, login_status) VALUES ($1, $2, $3)",
        [username, ip, "failed"]
      );
      return res.status(403).json({ error: "El usuario está suspendido." });
    }

    // Verificar si el usuario tiene más de 3 intentos fallidos
    if (
      user.failed_login_attempts >= 3 &&
      moment
        .tz(user.last_failed_login, "America/Caracas")
        .isAfter(moment.tz("America/Caracas").subtract(15, "minutes"))
    ) {
      console.log(
        "⏰ Usuario bloqueado por múltiples intentos fallidos:",
        username
      );
      await client.query("UPDATE users SET status = $1 WHERE id = $2", [
        "suspended",
        user.id,
      ]);
      await client.query(
        "INSERT INTO login_logs (username, ip_address, login_status) VALUES ($1, $2, $3)",
        [username, ip, "blocked"]
      );
      return res.status(403).json({
        error:
          "El usuario ha sido bloqueado debido a múltiples intentos fallidos.",
      });
    }

    console.log("🔐 Comparando contraseña...");
    // Comparar la contraseña
    const isMatch = await comparePassword(password, user.password_hash);

    if (!isMatch) {
      console.log("⚠️ Contraseña incorrecta:", username);
      await client.query(
        "UPDATE users SET failed_login_attempts = failed_login_attempts + 1, last_failed_login = NOW() WHERE id = $1",
        [user.id]
      );

      await client.query(
        "INSERT INTO login_logs (username, ip_address, login_status) VALUES ($1, $2, $3)",
        [username, ip, "failed"]
      );
      return res
        .status(400)
        .json({ error: "Nombre de usuario o contraseña incorrectos." });
    }

    console.log("🔄 Reiniciando contador de intentos fallidos...");
    // Reiniciar el contador de intentos fallidos
    await client.query(
      "UPDATE users SET failed_login_attempts = 0, last_failed_login = NULL WHERE id = $1",
      [user.id]
    );

    console.log("⏳ Obteniendo duración de sesión...");
    // Obtener duración de sesión (personalizada o global)
    let timeoutMin = await getSessionTimeout(user.id);
    console.log("timeoutMin: ", timeoutMin);
    console.log("⏰ Duración de sesión:", timeoutMin, "minutos");

    console.log("🔑 Generando token JWT...");
    // Generar token JWT
    //////////////////////////
    const sessionDuration = timeoutMin;
    const expiresInSeconds = sessionDuration * 60;
    const expiresAt = new Date(Date.now() + expiresInSeconds * 1000);
    //////////////////////////
    // const token = await generateToken(user.id);
    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, {
      expiresIn: expiresInSeconds,
    });

    const frontendSessionDuration = (expiresInSeconds - previousTime) / 60;
    await client.query(
      "INSERT INTO sessions (user_id, token, expires_at) VALUES ($1, $2, CURRENT_TIMESTAMP + $3 * INTERVAL '1 minute')",
      [user.id, token, parseInt(timeoutMin, 10)]
    );
    // Obtener permisos del usuario
    console.log("🔍 Obteniendo permisos del usuario...");
    const permissionsQuery = `
            SELECT p.name, p.description,p.action 
            FROM user_permissions up
            JOIN permissions p ON up.permission_id = p.id
            WHERE up.user_id = $1
            UNION
            SELECT p.name, p.description,p.action 
            FROM user_roles ur
            JOIN role_permissions rp ON ur.role_id = rp.role_id
            JOIN permissions p ON rp.permission_id = p.id
            WHERE ur.user_id = $1
            AND NOT EXISTS (
                SELECT 1 FROM user_permissions WHERE user_id = $1
            )
        `;

    const permissionsResult = await client.query(permissionsQuery, [user.id]);
    const permissions = permissionsResult.rows;
    // Obtener rol del usuario
    console.log("🔍 Obteniendo permisos del usuario...");
    const roleQuery = `
                SELECT a.name FROM roles a
                LEFT JOIN user_roles b ON b.user_id = a.id
                WHERE b.user_id = $1
        `;

    const roleResult = await client.query(roleQuery, [user.id]);
    const role = roleResult.rows[0].name;
    // Registrar ingreso exitoso en la auditoría
    await client.query(
      "INSERT INTO login_logs (user_id, username, ip_address, login_status, session_token) VALUES ($1, $2, $3, $4, $5)",
      [user.id, username, ip, "success", token]
    );
    console.log("✅ Registrando login exitoso...");
    // Registrar ingreso exitoso en la auditoría
    await client.query(
      "INSERT INTO login_logs (user_id, username, ip_address, login_status, session_token) VALUES ($1, $2, $3, $4, $5)",
      [user.id, username, ip, "success", token]
    );

    res.status(200).json({
      message: "Inicio de sesión exitoso.",
      token,
      sessionDuration: frontendSessionDuration,
      role,
      permissions,
    });
  } catch (err) {
    console.error("❌ Error en login:", err.message);
    res.status(500).json({ error: "Error en el inicio de sesión." });
  } finally {
    client.release();
  }
};
// Logout
exports.logout = async (req, res) => {
  const token = req.header("Authorization")?.split(" ")[1];
  if (!token) {
    return res.status(400).json({ error: "No se proporcionó un token." });
  }

  const decoded = jwt.decode(token);
  const userId = decoded.userId;

  const client = await pool.connect();
  try {
    // Marcar la sesión como cerrada por logout
    await client.query(
      "UPDATE login_logs SET logout_type = $1, logout_timestamp = NOW() WHERE session_token = $2",
      ["logout", token]
    );
    await client.query("UPDATE sessions SET is_revoked = $1 WHERE token = $2", [
      true,
      token,
    ]);
    // Agregar el token a la lista negra
    const expiresAt = new Date(decoded.exp * 1000);
    await client.query(
      "INSERT INTO blacklisted_tokens (token, expires_at) VALUES ($1, $2)",
      [token, expiresAt]
    );

    res.status(200).json({ message: "Cierre de sesión exitoso." });
  } catch (err) {
    res.status(500).json({ error: "Error al cerrar sesión." });
  } finally {
    client.release();
  }
};
///////////////
exports.forceLogout = async (req, res) => {
  const userId = req.body.userId;
  const client = await pool.connect();
  try {
    await client.query("BEGIN"); // Iniciar la transacción

    await client.query(
      "UPDATE login_logs SET logout_type = $1, logout_timestamp = NOW() WHERE user_id = $2",
      ["force logout", userId]
    );

    await client.query(
      "UPDATE sessions SET is_revoked = $1 WHERE user_id = $2",
      [true, userId]
    );

    await client.query("COMMIT"); // Confirmar la transacción
    res.status(200).json({ message: "Cierre forzoso de sesión exitoso." });
  } catch (err) {
    await client.query("ROLLBACK"); // Revertir la transacción en caso de error
    res.status(500).json({ error: "Error al cerrar sesión." });
  } finally {
    client.release();
  }
};
///////////////
////////////MANTENEDORES/////////////////
// ================================
// Revistas
// ================================
// Upload portada
exports.uploadPortada = [
  upload.single("portada"),
  async (req, res) => {
    if (!req.file) {
      return res
        .status(400)
        .json({ error: "No se proporcionó un archivo válido" });
    }

    const { id } = req.params;

    // Compute next sequential filename
    const getNextPortadaFilename = () => {
      const dir = path.join(__dirname, "../public/portadas");
      const files = fs.readdirSync(dir);
      let max = 0;
      files.forEach((f) => {
        const match = f.match(/revista(\d+)\.jpg$/i);
        if (match) {
          const num = parseInt(match[1], 10);
          if (num > max) max = num;
        }
      });
      const nextNum = max + 1;
      const padded = nextNum.toString().padStart(2, "0");
      return `revista${padded}.jpg`;
    };

    const newFilename = getNextPortadaFilename();
    const destPath = path.join(__dirname, "../public/portadas", newFilename);

    try {
      // Move uploaded file to the sequential filename
      fs.renameSync(req.file.path, destPath);

      // Update DB with the new filename
      const client = await pool.connect();
      try {
        const result = await client.query(
          "UPDATE revistas SET portada = $1 WHERE id = $2 RETURNING *",
          [newFilename, id]
        );
        res.status(200).json({
          message: "Portada subida exitosamente",
          filename: newFilename,
        });
      } finally {
        client.release();
      }
    } catch (err) {
      console.error("Error al procesar la portada:", err);
      res.status(500).json({ error: "Error al subir la portada" });
    }
  },
];
// Insertar revista
exports.insertRevista = async (req, res) => {
  const insertFields = req.body; // Campos a insertar
  // Ensure portada field exists; if not, set to null
  if (!('portada' in insertFields)) {
    insertFields.portada = null;
  }

  // Lista de columnas que deben estar en minúsculas
  const columnasMinusculas = ["correo_revista", "correo_editor", "url"];

  // Convertir cadenas a mayúsculas o minúsculas según corresponda
  for (const key in insertFields) {
    if (typeof insertFields[key] === "string") {
      if (columnasMinusculas.includes(key)) {
        // Forzar a minúsculas para columnas específicas
        insertFields[key] = insertFields[key].toLowerCase();
      } else {
        // Convertir a mayúsculas para el resto de las columnas
        insertFields[key] = insertFields[key].toUpperCase();
      }
    }
  }

  const client = await pool.connect();
  try {
    // Construir la consulta dinámicamente
    const keys = Object.keys(insertFields);
    if (keys.length === 0) {
      return res
        .status(400)
        .json({ error: "No se proporcionaron campos para insertar." });
    }

    const columns = keys.join(", ");
    // Corregir los placeholders para usar $1, $2, etc.
    const placeholders = keys.map((_, index) => `$${index + 1}`).join(", ");
    const values = keys.map((key) => insertFields[key]);

    const query = `
            INSERT INTO revistas (${columns})
            VALUES (${placeholders})
            RETURNING *;
        `;

    // console.log('Consulta SQL:', query); // Para depuración
    // console.log('Valores:', values); // Para depuración

    // Ejecutar la consulta
    const result = await client.query(query, values);

    if (result.rows.length === 0) {
      console.log("No se pudo insertar la revista.");
      return res.status(500).json({ error: "Error al insertar la revista." });
    }

    console.log("Revista insertada:", result.rows[0]);
    res.status(201).json({
      message: "Revista insertada exitosamente.",
      revista: result.rows[0],
    });
  } catch (err) {
    console.error("Error al insertar la revista:", err);
    res.status(500).json({ error: "Error al insertar la revista." });
  } finally {
    client.release();
  }
};

// Actualizar Revista (PATCH)

exports.updateRevista = async (req, res) => {
  const { id } = req.params; // ID de la revista a editar
  const updateFields = req.body; // Campos a actualizar

  // Si el campo portada existe, procesarlo
  if (updateFields.portada) {
    const match = updateFields.portada.match(/\/([^\/?]+)\?/); // Extraer el nombre del archivo antes del '?'
    if (match && match[1]) {
      updateFields.portada = match[1].toLowerCase(); // Convertir a minúsculas
    }
  }

  // Lista de columnas que deben estar en minúsculas
  const columnasMinusculas = [
    "correo_revista",
    "correo_editor",
    "url",
    "portada",
  ];

  // Convertir cadenas a mayúsculas o minúsculas según corresponda
  for (const key in updateFields) {
    if (typeof updateFields[key] === "string") {
      if (columnasMinusculas.includes(key)) {
        // Forzar a minúsculas para columnas específicas
        updateFields[key] = updateFields[key].toLowerCase();
      } else {
        // Convertir a mayúsculas para el resto de las columnas
        updateFields[key] = updateFields[key].toUpperCase();
      }
    }
  }

  const client = await pool.connect();
  try {
    // Construir la consulta dinámicamente
    const keys = Object.keys(updateFields);
    if (keys.length === 0) {
      return res
        .status(400)
        .json({ error: "No se proporcionaron campos para actualizar." });
    }

    const setClause = keys
      .map((key, index) => `${key} = $${index + 1}`)
      .join(", ");
    const values = keys.map((key) => updateFields[key]);
    values.push(id); // Añadir el ID al final de los valores

    const query = `
            UPDATE revistas
            SET ${setClause}
            WHERE id = $${values.length}
            RETURNING *;
        `;

    // Ejecutar la consulta
    const result = await client.query(query, values);

    if (result.rows.length === 0) {
      console.log("No se encontró la revista con ID:", id);
      return res.status(404).json({ error: "Revista no encontrada." });
    }

    console.log("Revista actualizada:", result.rows[0]);
    res.status(200).json({
      message: "Revista actualizada exitosamente.",
      revista: result.rows[0],
    });
  } catch (err) {
    console.error("Error al actualizar la revista:", err);
    res.status(500).json({ error: "Error al actualizar la revista." });
  } finally {
    client.release();
  }
};
////////////SESIONES/////////////////
// Obtener configuración global de sesión
exports.getGlobalSessionTimeout = async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT global_timeout FROM session_settings WHERE id = 1"
    );

    if (result.rows.length === 0) {
      return res
        .status(404)
        .json({ error: "Configuración global no encontrada" });
    }

    res.json({ timeout: result.rows[0].global_timeout });
  } catch (err) {
    console.error("❌ Error al obtener configuración global:", err.message);
    res
      .status(500)
      .json({ error: "Error al obtener la configuración global de sesión" });
  }
};
// Actualizar configuración global de sesión
exports.updateGlobalSessionTimeout = async (req, res) => {
  const { timeout } = req.body;

  if (!timeout || typeof timeout !== "number" || timeout <= 0) {
    return res
      .status(400)
      .json({ error: "La duración debe ser un número positivo." });
  }

  try {
    await pool.query(
      "UPDATE session_settings SET global_timeout = $1 WHERE id = 1",
      [timeout]
    );

    res.json({
      message: "Duración global de sesión actualizada exitosamente.",
    });
  } catch (err) {
    console.error("❌ Error al actualizar configuración global:", err.message);
    res
      .status(500)
      .json({ error: "Error al actualizar la duración global de sesión" });
  }
};
// Actualizar duración de sesión específica para usuario
exports.updateUserSessionTimeout = async (req, res) => {
  const { userId } = req.params;
  const { timeout } = req.body;

  if (!timeout || typeof timeout !== "number" || timeout <= 0) {
    return res
      .status(400)
      .json({ error: "La duración debe ser un número positivo." });
  }

  try {
    const userExists = await pool.query("SELECT id FROM users WHERE id = $1", [
      userId,
    ]);
    if (userExists.rows.length === 0) {
      return res.status(404).json({ error: "Usuario no encontrado." });
    }

    await pool.query(
      "UPDATE users SET session_timeout_min = $1 WHERE id = $2",
      [timeout, userId]
    );

    res.json({
      message: "Duración de sesión del usuario actualizada exitosamente",
    });
  } catch (err) {
    console.error("❌ Error al actualizar sesión de usuario:", err.message);
    res
      .status(500)
      .json({ error: "Error al actualizar la duración de sesión del usuario" });
  }
};
// Actualizar duración de sesión específica para rol
exports.updateRoleSessionTimeout = async (req, res) => {
  const { roleId } = req.params;
  const { timeout } = req.body;

  if (!timeout || typeof timeout !== "number" || timeout <= 0) {
    return res
      .status(400)
      .json({ error: "La duración debe ser un número positivo." });
  }

  try {
    const roleExists = await pool.query("SELECT id FROM roles WHERE id = $1", [
      roleId,
    ]);
    if (roleExists.rows.length === 0) {
      return res.status(404).json({ error: "Rol no encontrado." });
    }

    await pool.query(
      "UPDATE roles SET session_timeout_min = $1 WHERE id = $2",
      [timeout, roleId]
    );

    res.json({
      message: "Duración de sesión del rol actualizada exitosamente",
    });
  } catch (err) {
    console.error("❌ Error al actualizar sesión de rol:", err.message);
    res
      .status(500)
      .json({ error: "Error al actualizar la duración de sesión del rol" });
  }
};
