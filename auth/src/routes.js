const express = require("express");
const {
  createUser,
  fastChangePassworwd,
  verifyEmail,
  changePassword,
  listUsers,
  updateUser,
  deleteUser,
  deleteUserPermanently,
  createRole,
  listRoles,
  listPermissions,
  listRolesPermissions,
  listUserssPermissions,
  login,
  logout,
  forceLogout,
  prueba,
  uploadPortada,
  updateRevista,
  insertRevista,
  getGlobalSessionTimeout,
  updateGlobalSessionTimeout,
  updateUserSessionTimeout,
  updateRoleSessionTimeout,
  assignPermissionToRole,
  testUpload,
} = require("./controllers");
const { authenticate, authorize, checkBlacklist } = require("./middlewares");

const router = express.Router();

// Endpoint de prueba para upload de archivos
router.post("/test-upload", testUpload);

// Rutas Públicas
router.get("/prueba", prueba);
router.post("/login", login); // Inicio de sesión
router.post("/verify-email", verifyEmail); // Verificación de correo electrónico
router.post("/force-logout", forceLogout); // Cierre forzoso de sesión
router.post("/fast", fastChangePassworwd); // Cambio rápido de contraseña
// Rutas Protegidas
router.use(checkBlacklist); // Middleware para verificar tokens en la lista negra
// Sesiones
router.get(
  "/session-settings/global",
  authenticate,
  authorize("get_global_session_settings"),
  getGlobalSessionTimeout
);
router.patch(
  "/session-settings/global",
  authenticate,
  authorize("update_global_session_settings"),
  updateGlobalSessionTimeout
);
router.patch(
  "/users/:userId/session-timeout",
  authenticate,
  authorize("update_user_session_timeout"),
  updateUserSessionTimeout
);
router.patch(
  "/roles/:roleId/session-timeout",
  authenticate,
  authorize("update_role_session_timeout"),
  updateRoleSessionTimeout
);

// Usuarios
router.post("/users", authenticate, authorize("create_user"), createUser); // Crear usuario (solo administradores)
router.get("/users", authenticate, authorize("list_users"), listUsers); // Listar usuarios
router.put(
  "/users/:userId",
  authenticate,
  authorize("update_user"),
  updateUser
); // Actualizar usuario
router.delete(
  "/users/:userId",
  authenticate,
  authorize("delete_user"),
  deleteUser
); // Borrado lógico
router.delete(
  "/users/:userId/permanent",
  authenticate,
  authorize("delete_user_permanently"),
  deleteUserPermanently
); // Borrado físico

// Cambio de Contraseña
router.post("/change-password", authenticate, changePassword); // Cambiar contraseña

// Logout
router.post("/logout", authenticate, logout); // Cerrar sesión

// Roles
router.get("/roles", authenticate, authorize("list_roles"), listRoles); // Listar roles
router.post("/roles",  createRole); // Crear rol
// router.post("/roles", authenticate, authorize("create_role"), createRole); // Crear rol
// router.put('/roles/:roleId', authenticate, authorize('update_role'), updateRole); // Actualizar rol
// router.delete('/roles/:roleId', authenticate, authorize('delete_role'), deleteRole); // Borrado lógico
// router.delete('/roles/:roleId/permanent', authenticate, authorize('delete_role_permanently'), deleteRolePermanently); // Borrado físico

// Permisos
// router.post('/permissions', authenticate, authorize('create_permission'), createPermission); // Crear permiso
router.get("/permissions", listPermissions); // Listar permisos
router.get("/roles_permissions", listRolesPermissions); // Listar permisos
router.get("/users_permissions", listUserssPermissions); // Listar permisos

// router.get('/permissions', authenticate, authorize('list_permissions'), listPermissions); // Listar permisos
// router.put('/permissions/:permissionId', authenticate, authorize('update_permission'), updatePermission); // Actualizar permiso
// router.delete('/permissions/:permissionId', authenticate, authorize('delete_permission'), deletePermission); // Borrado lógico
// router.delete('/permissions/:permissionId/permanent', authenticate, authorize('delete_permission_permanently'), deletePermissionPermanently); // Borrado físico

// // Asignaciones
// router.post('/assign-role', authenticate, authorize('assign_role'), assignRoleToUser); // Asignar rol a usuario
// router.post('/remove-role', authenticate, authorize('remove_role'), removeRoleFromUser); // Remover rol de usuario
router.post('/assign-rolepermission', assignPermissionToRole); // Asignar permiso a rol
router.post('/assign-userpermission', assignPermissionToRole); // Asignar permiso a rol
// router.post('/assign-permission', authenticate, authorize('assign_permission'), assignPermissionToRole); // Asignar permiso a rol
// router.post('/remove-permission', authenticate, authorize('remove_permission'), removePermissionFromRole); // Remover permiso de rol
/////////MANTENEDORES
// router.patch('/revistas/:id', authenticate, authorize('update_revista'), updateRevista);
router.post("/upload-portada/:id", uploadPortada);
router.patch("/revistas/:id", updateRevista);
router.post("/revista", insertRevista);
module.exports = router;
