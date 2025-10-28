import 'package:calibraciones/common/barrel/models.dart';
class RutaEquipo {
  final Equipo equipo;
  final TrenMedicion tren;
  final PatinMedicion patin;
  final Instalacion instalacion;
  final Gerencia gerencia;
  final Subdireccion subdireccion;
  final Direccion direccion;

  RutaEquipo({
    required this.equipo,
    required this.tren,
    required this.patin,
    required this.instalacion,
    required this.gerencia,
    required this.subdireccion,
    required this.direccion,
  });

  @override
  String toString() {
    return 'Equipo: ${equipo.tagEquipo} -> Tren: ${tren.tagTren} -> Patín: ${patin.tagPatin} -> Instalación: ${instalacion.nombreInstalacion} -> Gerencia: ${gerencia.nombre} -> Subdirección: ${subdireccion.nombre} -> Dirección: ${direccion.nombre}';
  }
}

RutaEquipo? buscarRutaAscendente(List<Direccion> direcciones, String tagEquipoBuscado) {
  for (var direccion in direcciones) {
    for (var subdireccion in direccion.subdirecciones) {
      for (var gerencia in subdireccion.gerencias) {
        // La estructura de tu JSON tiene una lista de instalaciones en Gerencia.
        for (var instalacion in gerencia.instalaciones) {
          for (var patin in instalacion.patinesMedicion) {
            for (var tren in patin.trenMedicion) {
              for (var equipo in tren.equiposTren) {
                // equiposTren es una lista de objetos Equipo
                if (equipo.tagEquipo == tagEquipoBuscado) {
                  return RutaEquipo(
                    equipo: equipo,
                    tren: tren,
                    patin: patin,
                    instalacion: instalacion,
                    gerencia: gerencia,
                    subdireccion: subdireccion,
                    direccion: direccion,
                  );
                }
              }
            }
          }
        }
      }
    }
  }
  return null; // Equipo no encontrado
}