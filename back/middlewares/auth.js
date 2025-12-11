const jwt = require('jsonwebtoken');
const { Pool } = require('pg');

// Pool para consultas a la base de datos de autenticación
const pool = new Pool({
    user: 'postgres',
    host: 'localhost',
    database: '_api_revistas',
    password: 'postgres',
    port: 5432,
});

// Middleware para autenticación
const authenticate = async (req, res, next) => {
    const token = req.header('Authorization')?.split(' ')[1];

    if (!token) {
        return res.status(401).json({ error: 'Acceso denegado. Token no proporcionado.' });
    }

    const client = await pool.connect();
    try {
        // Verificar si el token está en la lista negra
        const blacklistResult = await client.query(
            'SELECT * FROM blacklisted_tokens WHERE token = $1 AND expires_at > NOW()',
            [token]
        );

        if (blacklistResult.rows.length) {
            return res.status(401).json({ error: 'Sesión expirada. Por favor, inicia sesión nuevamente.' });
        }

        // Verificar el token JWT
        let decoded;
        try {
            decoded = jwt.verify(token, process.env.JWT_SECRET || 'tu_secreto_jwt');
        } catch (jwtError) {
            if (jwtError.name === 'TokenExpiredError') {
                return res.status(401).json({ error: 'La sesión ha expirado. Por favor, inicia sesión nuevamente.' });
            }
            return res.status(400).json({ error: 'Token inválido.' });
        }

        req.userId = decoded.userId;

        // Verificar si la sesión está activa y no revocada
        const sessionResult = await client.query(
            'SELECT expires_at FROM sessions WHERE token = $1 AND is_revoked = FALSE',
            [token]
        );

        if (!sessionResult.rows.length) {
            return res.status(401).json({ error: 'Sesión no encontrada o revocada.' });
        }

        const expiresAt = new Date(sessionResult.rows[0].expires_at);
        const currentTime = new Date();
        const sessionPreviousTime = parseInt(process.env.SESSION_PREVIOUS_TIME || '10', 10);
        const expiresAtMinus = new Date(expiresAt.getTime() - (sessionPreviousTime * 1000));

        if (currentTime > expiresAtMinus) {
            // Marcar la sesión como revocada
            await client.query(
                'UPDATE sessions SET is_revoked = TRUE WHERE token = $1',
                [token]
            );

            return res.status(401).json({ error: 'La sesión ha expirado. Se ha realizado un logout automático.' });
        }

        next();
    } catch (err) {
        console.error('Error en authenticate middleware:', err);
        res.status(500).json({ error: 'Error al verificar la autenticación.' });
    } finally {
        client.release();
    }
};

module.exports = { authenticate };
