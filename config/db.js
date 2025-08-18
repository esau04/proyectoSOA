// config/db.js
const { Sequelize } = require('sequelize');
require('dotenv').config();

const sequelize = new Sequelize(
  process.env.DB_NAME,
  process.env.DB_USER,
  process.env.DB_PASSWORD,
  {
    host: process.env.DB_HOST,
    dialect: 'mysql',
    logging: console.log // ✅ Muestra las consultas SQL en consola
  }
);

// Prueba la conexión inmediatamente
sequelize.authenticate()
  .then(() => console.log('Conexión a DB verificada en config'))
  .catch(err => console.error('Error en conexión DB:', err));

module.exports = sequelize; // Exporta directamente la instancia