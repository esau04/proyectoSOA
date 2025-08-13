class Producto {
  final int idProducto;
  final String nombre;
  final String descripcion;
  final double precioCompra;
  final double precioVenta;
  final int stock;
  final bool active;

  Producto({
    required this.idProducto,
    required this.nombre,
    required this.descripcion,
    required this.precioCompra,
    required this.precioVenta,
    required this.stock,
    required this.active,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['idProducto'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precioCompra: json['precioCompra'].toDouble(),
      precioVenta: json['precioVenta'].toDouble(),
      stock: json['stock'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProducto': idProducto,
      'nombre': nombre,
      'descripcion': descripcion,
      'precioCompra': precioCompra,
      'precioVenta': precioVenta,
      'stock': stock,
      'active': active,
    };
  }
}