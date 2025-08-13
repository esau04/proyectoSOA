import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/venta.dart';
import '../models/producto.dart';

class VentaService {
  final String baseUrl = 'http://localhost:3000/api/ventas'; // Cambia por tu URL

  Future<List<Venta>> getVentas({
    int? idVendedor,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    int? idProducto,
  }) async {
    Uri uri = Uri.parse(baseUrl);
    
    if (idVendedor != null || fechaInicio != null || fechaFin != null || idProducto != null) {
      uri = uri.replace(queryParameters: {
        if (idVendedor != null) 'idVendedor': idVendedor.toString(),
        if (fechaInicio != null) 'fechaInicio': fechaInicio.toIso8601String(),
        if (fechaFin != null) 'fechaFin': fechaFin.toIso8601String(),
        if (idProducto != null) 'idProducto': idProducto.toString(),
      });
    }

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((venta) => Venta.fromJson(venta)).toList();
    } else {
      throw Exception('Error al cargar ventas');
    }
  }

  Future<Venta> createVenta({
    required int idProducto,
    required String nombreProducto,
    required int cantidad,
    required double precioUnitario,
    required int idVendedor,
    required String nombreVendedor,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idProducto': idProducto,
        'nombreProducto': nombreProducto,
        'cantidad': cantidad,
        'precioUnitario': precioUnitario,
        'precioTotal': precioUnitario * cantidad,
        'idVendedor': idVendedor,
        'nombreVendedor': nombreVendedor,
      }),
    );

    if (response.statusCode == 201) {
      return Venta.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear venta: ${response.body}');
    }
  }

  Future<Venta> cancelarVenta({
    required int idVenta,
    required int idSupervisor,
    required String motivo,
  }) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$idVenta/cancelar'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'idSupervisor': idSupervisor,
        'motivo': motivo,
      }),
    );

    if (response.statusCode == 200) {
      return Venta.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cancelar venta: ${response.body}');
    }
  }
}