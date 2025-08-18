module.exports = (sequelize, DataTypes) => {
  const Venta = sequelize.define('venta', {
    id_venta: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    // ... otros campos ...
    producto_id: {
      type: DataTypes.INTEGER,
      references: {
        model: 'productos',
        key: 'id_producto'
      }
    }
  }, {
    tableName: 'ventas',
    timestamps: true,
    underscored: true
  });

  Venta.associate = function(models) {
    Venta.belongsTo(models.producto, {
      foreignKey: 'producto_id',
      as: 'producto'
    });
  };

  return Venta;
};