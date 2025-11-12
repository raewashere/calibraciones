import 'package:calibraciones/models/_producto.dart';

abstract class ProductosService {

  Future<List<Producto>> obtenerAllProductos();

  Future<Producto> obtenerProductoPorId(int idProducto);

}