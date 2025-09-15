// create-admin.js


const { hashPassword } = require('./src/utils');


// Datos del administrador
const adminUser = {
  firstName: 'Admin',
  lastName: 'Principal',
  cedula: 12345678,
  email: 'admin@example.com',
  password: 'Admin123$',
};


async function main() {
  // Hash de la contraseña
  const hashedPassword = await hashPassword(adminUser.password);
  console.log('Hashed password:', hashedPassword);
}

main();