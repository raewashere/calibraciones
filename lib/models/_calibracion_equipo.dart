import 'package:calibraciones/models/_corrida.dart';
import 'package:calibraciones/models/_lectura_temperatura.dart';
import 'package:calibraciones/models/_producto.dart';
import 'package:calibraciones/models/_lectura_presion.dart';
import 'package:calibraciones/services/corridas_service.dart';
import 'package:calibraciones/services/implementation/lectura_presion_service_impl.dart';
import 'package:calibraciones/services/implementation/lectura_temperatura_service_impl.dart';
import 'package:calibraciones/services/lectura_presion_service.dart';
import 'package:calibraciones/services/lectura_temperatura_service.dart';
import 'package:calibraciones/services/producto_service.dart';
import 'package:calibraciones/services/implementation/corrida_service_impl.dart';
import 'package:calibraciones/services/implementation/producto_service_impl.dart';

// 1. Clase Base (abstracta)
abstract class DatosPorEquipo {
  // Puedes dejarla vacía si solo funciona como contrato
}

// 2. Clases Derivadas
class DatosCalibracionFlujo extends DatosPorEquipo {
  // Asumiendo que Corrida ya existe
  late List<Corrida> corridas;
  DatosCalibracionFlujo(this.corridas);
}

class DatosCalibracionTemperatura extends DatosPorEquipo {
  // La lista de lecturas es el dato específico de la calibración de temperatura
  late List<LecturaTemperatura> lecturas;
  DatosCalibracionTemperatura(this.lecturas);
}

class DatosCalibracionPresion extends DatosPorEquipo {
  // La lista de lecturas es el dato específico de la calibración de presión
  late List<LecturaPresion> lecturas;
  DatosCalibracionPresion(this.lecturas);
}

class CalibracionEquipo {
  late int idCalibracionEquipo;
  late String certificadoCalibracion;
  late DateTime fechaCalibracion;
  late DateTime fechaProximaCalibracion;
  late double linealidad;
  late double reproducibilidad;
  late String observaciones;
  late String rutaCertificado;
  //Referencias a otros objetos
  late String tagEquipo;
  late int idLaboratorioCalibracion;
  late int idUsuario;
  late Producto producto;

  //Para cada tipo
  late DatosPorEquipo datosEspecificos;

  CalibracionEquipo(
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
    this.producto,
    this.datosEspecificos,
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
  DatosPorEquipo get getDatosPorEquipo => datosEspecificos;
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

  set setDatosEspecificos(DatosPorEquipo value) {
    datosEspecificos = value;
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
  // Inicialización de Servicios (Asumimos que están disponibles)
  final CorridasService corridaService = CorridasServiceImpl();
  final ProductosService productoService = ProductoServiceImpl();
  // 🌟 Nuevo servicio específico para Temperatura (u otros tipos)
  final LecturaTemperaturaService lecturaTemperaturaService = LecturaTemperaturaServiceImpl();
  final LecturaPresionService lecturaPresionService = LecturaPresionServiceImpl();
  
  // 1. OBTENER INFORMACIÓN COMÚN
  
  // Identificar el tipo de equipo (¡CAMPO CLAVE! ASUMIDO EN EL JSON)
  String tipoEquipo = calibracionJson['tag_equipo'] as String; // O el campo que definas
  tipoEquipo = tipoEquipo.substring(0, tipoEquipo.indexOf('-')); // Extraer tipo antes del guion bajo
  
  // Obtener el Producto (dato común)
  final Producto producto = await productoService.obtenerProductoPorId(
    calibracionJson['producto'] as int,
  );
  
  // 2. OBTENER Y CREAR DATOS ESPECÍFICOS (Polimorfismo)
  
  DatosPorEquipo? datosEspecificos;
  
  try {
    switch (tipoEquipo) {
      case 'FT':
        List<Corrida> corridas = await corridaService.obtenerCorridaPorCalibracion(
          calibracionJson['id_calibracion'],
        );
        // Instancia de la clase específica de Flujo
        datosEspecificos = DatosCalibracionFlujo(corridas);
        break;

      case 'TIT':
        List<LecturaTemperatura> lecturasTemperatura = await lecturaTemperaturaService.obtenerLecturaPorCalibracion(
          calibracionJson['id_calibracion'],
        );
        // Instancia de la clase específica de Temperatura
        datosEspecificos = DatosCalibracionTemperatura(lecturasTemperatura);
        break;

      case 'PIT':
        List<LecturaPresion> lecturasPresion = await lecturaPresionService.obtenerLecturaPorCalibracion(
          calibracionJson['id_calibracion'],
        );
        datosEspecificos = DatosCalibracionPresion(lecturasPresion); // O un valor por defecto
        break;
    }
  } catch (error) {
    // Manejo de errores en la carga de datos específicos
    print('Error al cargar datos específicos para $tipoEquipo: $error');
    datosEspecificos = null; // Asigna un objeto vacío
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
      calibracionJson['tag_equipo'] as String,
      calibracionJson['id_laboratorio_calibracion'] as int,
      calibracionJson['id_usuario'] as int,
      producto,
      datosEspecificos!,
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
