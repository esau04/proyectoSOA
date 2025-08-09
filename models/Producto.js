const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Producto = sequelize.define('Producto', {
  idProducto: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
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
  precioCompra: {
    type: DataTypes.FLOAT,
    allowNull: false
  },
  precioVenta: {
    type: DataTypes.FLOAT,
    allowNull: false
  },
  stock: {
    type: DataTypes.INTEGER,
    allowNull: false
  },
  active: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  }
});

module.exports = Producto;
