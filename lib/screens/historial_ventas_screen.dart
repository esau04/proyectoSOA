import 'package:flutter/material.dart';
import 'package:soa_app/models/venta.dart';
import 'package:soa_app/services/venta_service.dart';
import 'package:soa_app/widgets/venta_card.dart';

class HistorialVentasScreen extends StatefulWidget {
  final int? idVendedor;

  const HistorialVentasScreen({this.idVendedor});

  @override
  _HistorialVentasScreenState createState() => _HistorialVentasScreenState();
}

class _HistorialVentasScreenState extends State<HistorialVentasScreen> {
  final VentaService _ventaService = VentaService();
  late Future<List<Venta>> _futureVentas;
  DateTimeRange? _rangoFechas;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _futureVentas = _loadVentas();
  }

  Future<List<Venta>> _loadVentas() async {
    return await _ventaService.getVentas(
      idVendedor: widget.idVendedor,
      fechaInicio: _rangoFechas?.start,
      fechaFin: _rangoFechas?.end,
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _rangoFechas,
    );
    if (picked != null) {
      setState(() {
        _rangoFechas = picked;
        _futureVentas = _loadVentas();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historial de Ventas'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDateRange(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar ventas',
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
            child: FutureBuilder<List<Venta>>(
              future: _futureVentas,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay ventas registradas'));
                } else {
                  List<Venta> ventasFiltradas = snapshot.data!
                      .where((venta) =>
                          venta.nombreProducto.toLowerCase().contains(_searchQuery) ||
                          venta.nombreVendedor.toLowerCase().contains(_searchQuery))
                      .toList();

                  return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _futureVentas = _loadVentas();
                      });
                    },
                    child: ListView.builder(
                      itemCount: ventasFiltradas.length,
                      itemBuilder: (context, index) {
                        final venta = ventasFiltradas[index];
                        return VentaCard(
                          venta: venta,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}