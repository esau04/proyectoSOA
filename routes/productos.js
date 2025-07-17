const express = require('express');
const router = express.Router();
const Producto = require('../models/Producto');

// GET: Consultar productos
router.get('/', async (req, res) => {
  const productos = await Producto.findAll();
  res.json(productos);
});

// POST: Registrar producto
router.post('/', async (req, res) => {
  try {
    const { nombre, descripcion, precioCompra, precioVenta, stock } = req.body;
    const nuevoProducto = await Producto.create({
      nombre,
      descripcion,
      precioCompra,
      precioVenta,
      stock
    });
    res.status(201).json(nuevoProducto);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// PUT: Modificar producto
router.put('/:id', async (req, res) => {
  try {
    const { descripcion, precioCompra, precioVenta, stock, active } = req.body;
    const producto = await Producto.findByPk(req.params.id);
    if (!producto) return res.status(404).json({ error: 'No encontrado' });

    Object.assign(producto, { descripcion, precioCompra, precioVenta, stock, active });
    await producto.save();
    res.json(producto);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
});

// PATCH: Inactivar producto
router.patch('/:id/inactivar', async (req, res) => {
  const producto = await Producto.findByPk(req.params.id);
  if (!producto) return res.status(404).json({ error: 'Producto no encontrado' });

  producto.active = false;
  await producto.save();
  res.json({ message: 'Producto inactivado', producto });
});

module.exports = router;
