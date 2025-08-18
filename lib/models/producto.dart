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
      idProducto: json['id_producto'] ?? json['idProducto'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precioCompra: (json['precio_compra'] ?? json['precioCompra']).toDouble(),
      precioVenta: (json['precio_venta'] ?? json['precioVenta']).toDouble(),
      stock: json['stock'],
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_producto': idProducto,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio_compra': precioCompra,
      'precio_venta': precioVenta,
      'stock': stock,
      'active': active,
    };
  }
}