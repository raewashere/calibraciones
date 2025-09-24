import 'package:calibraciones/models/_laboratorio_calibracion.dart';
import 'package:calibraciones/services/laboratorio_calibracion_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LaboratorioCalibracionServiceImpl extends LaboratorioCalibracionService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<List<LaboratorioCalibracion>> obtenerAllLaboratorios() async{
    try {
      final response = await supabase.from('laboratorio_calibracion').select();

      if (response.isNotEmpty) {
        return (response as List).map((e) => LaboratorioCalibracion.fromJsonFactory(e)).toList();
      } else {
        throw Exception('No se encontraron equipos');
      }
    } catch (e) {
      throw Exception('Error en la conexión: $e');
    }
  }
}
