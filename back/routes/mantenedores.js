const express = require('express');
const router = express.Router();

// Configuración de tablas permitidas y sus campos
const TABLAS_CONFIG = {
    areas_conocimiento: {
        tabla: 'areas_conocimiento',
        campos: ['area_conocimiento'],
        campoNombre: 'area_conocimiento',
        softDelete: true
    },
    editoriales: {
        tabla: 'editoriales',
        campos: ['editorial', 'url'],
        campoNombre: 'editorial',
        softDelete: true
    },
    estados: {
        tabla: 'estados',
        campos: ['estado', 'iso_3166_2'],
        campoNombre: 'estado',
        softDelete: false
    },
    formatos: {
        tabla: 'formatos',
        campos: ['formato'],
        campoNombre: 'formato',
        softDelete: true
    },
    idiomas: {
        tabla: 'idiomas',
        campos: ['idioma', 'iso'],
        campoNombre: 'idioma',
        softDelete: true
    },
    indices: {
        tabla: 'indices',
        campos: ['indice'],
        campoNombre: 'indice',
        softDelete: true
    },
    periodicidad: {
        tabla: 'periodicidad',
        campos: ['periodicidad'],
        campoNombre: 'periodicidad',
        softDelete: true
    }
};

// Middleware para validar tabla
const validarTabla = (req, res, next) => {
    const { tabla } = req.params;
    if (!TABLAS_CONFIG[tabla]) {
        return res.status(400).json({ error: 'Tabla no válida', tablas_permitidas: Object.keys(TABLAS_CONFIG) });
    }
    req.tablaConfig = TABLAS_CONFIG[tabla];
    next();
};

// GET - Listar todos los registros de una tabla
router.get('/:tabla', validarTabla, async (req, res) => {
    const { tabla } = req.params;
    const config = req.tablaConfig;

    try {
        const pool = req.app.get('pool');
        let query = `SELECT id, ${config.campos.join(', ')}`;

        // Agregar campos de auditoría si existen
        if (config.softDelete) {
            query += ', created_at, updated_at, deleted_at';
        }

        query += ` FROM ${config.tabla}`;

        // Filtrar registros eliminados si tiene soft delete
        if (config.softDelete) {
            query += ' WHERE deleted_at IS NULL';
        }

        query += ` ORDER BY ${config.campoNombre}`;

        const result = await pool.query(query);
        res.json(result.rows);
    } catch (error) {
        console.error(`Error al obtener ${tabla}:`, error);
        res.status(500).json({ error: 'Error al obtener registros', details: error.message });
    }
});

// GET - Obtener un registro por ID
router.get('/:tabla/:id', validarTabla, async (req, res) => {
    const { tabla, id } = req.params;
    const config = req.tablaConfig;

    try {
        const pool = req.app.get('pool');
        let query = `SELECT id, ${config.campos.join(', ')}`;

        if (config.softDelete) {
            query += ', created_at, updated_at, deleted_at';
        }

        query += ` FROM ${config.tabla} WHERE id = $1`;

        if (config.softDelete) {
            query += ' AND deleted_at IS NULL';
        }

        const result = await pool.query(query, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Registro no encontrado' });
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error(`Error al obtener ${tabla}/${id}:`, error);
        res.status(500).json({ error: 'Error al obtener registro', details: error.message });
    }
});

// POST - Crear nuevo registro
router.post('/:tabla', validarTabla, async (req, res) => {
    const { tabla } = req.params;
    const config = req.tablaConfig;

    try {
        const pool = req.app.get('pool');
        const valores = [];
        const campos = [];
        const placeholders = [];

        config.campos.forEach((campo, index) => {
            if (req.body[campo] !== undefined) {
                campos.push(campo);
                valores.push(req.body[campo]);
                placeholders.push(`$${index + 1}`);
            }
        });

        if (campos.length === 0) {
            return res.status(400).json({ error: 'No se proporcionaron campos válidos', campos_requeridos: config.campos });
        }

        const query = `INSERT INTO ${config.tabla} (${campos.join(', ')}) VALUES (${placeholders.join(', ')}) RETURNING id, ${config.campos.join(', ')}`;

        const result = await pool.query(query, valores);
        res.status(201).json(result.rows[0]);
    } catch (error) {
        console.error(`Error al crear en ${tabla}:`, error);

        // Manejar error de duplicado
        if (error.code === '23505') {
            return res.status(409).json({ error: 'Ya existe un registro con ese valor', details: error.detail });
        }

        res.status(500).json({ error: 'Error al crear registro', details: error.message });
    }
});

// PUT - Actualizar registro
router.put('/:tabla/:id', validarTabla, async (req, res) => {
    const { tabla, id } = req.params;
    const config = req.tablaConfig;

    try {
        const pool = req.app.get('pool');
        const updates = [];
        const valores = [];
        let paramIndex = 1;

        config.campos.forEach((campo) => {
            if (req.body[campo] !== undefined) {
                updates.push(`${campo} = $${paramIndex}`);
                valores.push(req.body[campo]);
                paramIndex++;
            }
        });

        if (updates.length === 0) {
            return res.status(400).json({ error: 'No se proporcionaron campos para actualizar', campos_permitidos: config.campos });
        }

        // Agregar updated_at si la tabla lo tiene
        if (config.softDelete) {
            updates.push(`updated_at = NOW()`);
        }

        valores.push(id);

        let query = `UPDATE ${config.tabla} SET ${updates.join(', ')} WHERE id = $${paramIndex}`;

        if (config.softDelete) {
            query += ' AND deleted_at IS NULL';
        }

        query += ` RETURNING id, ${config.campos.join(', ')}`;

        const result = await pool.query(query, valores);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Registro no encontrado' });
        }

        res.json(result.rows[0]);
    } catch (error) {
        console.error(`Error al actualizar ${tabla}/${id}:`, error);

        if (error.code === '23505') {
            return res.status(409).json({ error: 'Ya existe un registro con ese valor', details: error.detail });
        }

        res.status(500).json({ error: 'Error al actualizar registro', details: error.message });
    }
});

// DELETE - Eliminar registro (soft delete si está configurado)
router.delete('/:tabla/:id', validarTabla, async (req, res) => {
    const { tabla, id } = req.params;
    const config = req.tablaConfig;

    try {
        const pool = req.app.get('pool');
        let query;

        if (config.softDelete) {
            // Soft delete
            query = `UPDATE ${config.tabla} SET deleted_at = NOW() WHERE id = $1 AND deleted_at IS NULL RETURNING id`;
        } else {
            // Hard delete
            query = `DELETE FROM ${config.tabla} WHERE id = $1 RETURNING id`;
        }

        const result = await pool.query(query, [id]);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'Registro no encontrado' });
        }

        res.json({ message: 'Registro eliminado correctamente', id: result.rows[0].id });
    } catch (error) {
        console.error(`Error al eliminar ${tabla}/${id}:`, error);

        // Manejar error de clave foránea
        if (error.code === '23503') {
            return res.status(409).json({
                error: 'No se puede eliminar el registro porque está siendo utilizado en otras tablas',
                details: error.detail
            });
        }

        res.status(500).json({ error: 'Error al eliminar registro', details: error.message });
    }
});

// GET - Obtener configuración de una tabla (para el frontend)
router.get('/config/:tabla', validarTabla, async (req, res) => {
    const { tabla } = req.params;
    const config = req.tablaConfig;

    res.json({
        tabla: config.tabla,
        campos: config.campos,
        campoNombre: config.campoNombre,
        softDelete: config.softDelete
    });
});

module.exports = router;
