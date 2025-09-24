import 'package:calibraciones/models/_calibracion_equipo.dart';
import 'package:calibraciones/models/_corrida.dart';
import 'package:calibraciones/services/calibracion_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CalibracionServiceImpl implements CalibracionService {
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  Future<bool> registrarCalibracionEquipo(
    CalibracionEquipo calibracionEquipo,
  ) async {
    //Obtener email usuario
    String? emailUsuario = supabase.auth.currentSession!.user.email;

    //Obtener id usuario
    final responseUsuario = await supabase
        .from('usuario')
        .select()
        .eq('correo_electronico', emailUsuario!)
        .single();

    int idUsuario = responseUsuario['id_usuario'];
    calibracionEquipo.setIdUsuario = idUsuario;

    final response = await supabase
        .from('calibracion_equipo')
        .insert(calibracionEquipo.toJson()).select();
    
    //Busca id de calibracion
    int idCalibracionEquipo= response[0]['id_calibracion'];
    

    List<Corrida> corridas = calibracionEquipo.getCorridas();
    for (var corrida in corridas) {
      corrida.setIdCalibracion = idCalibracionEquipo;
      final responseCorridas = await supabase
          .from('corrida')
          .insert(corrida.toJson());

    }

    return true;
  }
}
