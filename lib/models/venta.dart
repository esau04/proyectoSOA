class Venta {
  final int idVenta;
  final int idProducto;
  final String nombreProducto;
  final int cantidad;
  final double precioUnitario;
  final double precioTotal;
  final DateTime fecha;
  final int idVendedor;
  final String nombreVendedor;
  final String estado; // 'completada', 'cancelada', 'devuelta'
  final int? idSupervisorCancelacion;
  final DateTime? fechaCancelacion;
  final String? motivoCancelacion;

  Venta({
    required this.idVenta,
    required this.idProducto,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioUnitario,
    required this.precioTotal,
    required this.fecha,
    required this.idVendedor,
    required this.nombreVendedor,
    this.estado = 'completada',
    this.idSupervisorCancelacion,
    this.fechaCancelacion,
    this.motivoCancelacion,
  });

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['idVenta'],
      idProducto: json['idProducto'],
      nombreProducto: json['nombreProducto'],
      cantidad: json['cantidad'],
      precioUnitario: json['precioUnitario'].toDouble(),
      precioTotal: json['precioTotal'].toDouble(),
      fecha: DateTime.parse(json['fecha']),
      idVendedor: json['idVendedor'],
      nombreVendedor: json['nombreVendedor'],
      estado: json['estado'],
      idSupervisorCancelacion: json['idSupervisorCancelacion'],
      fechaCancelacion: json['fechaCancelacion'] != null 
          ? DateTime.parse(json['fechaCancelacion']) 
          : null,
      motivoCancelacion: json['motivoCancelacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idVenta': idVenta,
      'idProducto': idProducto,
      'nombreProducto': nombreProducto,
      'cantidad': cantidad,
      'precioUnitario': precioUnitario,
      'precioTotal': precioTotal,
      'fecha': fecha.toIso8601String(),
      'idVendedor': idVendedor,
      'nombreVendedor': nombreVendedor,
      'estado': estado,
      'idSupervisorCancelacion': idSupervisorCancelacion,
      'fechaCancelacion': fechaCancelacion?.toIso8601String(),
      'motivoCancelacion': motivoCancelacion,
    };
  }
}