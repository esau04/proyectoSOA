import 'package:flutter/material.dart';
import 'package:soa_app/models/venta.dart';
import 'package:soa_app/services/venta_service.dart';

class CancelarVentaScreen extends StatefulWidget {
  final int idSupervisor;
  final String nombreSupervisor;

  const CancelarVentaScreen({
    required this.idSupervisor,
    required this.nombreSupervisor,
  });

  @override
  _CancelarVentaScreenState createState() => _CancelarVentaScreenState();
}

class _CancelarVentaScreenState extends State<CancelarVentaScreen> {
  final VentaService _ventaService = VentaService();
  final TextEditingController _idVentaController = TextEditingController();
  final TextEditingController _motivoController = TextEditingController();
  Venta? _ventaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cancelar Venta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _idVentaController,
              decoration: InputDecoration(
                labelText: 'ID de la Venta',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    if (_idVentaController.text.isEmpty) return;
                    
                    try {
                      final ventas = await _ventaService.getVentas();
                      final venta = ventas.firstWhere(
                        (v) => v.idVenta.toString() == _idVentaController.text && v.estado == 'completada'
                      );
                      setState(() {
                        _ventaSeleccionada = venta;
                      });
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Venta no encontrada o ya cancelada')),
                      );
                      setState(() {
                        _ventaSeleccionada = null;
                      });
                    }
                  },
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            if (_ventaSeleccionada != null) ...[
              SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Producto: ${_ventaSeleccionada!.nombreProducto}',
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      Text('Cantidad: ${_ventaSeleccionada!.cantidad}'),
                      Text('Total: \$${_ventaSeleccionada!.precioTotal.toStringAsFixed(2)}'),
                      Text('Fecha: ${_ventaSeleccionada!.fecha.toString().substring(0, 10)}'),
                      Text('Vendedor: ${_ventaSeleccionada!.nombreVendedor}'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _motivoController,
                decoration: InputDecoration(
                  labelText: 'Motivo de cancelación',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  if (_motivoController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Ingrese el motivo de cancelación')),
                    );
                    return;
                  }
                  
                  try {
                    await _ventaService.cancelarVenta(
                      idVenta: _ventaSeleccionada!.idVenta,
                      idSupervisor: widget.idSupervisor,
                      motivo: _motivoController.text,
                    );
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Venta cancelada exitosamente')),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al cancelar: $e')),
                    );
                  }
                },
                child: Text('Confirmar Cancelación'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _idVentaController.dispose();
    _motivoController.dispose();
    super.dispose();
  }
}