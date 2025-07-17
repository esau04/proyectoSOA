const express = require('express');
const cors = require('cors');
const sequelize = require('./config/db');
const productosRoutes = require('./routes/productos');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/api/productos', productosRoutes);

sequelize.sync().then(() => {
  console.log('DB conectada y modelos sincronizados');
  app.listen(3000, () => console.log('Servidor en http://localhost:3000'));
}).catch(err => {
  console.error('Error de conexión:', err);
});
