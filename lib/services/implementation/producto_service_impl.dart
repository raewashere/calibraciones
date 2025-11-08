import 'package:calibraciones/models/_producto.dart';
import 'package:calibraciones/services/producto_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductoServiceImpl extends ProductosService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<Producto>> obtenerAllProductos() async{
    try {
      final response = await supabase.from('laboratorio_calibracion').select();

      if (response.isNotEmpty) {
        return (response as List).map((e) => Producto.fromJsonFactory(e)).toList();
      } else {
        throw Exception('No se encontraron productos');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }

}
