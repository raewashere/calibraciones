import 'package:calibraciones/models/_direccion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 

class DireccionService {
  final String url = "http://127.0.0.1:8090/api";

  Future<List<Direccion>> getAllDirecciones() async {
    try {
      final response = await http.get(Uri.parse('$url/direccion'));

      if (response.statusCode == 200) {
        final List<dynamic> decodedJson = json.decode(response.body);
        List<Direccion> direcciones = [];
        for (var direccionJson in decodedJson) {
          Direccion direccion = Direccion.fromJson(direccionJson);
          // Aquí podrías agregar lógica adicional si es necesario
          direcciones.add(direccion);
        }
        return direcciones;
      } else {
        if (response.statusCode == 404) {
          // Decodificar la respuesta JSON
          throw Exception('No hay direcciones registradas');
        }
        else{
          throw Exception('Hubo un error al recuperar la lista de direcciones 1');
        }        
      }
    } catch (e) {
      throw Exception(' Ojoooo $e');
    }
  }
}
