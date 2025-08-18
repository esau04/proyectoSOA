require('dotenv').config();
const express = require('express');
const cors = require('cors');
const sequelize = require('./config/db'); // Importa directamente desde config/db

const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(cors());
app.use(express.json());

// Importar modelos después de la conexión
const Producto = require('./models/Producto');
const Venta = require('./models/Venta');

// Establecer relaciones
Producto.hasMany(Venta, { foreignKey: 'producto_id' });
Venta.belongsTo(Producto, { foreignKey: 'producto_id' });

// Rutas
app.use('/api/productos', require('./routes/productos'));
app.use('/api/ventas', require('./routes/ventas'));

// Ruta de prueba
app.get('/', (req, res) => {
  res.json({ message: 'API funcionando', status: 'OK' });
});


// Manejo de errores
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Error interno del servidor' });
});

// Iniciar servidor
async function startServer() {
  try {

    await sequelize.sync({ force: true }); // 👈 Usa solo en desarrollo
console.log('🔄 Tablas recreadas');

    await sequelize.authenticate();
    console.log('✅ Conexión a la base de datos establecida');
    
    await sequelize.sync({ alter: true });
    console.log('🔄 Modelos sincronizados');
    
    app.listen(PORT, () => {
      console.log(`🚀 Servidor corriendo en http://localhost:${PORT}`);
    });
  } catch (error) {
    console.error('❌ Error de inicio:', error);
    process.exit(1);
  }
}

startServer();