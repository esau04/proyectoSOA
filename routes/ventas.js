const express = require('express');
const router = express.Router();
const Venta = require('../models/Venta');
const Producto = require('../models/Producto');
const { verificarVendedor, verificarSupervisor } = require('../middleware/auth');

// HU 4.1 - Registrar nueva venta
router.post('/', verificarVendedor, async (req, res) => {
  try {
    const { ProductoId, cantidad } = req.body;
    
    // Validar producto y stock (CA1 y CA2)
    const producto = await Producto.findByPk(ProductoId);
    if (!producto) {
      return res.status(404).json({ error: 'Producto no encontrado' });
    }
    
    if (producto.stock < cantidad) {
      return res.status(400).json({ error: 'Stock insuficiente' });
    }
    
    // Crear la venta (CA4 y CA5)
    const venta = await Venta.create({
      ProductoId,
      cantidad,
      precioUnitario: producto.precioVenta,
      precioTotal: producto.precioVenta * cantidad,
      VendedorId: req.usuario.id // Asumiendo que el middleware auth agrega esto
    });
    
    res.status(201).json(venta);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// HU 4.2 - Cancelación o devolución de ventas
router.patch('/:id/cancelar', verificarSupervisor, async (req, res) => {
  try {
    const { motivo } = req.body;
    const venta = await Venta.findByPk(req.params.id);
    
    if (!venta) {
      return res.status(404).json({ error: 'Venta no encontrada' });
    }
    
    // Solo permitir cancelar ventas completadas (CA1)
    if (venta.estado !== 'completada') {
      return res.status(400).json({ error: 'La venta ya fue cancelada o devuelta' });
    }
    
    // Actualizar venta (CA2 y CA3)
    await venta.update({
      estado: 'cancelada',
      canceladoPor: req.usuario.id,
      fechaCancelacion: new Date(),
      motivoCancelacion: motivo
    });
    
    res.json(venta);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// HU 4.3 - Historial de ventas
router.get('/', verificarVendedor, async (req, res) => {
  try {
    const { fechaInicio, fechaFin, ProductoId } = req.query;
    const where = { VendedorId: req.usuario.id };
    
    // Filtros (CA2)
    if (fechaInicio && fechaFin) {
      where.fecha = {
        [Op.between]: [new Date(fechaInicio), new Date(fechaFin)]
      };
    }
    
    if (ProductoId) {
      where.ProductoId = ProductoId;
    }
    
    const ventas = await Venta.findAll({
      where,
      include: [{
        model: Producto,
        attributes: ['nombre']
      }],
      order: [['fecha', 'DESC']]
    });
    
    res.json(ventas);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;