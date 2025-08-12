const jwt = require('jsonwebtoken');

const verificarVendedor = (req, res, next) => {
  try {
    const token = req.headers.authorization.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.usuario = decoded;
    
    if (decoded.rol !== 'vendedor') {
      return res.status(403).json({ error: 'Acceso denegado' });
    }
    
    next();
  } catch (error) {
    res.status(401).json({ error: 'Autenticación fallida' });
  }
};

const verificarSupervisor = (req, res, next) => {
  try {
    const token = req.headers.authorization.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.usuario = decoded;
    
    if (decoded.rol !== 'supervisor') {
      return res.status(403).json({ error: 'Acceso denegado' });
    }
    
    next();
  } catch (error) {
    res.status(401).json({ error: 'Autenticación fallida' });
  }
};

module.exports = { verificarVendedor, verificarSupervisor };