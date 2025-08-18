const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Venta = sequelize.define('venta', {
  id_venta: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
    field: 'id_venta'
  },
  cantidad: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  precio_unitario: {
    type: DataTypes.FLOAT,
    allowNull: false,
    field: 'precio_unitario'
  },
  precio_total: {
    type: DataTypes.FLOAT,
    allowNull: false,
    field: 'precio_total'
  },
  fecha: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  estado: {
    type: DataTypes.ENUM('completada', 'cancelada', 'devuelta'),
    defaultValue: 'completada'
  },
  cancelado_por: {
    type: DataTypes.INTEGER
  },
  fecha_cancelacion: {
    type: DataTypes.DATE
  },
  motivo_cancelacion: {
    type: DataTypes.STRING
  },
  producto_id: {
    type: DataTypes.INTEGER,
    references: {
      model: 'productos', // Nombre de la tabla (no del modelo)
      key: 'id_producto'
    }
  }
}, {
  tableName: 'ventas',
  timestamps: true,
  underscored: true
});

// No establecer relaciones aquí - se hará en app.js
module.exports = Venta;