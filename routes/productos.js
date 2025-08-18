const express = require('express');
const router = express.Router();
const Producto = require('../models/Producto');

// GET: Consultar productos
router.get('/', async (req, res) => {
  try {
    const productos = await Producto.findAll();
    res.json(productos);
  } catch (error) {
    console.error('Error en GET /api/productos:', error);
    res.status(500).json({ 
      error: 'Error al obtener productos',
      detalle: error.message // Opcional: incluir detalles para depuración
    });
  }
});

// POST: Registrar producto
router.post('/', async (req, res) => {
  try {
    const { nombre, descripcion, precio_compra, precio_venta, stock } = req.body;

    // Validación manual de campos
    if (!nombre || !descripcion || precio_compra === undefined || precio_venta === undefined || stock === undefined) {
      return res.status(400).json({ error: "Todos los campos son obligatorios" });
    }

    console.log("Body recibido:", req.body); // 👈 Verifica lo que llega desde Postman

    const nuevoProducto = await Producto.create({
      nombre,
      descripcion,
      precio_compra: parseFloat(precio_compra),
      precio_venta: parseFloat(precio_venta),
      stock: parseInt(stock)
    });

    res.status(201).json(nuevoProducto);
  } catch (err) {
  console.error('Error en POST /api/productos:', err); // Esto sale en la consola de Node
  res.status(500).json({ 
    error: err.message,  // Esto sale en Postman
    detalle: err         // Esto también sale en Postman para depuración completa
  });
}
});


// PUT: Modificar producto
router.put('/:id', async (req, res) => {
  try {
    const { descripcion, precio_compra, precio_venta, stock, active } = req.body;
    const producto = await Producto.findByPk(req.params.id);
    if (!producto) return res.status(404).json({ error: 'No encontrado' });

    Object.assign(producto, { descripcion, precio_compra, precio_venta, stock, active });
    await producto.save();
    res.json(producto);
  } catch (err) {
    console.error('Error en PUT /api/productos:', err);
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
