import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/producto.dart';

class ProductoService {
  final String baseUrl = 'http://localhost:3000/api/productos';
  final http.Client client;

  ProductoService({http.Client? client}) : this.client = client ?? http.Client();

  Future<List<Producto>> getProductos() async {
    try {
      final response = await client.get(
        Uri.parse(baseUrl),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<Producto> createProducto(Producto producto) async {
    try {
      final response = await client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_convertToBackendFormat(producto)),
      );

      if (response.statusCode == 201) {
        return Producto.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Error al crear producto: $e');
    }
  }

  Future<Producto> updateProducto(Producto producto) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/${producto.idProducto}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_convertToBackendFormat(producto)),
      );

      if (response.statusCode == 200) {
        return Producto.fromJson(json.decode(response.body));
      } else {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Error al actualizar producto: $e');
    }
  }

  Future<void> inactivarProducto(int id) async {
    try {
      final response = await client.patch(
        Uri.parse('$baseUrl/$id/inactivar'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw _handleError(response);
      }
    } catch (e) {
      throw Exception('Error al inactivar producto: $e');
    }
  }

  // Conversión de camelCase a snake_case para el backend
  Map<String, dynamic> _convertToBackendFormat(Producto producto) {
    return {
      'nombre': producto.nombre,
      'descripcion': producto.descripcion,
      'precio_compra': producto.precioCompra,
      'precio_venta': producto.precioVenta,
      'stock': producto.stock,
      'active': producto.active,
    };
  }

  Exception _handleError(http.Response response) {
    try {
      final error = json.decode(response.body);
      return Exception(error['message'] ?? 'Error desconocido');
    } catch (e) {
      return Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
    }
  }
}