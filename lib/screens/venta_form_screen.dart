import 'package:flutter/material.dart';
import 'package:soa_app/models/producto.dart';
import 'package:soa_app/services/producto_service.dart';
import 'package:soa_app/services/venta_service.dart';

class VentaFormScreen extends StatefulWidget {
  final int idVendedor;
  final String nombreVendedor;

  const VentaFormScreen({
    Key? key,
    required this.idVendedor,
    required this.nombreVendedor,
  }) : super(key: key);

  @override
  _VentaFormScreenState createState() => _VentaFormScreenState();
}

class _VentaFormScreenState extends State<VentaFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductoService _productoService = ProductoService();
  final VentaService _ventaService = VentaService();

  late Future<List<Producto>> _futureProductos;
  Producto? _productoSeleccionado;
  final TextEditingController _cantidadController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureProductos = _productoService.getProductos();
    _cantidadController.addListener(_actualizarTotal);
  }

  void _actualizarTotal() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = _productoSeleccionado != null && _cantidadController.text.isNotEmpty
        ? _productoSeleccionado!.precioVenta * (int.tryParse(_cantidadController.text) ?? 0)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Nueva Venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              FutureBuilder<List<Producto>>(
                future: _futureProductos,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No hay productos disponibles');
                  } else {
                    return DropdownButtonFormField<Producto>(
                      decoration: const InputDecoration(labelText: 'Producto'),
                      items: snapshot.data!
                          .where((p) => p.active && p.stock > 0)
                          .map((Producto producto) {
                        return DropdownMenuItem<Producto>(
                          value: producto,
                          child: Text('${producto.nombre} (Stock: ${producto.stock})'),
                        );
                      }).toList(),
                      onChanged: (Producto? producto) {
                        setState(() {
                          _productoSeleccionado = producto;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione un producto';
                        }
                        return null;
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cantidadController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la cantidad';
                  }
                  final cantidad = int.tryParse(value);
                  if (cantidad == null || cantidad <= 0) {
                    return 'Cantidad inválida';
                  }
                  if (_productoSeleccionado != null && cantidad > _productoSeleccionado!.stock) {
                    return 'Stock insuficiente';
                  }
                  return null;
                },
              ),
              if (_productoSeleccionado != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Precio Unitario: \$${_productoSeleccionado!.precioVenta.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _productoSeleccionado != null) {
                    try {
                      await _ventaService.createVenta(
                        idProducto: _productoSeleccionado!.idProducto,
                        nombreProducto: _productoSeleccionado!.nombre,
                        cantidad: int.parse(_cantidadController.text),
                        precioUnitario: _productoSeleccionado!.precioVenta,
                        idVendedor: widget.idVendedor,
                        nombreVendedor: widget.nombreVendedor,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Venta registrada exitosamente')),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.toString()}')),
                      );
                    }
                  }
                },
                child: const Text('Registrar Venta'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cantidadController.removeListener(_actualizarTotal);
    _cantidadController.dispose();
    super.dispose();
  }
}