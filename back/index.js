const express = require('express');
const { Pool, Client } = require('pg');
const cors = require('cors');
const path = require('path');
const WebSocket = require('ws');
const app = express();
const PORT = 3000;
// const PORT = 4000;

// Configuración CORS
// app.use(cors({ origin: '*', methods: ['GET', 'OPTIONS'], allowedHeaders: ['Content-Type'] }));
app.use(cors({ origin: '*' }));
// Middleware adicional para encabezados CORS
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  next();
});


// Configurar conexión a PostgreSQL para consultas regulares
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: '_api_revistas',
  password: 'postgres',
  port: 5432,
});

// Configurar cliente separado para escuchar notificaciones
const notificationClient = new Client({
  user: 'postgres',
  host: 'localhost',
  database: '_api_revistas',
  password: 'postgres',
  port: 5432,
});

// Iniciar servidor WebSocket
const server = app.listen(PORT, async () => {
  console.log(`API corriendo en http://localhost:${PORT}`);

  try {
    await notificationClient.connect();
    console.log('Conectado a PostgreSQL para escuchar notificaciones');
    notificationClient.query('LISTEN revistas_data_updates'); // Asegúrate de que el nombre del canal coincida
  } catch (err) {
    console.error('Error al conectar para notificaciones:', err);
  }
});

// Configurar WebSocket Server
const wss = new WebSocket.Server({ server });
wss.on('connection', (ws,req) => {
  const origin = req.headers.origin
  console.log('Nuevo cliente WebSocket conectado');
  ws.on('close', () => {
    console.log('Cliente WebSocket desconectado');
  });
});

// Manejar notificaciones de PostgreSQL
notificationClient.on('notification', (msg) => {
  console.log('Notificación recibida:', msg); // Agrega este registro
  try {
    const data = JSON.parse(msg.payload);
    console.log('Datos parseados:', data); // Agrega este registro
    wss.clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(JSON.stringify(data));
      }
    });
  } catch (err) {
    console.error('Error al procesar notificación:', err);
  }
});
/////////////////////////////////////////
const portadasPath = path.join(__dirname, 'public', 'portadas');

// Verificar si el directorio existe
const fs = require('fs');
if (!fs.existsSync(portadasPath)) {
  console.error(`ERROR: El directorio de portadas no existe en: ${portadasPath}`);
  console.log('Creando directorio...');
  fs.mkdirSync(portadasPath, { recursive: true });
}
// Configurar middleware para servir archivos estáticos
app.use('/portadas', express.static(portadasPath, {
  setHeaders: (res) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
  },
  fallthrough: false // Para manejar mejor los errores 404
}));

// Middleware para manejar errores cuando no se encuentra un archivo
app.use('/portadas', (req, res, next) => {
  res.status(404).json({ 
    error: 'Archivo no encontrado',
    message: `La imagen ${req.path} no existe en el servidor`
  });
});
/////////////////////////////////////////
// Ruta GET para obtener todas las revistas
app.get('/', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM revistas_data ORDER BY revista');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
//Ruta GET de prueba
app.get('/prueba', async (req, res) => {
  try {
     res.status(200).json({ message: 'Prueba exitosa.' });
  } catch (err) {
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los datos de la página de inicio pública
app.get('/inicio', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM inicio ORDER BY orden ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener las áreas de conocimiento de las revistas
app.get('/areas_revistas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT area_conocimiento FROM revistas_data ORDER BY area_conocimiento ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los índices de las revistas
app.get('/indices_revistas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT indice FROM revistas_data ORDER BY indice ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los idiomas de las revistas
app.get('/idiomas_revistas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT idioma FROM revistas_data ORDER BY idioma ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener las editoriales de las revistas
app.get('/editorial_revistas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT editorial FROM revistas_data ORDER BY editorial ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener las periodicidades de las revistas
app.get('/periodicidad_revistas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT periodicidad FROM revistas_data ORDER BY periodicidad ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los formatos de las revistas
app.get('/formato_revistas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT formato FROM revistas_data ORDER BY formato ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los estados de las revistas
app.get('/estado_revistas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT estado FROM revistas_data ORDER BY estado ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los ISSN digitales de las revistas
app.get('/issnd', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT issn_digital FROM revistas_data ORDER BY issn_digital ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los ISSN impresos de las revistas
app.get('/issni', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT issn_impreso FROM revistas_data ORDER BY issn_impreso ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los depósitos legales digitales de las revistas
app.get('/deplegd', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT deposito_legal_digital FROM revistas_data ORDER BY deposito_legal_digital ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los depósitos legales impresos de las revistas
app.get('/deplegi', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT DISTINCT deposito_legal_impreso FROM revistas_data ORDER BY deposito_legal_impreso ASC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener las cantidades de revistas
app.get('/cantidades', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM vcantidades');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener las áreas de conocimiento con conteo
app.get('/gr_areas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT area_conocimiento, COUNT(area_conocimiento) AS cant_area FROM revistas_data GROUP BY area_conocimiento ORDER BY COUNT(area_conocimiento) DESC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
// Ruta GET para obtener los datos nacionales
app.get('/data_nacional', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM vdata_nacional');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los datos de los estados
app.get('/data_estados', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM vdata_estados ORDER BY estado');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los índices con conteo
app.get('/gr_indices', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT indice, COUNT(indice) AS cant_inddice FROM revistas_data GROUP BY indice ORDER BY COUNT(indice) DESC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los idiomas con conteo
app.get('/gr_idiomas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT idioma, COUNT(idioma) AS cant_idioma FROM revistas_data GROUP BY idioma ORDER BY COUNT(idioma) DESC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener las editoriales con conteo
app.get('/gr_editoriales', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT editorial, COUNT(editorial) AS cant_editorial FROM revistas_data GROUP BY editorial ORDER BY COUNT(editorial) DESC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener las periodicidades con conteo
app.get('/gr_periodicidades', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT periodicidad, COUNT(periodicidad) AS cant_periodicidad FROM revistas_data GROUP BY periodicidad ORDER BY COUNT(periodicidad) DESC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los formatos con conteo
app.get('/gr_formatos', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT formato, COUNT(formato) AS cant_formato FROM revistas_data GROUP BY formato ORDER BY COUNT(formato) DESC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

// Ruta GET para obtener los estados con conteo
app.get('/gr_estados', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT estado, COUNT(estado) AS cant_estado FROM revistas_data GROUP BY estado ORDER BY COUNT(estado) DESC');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
// Ruta GET para obtener todos los estados
app.get('/lista_estados', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT * FROM vestados');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
// Ruta GET para obtener todos las áreas de conocimiento
app.get('/lista_areas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT id as id_area_conocimiento,area_conocimiento FROM areas_conocimiento ORDER BY area_conocimiento');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
// Ruta GET para obtener todos indices
app.get('/lista_indices', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT id,indice FROM indices ORDER BY indice');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
// Ruta GET para obtener todos editoriales
app.get('/lista_editoriales', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT id_editorial,editorial FROM editoriales ORDER BY editorial');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
// Ruta GET para obtener todos periodicidad
app.get('/lista_periodicidad', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT id,periodicidad FROM periodicidad ORDER BY periodicidad');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
// Ruta GET para obtener todos formatos
app.get('/lista_formatos', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT id,formato FROM formatos ORDER BY formato');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
// Ruta GET para obtener todos idiomas
app.get('/lista_idiomas', async (req, res) => {
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT id,idioma FROM idiomas ORDER BY idioma');
    client.release(); // Liberar el cliente
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});
//Ruta GET para obtener las dos publicaciones más recientes
app.get('/recientes', async (req, res) => {
  const { id } = req.params;
  try {
    const client = await pool.connect();
    const result = await client.query('SELECT revista,portada,created_at::date as fecha FROM public.revistas ORDER BY created_at desc limit 2');
    client.release(); // Liberar el cliente
    if (result.rows.length === 0) {
      return res.status(404).send('Datos no encontrados');
    }
    res.json(result.rows);
  } catch (err) {
    console.error('Error al ejecutar la consulta:', err);
    res.status(500).send('Error interno del servidor');
  }
});

//Ruta GET para obtener los endpoints
app.get('/endpoints', (req, res) => {
  const routes = app._router.stack
    .filter(layer => layer.route)
    .map(layer => ({
      path: layer.route.path,
      methods: Object.keys(layer.route.methods)
    }));
  
  // Añadir rutas estáticas manualmente
  routes.push({
    path: '/portadas/*',
    methods: ['GET']
  });
  
  res.json(routes);
});
/*
// Ruta para servir imágenes con CORS habilitado para cualquier dominio
const portadasPath = path.join(__dirname, 'public', 'portadas');

// Verificar si el directorio existe
const fs = require('fs');
if (!fs.existsSync(portadasPath)) {
  console.error(`ERROR: El directorio de portadas no existe en: ${portadasPath}`);
  console.log('Creando directorio...');
  fs.mkdirSync(portadasPath, { recursive: true });
}
// Configurar middleware para servir archivos estáticos
app.use('/portadas', express.static(portadasPath, {
  setHeaders: (res) => {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Cross-Origin-Resource-Policy', 'cross-origin');
  },
  fallthrough: false // Para manejar mejor los errores 404
}));

// Middleware para manejar errores cuando no se encuentra un archivo
app.use('/portadas', (req, res, next) => {
  res.status(404).json({ 
    error: 'Archivo no encontrado',
    message: `La imagen ${req.path} no existe en el servidor`
  });
});
*/
// Manejar solicitudes OPTIONS (necesario para CORS preflight)
app.options('*', (req, res) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type');
  res.send();
});

