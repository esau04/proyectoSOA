const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Producto = sequelize.define('producto', {
  id_producto: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true,
    field: 'id_producto'
  },
  nombre: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  descripcion: {
    type: DataTypes.STRING,
    allowNull: false
  },
  precio_compra: {
    type: DataTypes.FLOAT,
    allowNull: false,
    field: 'precio_compra'
  },
  precio_venta: {
    type: DataTypes.FLOAT,
    allowNull: false,
    field: 'precio_venta'
  },
  stock: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  active: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  }
}, {
  tableName: 'productos',
  timestamps: true,
  underscored: true
});

module.exports = Producto;