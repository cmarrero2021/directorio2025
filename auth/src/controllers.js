const jwt = require("jsonwebtoken");
const pool = require("./db");
const {
  hashPassword,
  comparePassword,
  generateToken, // may be used elsewhere
  generateSecureToken,
  sendEmail,
  validatePassword,
  getSessionTimeout,
} = require("./utils");
const multer = require("multer");
const path = require("path");
const fs = require("fs");
const moment = require("moment-timezone");

// Ensure destination directory exists
function ensureDir(dir) {
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
}

// Multer configuration (10 MB max)
const uploadStorage = multer.diskStorage({
  destination: function (req, file, cb) {
    const dir = path.join(__dirname, "../../back/public/portadas");
    ensureDir(dir);
    cb(null, dir);
  },
  filename: function (req, file, cb) {
    cb(null, file.originalname);
  },
});
const uploadAny = multer({
  storage: uploadStorage,
  limits: { fileSize: 1024 * 1024 * 10 },
}).any();

// Simple health/prueba endpoint
exports.prueba = async (req, res) => {
  res.status(200).json({ message: "Prueba exitosa." });
};

// Endpoint de prueba para upload de archivos (sin DB)
exports.testUpload = [
  uploadAny,
  async (req, res) => {
    try {
      const file = req.file || (Array.isArray(req.files) && req.files[0]);
      if (!file) {
        return res.status(400).json({ error: "No se proporcionó archivo" });
      }
      res.status(200).json({ filename: file.originalname });
    } catch (err) {
      console.error("[testUpload] Error:", err);
      res.status(500).json({ error: "Error al subir el archivo" });
    }
  },
];

// Upload de portada y actualización en DB (revistas.portada)
exports.uploadPortada = [
  uploadAny,
  async (req, res) => {
    const { id } = req.params;
    if (!id) {
      return res.status(400).json({ error: "ID de revista es requerido" });
    }

    const file = req.file || (Array.isArray(req.files) && req.files[0]);
    if (!file) {
      return res.status(400).json({ error: "No se proporcionó archivo" });
    }

    const originalFilename = file.originalname;
    const client = await pool.connect();

    try {
      const result = await client.query(
        "UPDATE revistas SET portada = $1 WHERE id = $2 RETURNING *",
        [originalFilename, id]
      );

      if (!result.rows.length) {
        return res.status(404).json({ error: "Revista no encontrada" });
      }

      res.status(200).json({
        message: "Portada subida y actualizada exitosamente",
        filename: originalFilename,
        revista: result.rows[0],
      });
    } catch (err) {
      // Eliminar archivo subido si la DB falla
      try {
        const f = req.file || (Array.isArray(req.files) && req.files[0]);
        if (f?.path && fs.existsSync(f.path)) {
          fs.unlinkSync(f.path);
        }
      } catch (unlinkErr) {
        console.error("[uploadPortada] Error al eliminar archivo temporal:", unlinkErr);
      }
      console.error("[uploadPortada] Error:", err);
      res.status(500).json({ error: "Error al subir la portada" });
    } finally {
      client.release();
    }
  },
];

// Cambio rápido de contraseña
exports.fastChangePassworwd = async (req, res) => {
  const { email, password } = req.body;

  const passwordErrors = validatePassword(password);
  if (passwordErrors.length > 0) {
    return res.status(400).json({ errors: passwordErrors });
  }

  const hashedPassword = await hashPassword(password);

  const client = await pool.connect();
  try {
    await client.query(
      "UPDATE users SET password_hash = $2 where email = $1",
      [email, hashedPassword]
    );
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
    if (!result.rows.length || new Date(result.rows[0].expires_at) < new Date()) {
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

  const passwordErrors = validatePassword(newPassword);
  if (passwordErrors.length > 0) {
    return res.status(400).json({ errors: passwordErrors });
  }

  const client = await pool.connect();
  try {
    const result = await client.query(
      "SELECT password_hash FROM users WHERE id = $1",
      [userId]
    );
    const isMatch = await comparePassword(
      oldPassword,
      result.rows[0].password_hash
    );
    if (!isMatch) {
      return res.status(400).json({ error: "La contraseña actual es incorrecta." });
    }

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

// Login
exports.login = async (req, res) => {
  const { username, password } = req.body;
  const ip = req.headers["x-forwarded-for"] || req.connection.remoteAddress;

  const client = await pool.connect();
  try {
    // Sesión activa no expirada
    const activeSession = await client.query(
      "SELECT * FROM sessions WHERE user_id = (SELECT id FROM users WHERE email = $1) AND is_revoked = false",
      [username]
    );

    if (activeSession.rows.length > 0) {
      const session = activeSession.rows[0];
      const sessionExpiration = moment.tz(session.expires_at, "America/Caracas");
      const currentTime = moment.tz("America/Caracas");
      if (currentTime.isBefore(sessionExpiration)) {
        return res.status(403).json({
          error: "La sesión del usuario ya está abierta y no ha expirado.",
        });
      } else {
        await client.query("UPDATE sessions SET is_revoked = true WHERE id = $1", [
          session.id,
        ]);
      }
    }

    // Buscar usuario
    const result = await client.query(
      "SELECT id, password_hash, status, failed_login_attempts, last_failed_login FROM users WHERE email = $1",
      [username]
    );

    if (!result.rows.length) {
      await client.query(
        "INSERT INTO login_logs (username, ip_address, login_status) VALUES ($1, $2, $3)",
        [username, ip, "failed"]
      );
      return res
        .status(400)
        .json({ error: "Nombre de usuario o contraseña incorrectos." });
    }

    const user = result.rows[0];

    // Estados de usuario
    if (user.status === "deleted") {
      await client.query(
        "INSERT INTO login_logs (username, ip_address, login_status) VALUES ($1, $2, $3)",
        [username, ip, "failed"]
      );
      return res.status(403).json({ error: "El usuario ha sido dado de baja." });
    }
    if (user.status === "suspended") {
      await client.query(
        "INSERT INTO login_logs (username, ip_address, login_status) VALUES ($1, $2, $3)",
        [username, ip, "failed"]
      );
      return res.status(403).json({ error: "El usuario está suspendido." });
    }

    // Intentos fallidos recientes
    if (
      user.failed_login_attempts >= 3 &&
      moment
        .tz(user.last_failed_login, "America/Caracas")
        .isAfter(moment.tz("America/Caracas").subtract(15, "minutes"))
    ) {
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

    // Verificar password
    const isMatch = await comparePassword(password, user.password_hash);
    if (!isMatch) {
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

    // Reiniciar contador de intentos fallidos
    await client.query(
      "UPDATE users SET failed_login_attempts = 0, last_failed_login = NULL WHERE id = $1",
      [user.id]
    );

    // Duración de sesión
    const timeoutMin = await getSessionTimeout(user.id);
    const expiresInSeconds = Math.max(parseInt(timeoutMin, 10) || 20, 1) * 60; // fallback seguro
    const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, {
      expiresIn: expiresInSeconds,
    });

    // Registrar sesión
    await client.query(
      "INSERT INTO sessions (user_id, token, expires_at) VALUES ($1, $2, CURRENT_TIMESTAMP + $3 * INTERVAL '1 minute')",
      [user.id, token, parseInt(timeoutMin, 10) || 20]
    );

    // Permisos del usuario
    const permissionsQuery = `
      SELECT p.name, p.description, p.action 
      FROM user_permissions up
      JOIN permissions p ON up.permission_id = p.id
      WHERE up.user_id = $1
      UNION
      SELECT p.name, p.description, p.action 
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

    // Rol del usuario
    const roleQuery = `
      SELECT r.name
      FROM roles r
      JOIN user_roles ur ON ur.role_id = r.id
      WHERE ur.user_id = $1
      LIMIT 1
    `;
    const roleResult = await client.query(roleQuery, [user.id]);
    const role = roleResult.rows[0]?.name || null;

    // Auditoría
    await client.query(
      "INSERT INTO login_logs (user_id, username, ip_address, login_status, session_token) VALUES ($1, $2, $3, $4, $5)",
      [user.id, username, ip, "success", token]
    );

    res.status(200).json({
      message: "Inicio de sesión exitoso.",
      token,
      sessionDuration: expiresInSeconds / 60,
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
  const userId = decoded?.userId;

  const client = await pool.connect();
  try {
    await client.query(
      "UPDATE login_logs SET logout_type = $1, logout_timestamp = NOW() WHERE session_token = $2",
      ["logout", token]
    );
    await client.query("UPDATE sessions SET is_revoked = $1 WHERE token = $2", [
      true,
      token,
    ]);

    if (decoded?.exp) {
      const expiresAt = new Date(decoded.exp * 1000);
      await client.query(
        "INSERT INTO blacklisted_tokens (token, expires_at) VALUES ($1, $2)",
        [token, expiresAt]
      );
    }

    res.status(200).json({ message: "Cierre de sesión exitoso." });
  } catch (err) {
    res.status(500).json({ error: "Error al cerrar sesión." });
  } finally {
    client.release();
  }
};

// Logout forzado
exports.forceLogout = async (req, res) => {
  const userId = req.body.userId;
  const client = await pool.connect();
  try {
    await client.query("BEGIN");

    await client.query(
      "UPDATE login_logs SET logout_type = $1, logout_timestamp = NOW() WHERE user_id = $2",
      ["force logout", userId]
    );

    await client.query(
      "UPDATE sessions SET is_revoked = $1 WHERE user_id = $2",
      [true, userId]
    );

    await client.query("COMMIT");
    res.status(200).json({ message: "Cierre forzoso de sesión exitoso." });
  } catch (err) {
    await client.query("ROLLBACK");
    res.status(500).json({ error: "Error al cerrar sesión." });
  } finally {
    client.release();
  }
};

// Insertar revista (con upload de portada opcional)
exports.insertRevista = [
  uploadAny,
  async (req, res) => {
    const insertFields = req.body || {};

    // Si viene archivo, usar su nombre como portada (el archivo ya fue guardado por multer)
    const file = req.file || (Array.isArray(req.files) && req.files[0]);
    if (file) {
      insertFields.portada = file.originalname;
    } else if (!("portada" in insertFields)) {
      insertFields.portada = null;
    }

    // Campos a forzar en minúsculas
    const columnasMinusculas = ["correo_revista", "correo_editor", "url"];

    for (const key in insertFields) {
      if (typeof insertFields[key] === "string") {
        if (columnasMinusculas.includes(key)) {
          insertFields[key] = insertFields[key].toLowerCase();
        } else {
          insertFields[key] = insertFields[key].toUpperCase();
        }
      }
    }

    const client = await pool.connect();
    try {
      const keys = Object.keys(insertFields);
      if (keys.length === 0) {
        return res
          .status(400)
          .json({ error: "No se proporcionaron campos para insertar." });
      }

      const columns = keys.join(", ");
      const placeholders = keys.map((_, index) => `${index + 1}`).join(", ");
      const values = keys.map((key) => insertFields[key]);

      const query = `
        INSERT INTO revistas (${columns})
        VALUES (${placeholders})
        RETURNING *;
      `;

      const result = await client.query(query, values);

      if (result.rows.length === 0) {
        return res.status(500).json({ error: "Error al insertar la revista." });
      }

      res.status(201).json({
        message: "Revista insertada exitosamente.",
        revista: result.rows[0],
        filename: file ? file.originalname : null,
      });
    } catch (err) {
      console.error("Error al insertar la revista:", err);
      // Si ocurrió un error y se subió archivo, eliminarlo
      try {
        if (file?.path && fs.existsSync(file.path)) {
          fs.unlinkSync(file.path);
        }
      } catch (unlinkErr) {
        console.error("[insertRevista] Error al eliminar archivo temporal:", unlinkErr);
      }
      res.status(500).json({ error: "Error al insertar la revista." });
    } finally {
      client.release();
    }
  },
];

// Actualizar revista (PATCH)
exports.updateRevista = async (req, res) => {
  const { id } = req.params;
  const updateFields = req.body;

  if (updateFields.portada) {
    const match = updateFields.portada.match(/\/([^\/?]+)\?/);
    if (match && match[1]) {
      updateFields.portada = match[1].toLowerCase();
    }
  }

  const columnasMinusculas = [
    "correo_revista",
    "correo_editor",
    "url",
    "portada",
  ];

  for (const key in updateFields) {
    if (typeof updateFields[key] === "string") {
      if (columnasMinusculas.includes(key)) {
        updateFields[key] = updateFields[key].toLowerCase();
      } else {
        updateFields[key] = updateFields[key].toUpperCase();
      }
    }
  }

  const client = await pool.connect();
  try {
    const keys = Object.keys(updateFields);
    if (keys.length === 0) {
      return res
        .status(400)
        .json({ error: "No se proporcionaron campos para actualizar." });
    }

    const setClause = keys.map((key, index) => `${key} = $${index + 1}`).join(", ");
    const values = keys.map((key) => updateFields[key]);
    values.push(id);

    const query = `
      UPDATE revistas
      SET ${setClause}
      WHERE id = $${values.length}
      RETURNING *;
    `;

    const result = await client.query(query, values);

    if (result.rows.length === 0) {
      return res.status(404).json({ error: "Revista no encontrada." });
    }

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

// ================================
// Configuración de sesión
// ================================

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

// ================================
// Placeholders para endpoints no implementados en este refactor
// ================================

exports.createUser = async (req, res) => {
  res.status(501).json({ error: "createUser no implementado en este servidor." });
};

exports.assignPermissionToRole = async (req, res) => {
  res
    .status(501)
    .json({ error: "assignPermissionToRole no implementado en este servidor." });
};
