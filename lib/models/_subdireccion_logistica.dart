import 'package:calibraciones/models/_gerencia.dart';
import 'package:calibraciones/models/_subdireccion.dart';

class SubdireccionLogistica extends Subdireccion {

  late List<Gerencia> gerencias;
  SubdireccionLogistica(super.idSubdireccion, super.nombre, super.instalaciones);
  SubdireccionLogistica.withGerencias(
    super.idSubdireccion,
    super.nombre,
    super.instalaciones,
    this.gerencias,
  );

}