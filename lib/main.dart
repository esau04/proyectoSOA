import 'package:flutter/material.dart';
import 'package:soa_app/screens/productos_screen.dart';
import 'package:soa_app/screens/ventas/ventas_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Gestión',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Mantenemos ProductosScreen como pantalla principal
      home: ProductosScreen(),
      // Agregamos la ruta para ventas
      routes: {
        '/ventas': (context) => VentasScreen(
              rolUsuario: 'vendedor',     // Cambiar según autenticación
              idUsuario: 1,               // ID del usuario logueado
              nombreUsuario: 'Vendedor',  // Nombre del usuario
            ),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}