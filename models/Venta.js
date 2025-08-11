const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');
const Producto = require('./Producto');

const Venta = sequelize.define('Venta', {
  idVenta: {
    type: DataTypes.INTEGER,
    autoIncrement: true,
    primaryKey: true
  },
  cantidad: {
    type: DataTypes.INTEGER,
    allowNull: false,
    validate: {
      min: 1
    }
  },
  precioUnitario: {
    type: DataTypes.FLOAT,
    allowNull: false,
    validate: {
      min: 0
    }
  },
  precioTotal: {
    type: DataTypes.FLOAT,
    allowNull: false,
    validate: {
      min: 0
    }
  },
  fecha: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  estado: {
    type: DataTypes.ENUM('completada', 'cancelada', 'devuelta'),
    defaultValue: 'completada'
  },
  canceladoPor: {
    type: DataTypes.INTEGER // ID del supervisor
  },
  fechaCancelacion: {
    type: DataTypes.DATE
  },
  motivoCancelacion: {
    type: DataTypes.STRING
  }
});

// Relación con Producto
Venta.belongsTo(Producto, { foreignKey: 'ProductoId' });
Producto.hasMany(Venta, { foreignKey: 'ProductoId' });

// Hooks para actualizar stock
Venta.addHook('afterCreate', async (venta, options) => {
  const producto = await Producto.findByPk(venta.ProductoId);
  producto.stock -= venta.cantidad;
  await producto.save();
});

Venta.addHook('afterUpdate', async (venta, options) => {
  if (venta.changed('estado') && (venta.estado === 'cancelada' || venta.estado === 'devuelta')) {
    const producto = await Producto.findByPk(venta.ProductoId);
    producto.stock += venta.cantidad;
    await producto.save();
  }
});

module.exports = Venta;