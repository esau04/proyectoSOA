import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String nombre;
  final String categoria;
  final String estado;
  final double precio;
  final String imagePath;
  final VoidCallback onDelete;  // Cambié onDetails por onDelete
  final VoidCallback onEdit;

  const ProductCard({
    required this.nombre,
    required this.categoria,
    required this.estado,
    required this.precio,
    required this.imagePath,
    required this.onDelete,
    required this.onEdit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFE9F1F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoText('Nombre:', nombre),
            _buildInfoText('Categoría:', categoria),
            _buildInfoText('Estado:', estado,
                isActive: estado.toLowerCase() == 'activo'),
            _buildInfoText('Precio:', '\$${precio.toStringAsFixed(2)} MXN'),
            const SizedBox(height: 10),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: onDelete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // botón rojo para eliminar
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Activar/Inactivar'),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF778CA3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Editar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoText(String label, String value, {bool isActive = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            fontFamily: 'Arial',
          ),
          children: [
            TextSpan(
              text: label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' $value',
              style: isActive && label == 'Estado:'
                  ? TextStyle(color: Colors.green[700])
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
