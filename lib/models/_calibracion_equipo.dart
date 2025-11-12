import 'package:calibraciones/models/_corrida.dart';
import 'package:calibraciones/models/_producto.dart';
import 'package:calibraciones/services/corridas_service.dart';
import 'package:calibraciones/services/producto_service.dart';
import 'package:calibraciones/services/implementation/corrida_service_impl.dart';
import 'package:calibraciones/services/implementation/producto_service_impl.dart';

class CalibracionEquipo {
  late int idCalibracionEquipo;
  late String certificadoCalibracion;
  late DateTime fechaCalibracion;
  late DateTime fechaProximaCalibracion;
  late double linealidad;
  late double reproducibilidad;
  late String observaciones;
  late String rutaCertificado;
  late List<Corrida> corridas;
  //Referencias a otros objetos
  late String tagEquipo;
  late int idLaboratorioCalibracion;
  late int idUsuario;
  late Producto producto;

  CalibracionEquipo(
    this.idCalibracionEquipo,
    this.certificadoCalibracion,
    this.fechaCalibracion,
    this.fechaProximaCalibracion,
    this.linealidad,
    this.reproducibilidad,
    this.observaciones,
    this.rutaCertificado,
    this.corridas,
    this.tagEquipo,
    this.idLaboratorioCalibracion,
    this.idUsuario,
    this.producto,
  );

  //Otro constructor sin corridas
  CalibracionEquipo.sinCorridas(
    this.idCalibracionEquipo,
    this.certificadoCalibracion,
    this.fechaCalibracion,
    this.fechaProximaCalibracion,
    this.linealidad,
    this.reproducibilidad,
    this.observaciones,
    this.rutaCertificado,
    this.tagEquipo,
    this.idLaboratorioCalibracion,
    this.idUsuario,
  );

  int get getIdCalibracionEquipo => idCalibracionEquipo;
  String get getCertificadoCalibracion => certificadoCalibracion;
  DateTime get getFechaCalibracion => fechaCalibracion;
  DateTime get getFechaProximaCalibracion => fechaProximaCalibracion;
  double get getLinealidad => linealidad;
  double get getReproducibilidad => reproducibilidad;
  String get getObservaciones => observaciones;
  //String get getDocumentoCertificado => documentoCertificado;
  List<Corrida> getCorridas() => corridas;
  String getTagEquipo() => tagEquipo;
  Producto getProducto() => producto;

  set setIdCalibracionEquipo(int value) {
    idCalibracionEquipo = value;
  }

  set setCertificadoCalibracion(String value) {
    certificadoCalibracion = value;
  }

  set setFechaCalibracion(DateTime value) {
    fechaCalibracion = value;
  }

  set setFechaProximaCalibracion(DateTime value) {
    fechaProximaCalibracion = value;
  }

  set setLinealidad(double value) {
    linealidad = value;
  }

  set setReproducibilidad(double value) {
    reproducibilidad = value;
  }

  set setObservaciones(String value) {
    observaciones = value;
  }

  set setRutaCertificado(String value) {
    rutaCertificado = value;
  }

  set setCorridas(List<Corrida> value) {
    corridas = value;
  }

  set setTagEquipo(String value) {
    tagEquipo = value;
  }

  set setIdLaboratorioCalibracion(int value) {
    idLaboratorioCalibracion = value;
  }

  set setIdUsuario(int value) {
    idUsuario = value;
  }

  set setProducto(Producto value) {
    producto = value;
  }

  factory CalibracionEquipo.fromJson(Map<String, dynamic> calibracionJson) {
    return CalibracionEquipo.sinCorridas(
      calibracionJson['id_calibracion'] as int,
      calibracionJson['certificado_calibracion'] as String,
      DateTime.parse(calibracionJson['fecha_calibracion']),
      DateTime.parse(calibracionJson['fecha_proxima_calibracion']),
      (calibracionJson['linealidad'] as num).toDouble(),
      (calibracionJson['reproducibilidad'] as num).toDouble(),
      calibracionJson['observaciones'] as String,
      calibracionJson['ruta_certificado'] as String,
      calibracionJson['tag_equipo'] as String,
      calibracionJson['id_laboratorio_calibracion'] as int,
      calibracionJson['id_usuario'] as int,
    );
  }

  static Future<CalibracionEquipo> fromJsonAsync(
    Map<String, dynamic> calibracionJson,
  ) async {
    List<Corrida> corridas = [];
    Producto producto = Producto(0, "");
    CorridasService corridaService = CorridasServiceImpl();
    ProductosService productoService = ProductoServiceImpl();

    try {
      // 1. AWAIT: Esperamos a que la consulta termine y obtenga las corridas.
      corridas = await corridaService.obtenerCorridaPorCalibracion(
        calibracionJson['id_calibracion'],
      );

      producto = await productoService.obtenerProductoPorId(
        calibracionJson['producto'] as int,
      );
    } catch (error) {
      // Manejo de errores (por ejemplo, registrar el error y devolver una lista vacía)
      corridas = []; // Asegura que se devuelve una lista vacía en caso de error
    }
    return CalibracionEquipo(
      calibracionJson['id_calibracion'] as int,
      calibracionJson['certificado_calibracion'] as String,
      DateTime.parse(calibracionJson['fecha_calibracion']),
      DateTime.parse(calibracionJson['fecha_proxima_calibracion']),
      (calibracionJson['linealidad'] as num).toDouble(),
      (calibracionJson['reproducibilidad'] as num).toDouble(),
      calibracionJson['observaciones'] as String,
      calibracionJson['ruta_certificado'] as String,
      corridas,
      calibracionJson['tag_equipo'] as String,
      calibracionJson['id_laboratorio_calibracion'] as int,
      calibracionJson['id_usuario'] as int,
      producto,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id_calibracion': 1,
      'certificado_calibracion': certificadoCalibracion,
      'fecha_calibracion': fechaCalibracion.toIso8601String(),
      'fecha_proxima_calibracion': fechaProximaCalibracion.toIso8601String(),
      'linealidad': linealidad,
      'reproducibilidad': reproducibilidad,
      'observaciones': observaciones,
      'ruta_certificado': rutaCertificado,
      //'corrida': corridas.map((corrida) => corrida.toJson()).toList(),
      'tag_equipo': tagEquipo,
      'id_laboratorio_calibracion':
          idLaboratorioCalibracion, // Valor fijo por ahora
      'id_usuario': idUsuario, // Valor fijo por ahora
      'producto': producto.getIdProducto,
    };
  }
}
