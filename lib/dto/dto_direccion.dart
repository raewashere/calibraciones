import 'package:calibraciones/dto/dto_subdireccion_logistica.dart';

class DtoDireccion {
    late int idDireccion;
    late String nombreDireccion;
    late List<DtoSubdireccionLogistica> subdireccionesLogisticas;

    DtoDireccion(this.idDireccion, this.nombreDireccion, this.subdireccionesLogisticas);

    @override
    String toString() {
        return 'DtoDireccion{id: $idDireccion, nombre: $nombreDireccion, subdireccionesLogisticas: $subdireccionesLogisticas}';
    }

    factory DtoDireccion.fromJson(Map<String, dynamic> json, List<DtoSubdireccionLogistica> subdireccionesLogisticas) {
        return DtoDireccion(
            json['id_direccion'],
            json['nombre_direccion'],
            subdireccionesLogisticas
        );
    }

    int getIdDireccion() {
        return idDireccion;
    }

    String getNombreDireccion() {
        return nombreDireccion;
    }

    List<DtoSubdireccionLogistica> getSubdireccionesLogisticas() {
        return subdireccionesLogisticas;
    }
}