import 'package:flutter/material.dart';
import 'package:soa_app/screens/ventas/venta_form_screen.dart';
import 'package:soa_app/screens/ventas/historial_ventas_screen.dart';
import 'package:soa_app/screens/ventas/cancelar_venta_screen.dart';

class VentasScreen extends StatelessWidget {
  final String rolUsuario;
  final int idUsuario;
  final String nombreUsuario;

  const VentasScreen({
    required this.rolUsuario,
    required this.idUsuario,
    required this.nombreUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Ventas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (rolUsuario == 'vendedor')
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VentaFormScreen(
                        idVendedor: idUsuario,
                        nombreVendedor: nombreUsuario,
                      ),
                    ),
                  );
                },
                child: Text('Registrar Nueva Venta'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HistorialVentasScreen(
                      idVendedor: rolUsuario == 'vendedor' ? idUsuario : null,
                    ),
                  ),
                );
              },
              child: Text('Ver Historial de Ventas'),
            ),
            if (rolUsuario == 'supervisor') ...[
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CancelarVentaScreen(
                        idSupervisor: idUsuario,
                        nombreSupervisor: nombreUsuario,
                      ),
                    ),
                  );
                },
                child: Text('Cancelar Venta'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}