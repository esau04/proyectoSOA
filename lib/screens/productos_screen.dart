import 'package:flutter/material.dart';
import 'package:soa_app/models/producto.dart';
import 'package:soa_app/services/producto_service.dart';
import 'package:soa_app/screens/producto_form_screen.dart';
import 'package:soa_app/widgets/product_card.dart';
import 'package:soa_app/screens/ventas/ventas_screen.dart'; // Importación añadida

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final ProductoService _productoService = ProductoService();
  late Future<List<Producto>> _futureProductos;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureProductos = _productoService.getProductos();
  }

  void _refreshProductos() {
    setState(() {
      _futureProductos = _productoService.getProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Productos'),
        actions: [
          // Botón de Ventas añadido aquí
          IconButton(
            icon: Icon(Icons.shopping_cart),
            tooltip: 'Módulo de Ventas',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VentasScreen(
                    rolUsuario: 'vendedor', // Cambiar según tu lógica de roles
                    idUsuario: 1, // ID del usuario actual
                    nombreUsuario: 'Vendedor', // Nombre del usuario
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductoFormScreen(
                    onSave: _refreshProductos,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar producto',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Producto>>(
              future: _futureProductos,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay productos registrados'));
                } else {
                  List<Producto> filteredProductos = snapshot.data!
                      .where((producto) =>
                  producto.nombre.toLowerCase().contains(_searchQuery) ||
                      producto.descripcion.toLowerCase().contains(_searchQuery))
                      .toList();

                  return ListView.builder(
                    itemCount: filteredProductos.length,
                    itemBuilder: (context, index) {
                      Producto producto = filteredProductos[index];
                      return ProductCard(
                        nombre: producto.nombre,
                        categoria: producto.descripcion ?? '',
                        estado: producto.active ? 'Activo' : 'Inactivo',
                        precio: producto.precioVenta,
                        imagePath: 'assets/images/default_image.png',
                        onDelete: () {
                          _showInactivarDialog(producto);  // llama al diálogo para eliminar/inactivar
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductoFormScreen(
                                producto: producto,
                                onSave: _refreshProductos,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showInactivarDialog(Producto producto) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Inactivar Producto'),
        content: Text(
            '¿Estás seguro de que deseas marcar como inactivo el producto ${producto.nombre}?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Inactivar', style: TextStyle(color: Colors.red)),
            onPressed: () async {
              try {
                await _productoService.inactivarProducto(producto.idProducto);
                _refreshProductos();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Producto inactivado correctamente')),
                );
                Navigator.pop(context);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al inactivar: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}