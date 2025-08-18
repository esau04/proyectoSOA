const jwt = require('jsonwebtoken');

const verificarToken = (req, res, next) => {
  try {
    // Verificar si existe el header Authorization
    if (!req.headers.authorization) {
      return res.status(401).json({ error: 'Token no proporcionado' });
    }

    // Extraer el token (formato: Bearer <token>)
    const token = req.headers.authorization.split(' ')[1];
    if (!token) {
      return res.status(401).json({ error: 'Formato de token inválido' });
    }

    // Verificar y decodificar el token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Adjuntar datos del usuario al request
    req.usuario = decoded;
    
    // Continuar con el siguiente middleware/ruta
    next();
    
  } catch (error) {
    // Manejo de errores específicos
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ error: 'Token inválido' });
    }
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ error: 'Token expirado' });
    }
    
    // Otros errores
    console.error('Error en verificación de token:', error);
    res.status(500).json({ error: 'Error en la autenticación' });
  }
};

module.exports = verificarToken;