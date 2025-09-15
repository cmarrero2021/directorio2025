const path = require('path');
require('dotenv').config({ path: path.resolve(process.cwd(), '.env') });
const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors'); // Importar el paquete cors
const routes = require('./routes');
const pool = require('./db');
const listEndpoints = require('./endpointlister'); // Importar la función listEndpoints

dotenv.config();

const app = express();

// Configuración de CORS
app.use(cors({
    // origin: '*', // Cambia esto al dominio de tu frontend (Quasar)
    origin: 'http://localhost:9000', // Cambia esto al dominio de tu frontend (Quasar)
    methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'], // Métodos permitidos
    allowedHeaders: ['Content-Type', 'Authorization'], // Cabeceras permitidas
    credentials: true // Permite el envío de credenciales (cookies, tokens, etc.)
}));

// Middleware para parsear JSON
app.use(express.json());
// Servir archivos estáticos desde la carpeta uploads
// app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/public/portadas', express.static(path.join(__dirname, 'uploads')));
// Rutas
// app.use('/api', routes);
app.use('/auth', routes);

// Endpoint para listar rutas (sin autenticación)
app.get('/list-endpoints', (req, res) => {
    const endpoints = listEndpoints(app); // Llamar a la función para listar endpoints
    res.json(endpoints);
});

const PORT = process.env.PORT || 3001;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});