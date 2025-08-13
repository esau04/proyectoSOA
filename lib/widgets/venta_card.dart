import 'package:flutter/material.dart';
import 'package:soa_app/models/venta.dart';

class VentaCard extends StatelessWidget {
  final Venta venta;

  const VentaCard({required this.venta});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  venta.nombreProducto,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Chip(
                  label: Text(
                    '\$${venta.precioTotal.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Cantidad: ${venta.cantidad}'),
            Text('Precio unitario: \$${venta.precioUnitario.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vendedor: ${venta.nombreVendedor}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  venta.fecha.toString().substring(0, 10),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            if (venta.estado != 'completada') ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.warning, color: Colors.orange),
                  SizedBox(width: 4),
                  Text(
                    '${venta.estado.toUpperCase()}',
                    style: TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}