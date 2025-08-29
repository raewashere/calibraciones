// TODO Implement this library.import 'package:calibraciones/dto/dto_subdireccion_logistica.dart';

class DtoEquipo {
    String tagEquipo;
    String estado;
    String marca;
    String modelo;
    String noSerie;
    String tipoSensor;

    DtoEquipo(this.tagEquipo, this.estado, this.marca, this.modelo, this.noSerie, this.tipoSensor);

    @override
    String toString() {
        return 'DtoEquipo{tagEquipo: $tagEquipo, estado: $estado, marca: $marca, modelo: $modelo, noSerie: $noSerie, tipoSensor: $tipoSensor}';
    }

    factory DtoEquipo.fromJson(Map<String, dynamic> json) {
        return DtoEquipo(
            json['tag_equipo'],
            json['estado'],
            json['marca'],
            json['modelo'],
            json['no_serie'],
            json['tipo_sensor'],
        );
    }

    String getTagEquipo() {
        return tagEquipo;
    }

    String getEstado() {
        return estado;
    }

    String getMarca() {
        return marca;
    }

    String getModelo() {
        return modelo;
    }

    String getNoSerie() {
        return noSerie;
    }

    String getTipoSensor() {
        return tipoSensor;
    }

}