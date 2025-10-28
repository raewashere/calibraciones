import 'dart:convert';
import 'package:calibraciones/services/direccion_service.dart';
import 'package:calibraciones/services/implementation/direccion_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calibraciones/models/_direccion.dart';
// import 'models.dart'; // Asegúrate de importar tus modelos

class DataService {
  static const String _jsonKey = 'cached_organizational_json';
  DireccionService direccionService = DireccionServiceImpl();

  // Método de utilidad para convertir el String JSON en objetos Dart
  List<Direccion> _convertJsonStringToDirecciones(String jsonString) {
    final List<dynamic> decodedJson = json.decode(jsonString);
    return decodedJson.map((e) => Direccion.fromJson(e)).toList();
  }

  // Método Principal de Actualización y Caché
  Future<List<Direccion>> updateAndCacheData() async {
    try {
      // 1. Obtener el String JSON más reciente de la API
      final String newJsonString = await direccionService.obtenerDireccionesJSON();

      // 2. Almacenar el String JSON directamente en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_jsonKey, newJsonString);

      print('💾 JSON String actualizado de la API y almacenado en caché exitosamente.');

      // 3. Convertir el String JSON a objetos Direccion para devolverlos a la UI
      return _convertJsonStringToDirecciones(newJsonString);

    } catch (e) {
      print('❌ Error al actualizar los datos desde la API: $e');

      // **Estrategia de Fallback:** Intenta cargar el String JSON del caché existente.
      final prefs = await SharedPreferences.getInstance();
      final cachedJsonString = prefs.getString(_jsonKey);

      if (cachedJsonString != null) {
        print('⏳ Fallback: Devolviendo datos desde el caché antiguo.');
        // 4. Convertir el caché String JSON a objetos Direccion
        return _convertJsonStringToDirecciones(cachedJsonString);
      }

      // Si falla la API Y no hay caché, lanza la excepción.
      throw Exception('No se pudo obtener la data ni había caché disponible: $e');
    }
  }

  Future<String> obtenerDireccionesJSON() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJsonString = prefs.getString(_jsonKey);

    if (cachedJsonString != null) {
      return cachedJsonString;
    } else {
      throw Exception('No hay datos en caché disponibles.');
    }
  }
  
  // NOTA: También necesitarías ajustar getCachedOrFetchData() para usar _convertJsonStringToDirecciones
}