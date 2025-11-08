class Producto {
  late int idProducto;
  late String producto;

  Producto(this.idProducto, this.producto);

  int get getIdProducto => idProducto;
  String get getProducto => producto;

  set setIdProducto(int value) {
    idProducto = value; // Asignación correcta
  }

  set setProducto(String value) {
    producto = value; // Asignación correcta
  }

  static fromJson(Map<String, dynamic> productoJson) {
    return Producto(productoJson['id_producto'], productoJson['producto']);
  }

  factory Producto.fromJsonFactory(Map<String, dynamic> json) {
    return Producto(json['id_producto'], json['producto']);
  }
}
