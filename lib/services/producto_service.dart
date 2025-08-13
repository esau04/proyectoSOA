import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/producto.dart';

class ProductoService {
  final String baseUrl = 'http://localhost:3000/api/productos'; // Cambia por tu URL

  Future<List<Producto>> getProductos() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((product) => Producto.fromJson(product)).toList();
    } else {
      throw Exception('Error al cargar productos');
    }
  }

  Future<Producto> createProducto(Producto producto) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(producto.toJson()),
    );

    if (response.statusCode == 201) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear producto: ${response.body}');
    }
  }

  Future<Producto> updateProducto(Producto producto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${producto.idProducto}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(producto.toJson()),
    );

    if (response.statusCode == 200) {
      return Producto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar producto: ${response.body}');
    }
  }

  Future<void> inactivarProducto(int id) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$id/inactivar'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al inactivar producto');
    }
  }
}