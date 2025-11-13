class Producto {
  late int idProducto;
  late String producto;

  Producto(this.idProducto, this.producto);

  int get getIdProducto => idProducto;
  String get getProducto => producto;

  set setIdProducto(int value) {
    idProducto = value;
  }

  set setProducto(String value) {
    producto = value;
  }

  // --- Implementación para la Unicidad ---

  @override
  bool operator ==(Object other) {
    // Si son la misma instancia, son iguales.
    if (identical(this, other)) return true;

    // Si 'other' es un Producto y su 'idProducto' es el mismo, son iguales.
    return other is Producto && other.idProducto == idProducto;
  }

  @override
  int get hashCode => idProducto.hashCode; 

  // --- Métodos de Fábrica y Estáticos (sin cambios) ---
  
  static fromJson(Map<String, dynamic> productoJson) {
    return Producto(
      productoJson['id_producto'] as int,
      productoJson['producto'] as String,
    );
  }

  factory Producto.fromJsonFactory(Map<String, dynamic> json) {
    return Producto(json['id_producto'] as int, json['producto'] as String);
  }
}