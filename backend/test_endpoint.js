// Endpoint temporal de prueba para verificar tablas lookup
app.get('/test_lookup_tables', async (req, res) => {
    const client = await pool.connect();
    try {
        const tests = {};

        // Test areas_conocimiento
        try {
            const r1 = await client.query('SELECT COUNT(*) as count FROM areas_conocimiento');
            tests.areas_conocimiento = { exists: true, count: r1.rows[0].count };
        } catch (e) {
            tests.areas_conocimiento = { exists: false, error: e.message };
        }

        // Test idiomas
        try {
            const r2 = await client.query('SELECT COUNT(*) as count FROM idiomas');
            tests.idiomas = { exists: true, count: r2.rows[0].count };
        } catch (e) {
            tests.idiomas = { exists: false, error: e.message };
        }

        // Test indices
        try {
            const r3 = await client.query('SELECT COUNT(*) as count FROM indices');
            tests.indices = { exists: true, count: r3.rows[0].count };
        } catch (e) {
            tests.indices = { exists: false, error: e.message };
        }

        // Test editoriales
        try {
            const r4 = await client.query('SELECT COUNT(*) as count FROM editoriales');
            tests.editoriales = { exists: true, count: r4.rows[0].count };
        } catch (e) {
            tests.editoriales = { exists: false, error: e.message };
        }

        // Test periodicidad
        try {
            const r5 = await client.query('SELECT COUNT(*) as count FROM periodicidad');
            tests.periodicidad = { exists: true, count: r5.rows[0].count };
        } catch (e) {
            tests.periodicidad = { exists: false, error: e.message };
        }

        // Test formatos
        try {
            const r6 = await client.query('SELECT COUNT(*) as count FROM formatos');
            tests.formatos = { exists: true, count: r6.rows[0].count };
        } catch (e) {
            tests.formatos = { exists: false, error: e.message };
        }

        res.json(tests);
    } catch (err) {
        res.status(500).json({ error: err.message });
    } finally {
        client.release();
    }
});
