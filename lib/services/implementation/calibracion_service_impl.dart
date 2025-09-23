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
    final response = await supabase
        .from('calibracion_equipo')
        .insert(calibracionEquipo.toJson());

    /*if (response.error != null) {
      print('Ojoooooo: ${response.error!.message}');
      return false;
    }*/

    List<Corrida> corridas = calibracionEquipo.getCorridas();
    for (var corrida in corridas) {
      final responseCorridas = await supabase
          .from('corrida')
          .insert(corrida.toJson());

      /*if (responseCorridas.error != null) {
        print('Ojoooooo: ${responseCorridas.error!.message}');
        return false;
      }*/
    }

    return true;
  }
}
