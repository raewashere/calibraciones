import 'package:calibraciones/models/_direccion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Para trabajar con JSON
import 'dart:io';

class DireccionService {
  final String url = "";

  Future<List<Direccion>> getAllDirecciones() async {
    try {
      final response = await http.get(Uri.parse('$url/api/direccion'));

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final Map<String, dynamic> decodedJson = json.decode(response.body);
        return decodedJson['nombre']; // Accede al arreglo dentro del mapa
      } else {
        if (response.statusCode == 404) {
          // Decodificar la respuesta JSON
          throw Exception('No hay direcciones registradas');
        }
        else{
          throw Exception('Hubo un error al recuperar la lista de direcciones');
        }        
      }
    } catch (e) {
      throw Exception('Hubo un error al recuperar la lista de direcciones');
    }
  }
}
