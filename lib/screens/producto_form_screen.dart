import 'package:flutter/material.dart';
import 'package:soa_app/models/producto.dart';
import 'package:soa_app/services/producto_service.dart';

class ProductoFormScreen extends StatefulWidget {
  final Producto? producto;
  final Function() onSave;

  ProductoFormScreen({this.producto, required this.onSave});

  @override
  _ProductoFormScreenState createState() => _ProductoFormScreenState();
}

class _ProductoFormScreenState extends State<ProductoFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductoService _productoService = ProductoService();

  late TextEditingController _nombreController;
  late TextEditingController _descripcionController;
  late TextEditingController _precioCompraController;
  late TextEditingController _precioVentaController;
  late TextEditingController _stockController;
  late bool _active;

  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController(text: widget.producto?.nombre ?? '');
    _descripcionController = TextEditingController(text: widget.producto?.descripcion ?? '');
    _precioCompraController = TextEditingController(
        text: widget.producto?.precioCompra.toString() ?? '');
    _precioVentaController = TextEditingController(
        text: widget.producto?.precioVenta.toString() ?? '');
    _stockController = TextEditingController(
        text: widget.producto?.stock.toString() ?? '');
    _active = widget.producto?.active ?? true;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _precioCompraController.dispose();
    _precioVentaController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.producto == null ? 'Nuevo Producto' : 'Editar Producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _precioCompraController,
                decoration: InputDecoration(labelText: 'Precio de Compra'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _precioVentaController,
                decoration: InputDecoration(labelText: 'Precio de Venta'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _stockController,
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el stock';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              if (widget.producto != null) ...[
                SizedBox(height: 16),
                SwitchListTile(
                  title: Text('Activo'),
                  value: _active,
                  onChanged: (value) {
                    setState(() {
                      _active = value;
                    });
                  },
                ),
              ],
              SizedBox(height: 24),
              ElevatedButton(
                child: Text('Guardar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    try {
                      Producto producto = Producto(
                        idProducto: widget.producto?.idProducto ?? 0,
                        nombre: _nombreController.text,
                        descripcion: _descripcionController.text,
                        precioCompra: double.parse(_precioCompraController.text),
                        precioVenta: double.parse(_precioVentaController.text),
                        stock: int.parse(_stockController.text),
                        active: _active,
                      );

                      if (widget.producto == null) {
                        await _productoService.createProducto(producto);
                      } else {
                        await _productoService.updateProducto(producto);
                      }

                      widget.onSave();
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}