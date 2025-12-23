import 'dart:io' show File; // Esto solo se usa en móviles/escritorio
//import 'dart:typed_data';
//import 'dart:html' as html;
import 'package:calibraciones/common/barrel/models.dart';
import 'package:calibraciones/common/components/components.dart';
import 'package:calibraciones/common/barrel/services.dart';
import 'package:calibraciones/models/_lectura_densidad.dart';
import 'package:calibraciones/models/_lectura_presion.dart';
import 'package:calibraciones/models/_lectura_temperatura.dart';
import 'package:calibraciones/models/_producto.dart';
import 'package:calibraciones/services/data_service.dart';
import 'package:calibraciones/services/implementation/producto_service_impl.dart';
import 'package:calibraciones/services/producto_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:calibraciones/common/utils/conversiones.dart';

class VistaRegistroCalibracion extends StatefulWidget {
  const VistaRegistroCalibracion({super.key});

  @override
  State<StatefulWidget> createState() => VistaRegistroCalibracionState();
}

class VistaRegistroCalibracionState extends State<VistaRegistroCalibracion> {
  final CajaFormulario cajaFormulario = CajaFormulario();
  final TablaCalibracion tablaCalibracion = TablaCalibracion();
  final Conversiones convertidor = Conversiones();
  final Mensajes mensajes = Mensajes();
  final _keySeccionEquipo = GlobalKey<FormState>();
  final _keySeccionDatosCalibracion = GlobalKey<FormState>();
  final _keySeccionCorridas = GlobalKey<FormState>();
  final _keySeccionTemperatura = GlobalKey<FormState>();
  final _keySeccionPresion = GlobalKey<FormState>();
  final _keySeccionDensimetro = GlobalKey<FormState>();
  final _keySeccionExtras = GlobalKey<FormState>();

  DateFormat formato = DateFormat("dd/MM/yyyy");

  //Datos laboratorio
  final TextEditingController _laboratorioController = TextEditingController();
  final TextEditingController _productoController = TextEditingController();
  final TextEditingController _certificadoController = TextEditingController();
  final TextEditingController _archivoController = TextEditingController();
  final TextEditingController _fechaController = TextEditingController();
  final TextEditingController _fechaProximaController = TextEditingController();

  DateTime selectedFecha = DateTime.now();
  DateTime selectedFechaProxima = DateTime.now();

  //Datos corridas
  final TextEditingController _caudalM3Controller = TextEditingController();
  final TextEditingController _caudalBblController = TextEditingController();
  final TextEditingController _temperaturaCentigradosController =
      TextEditingController();
  final TextEditingController _temperaturaFahrenheitController =
      TextEditingController();
  final TextEditingController _presionController = TextEditingController();
  final TextEditingController _presionPSIController = TextEditingController();
  final TextEditingController _presionKPaController = TextEditingController();
  final TextEditingController _meterFactorController = TextEditingController();
  final TextEditingController _kFactorPulsosM3Controller =
      TextEditingController();
  final TextEditingController _kFactorPulsosBblController =
      TextEditingController();
  final TextEditingController _frecuenciaController = TextEditingController();
  final TextEditingController _repetibilidadController =
      TextEditingController();
  final TextEditingController _linealidadController = TextEditingController();
  final TextEditingController _reproducibilidadController =
      TextEditingController();
  final TextEditingController _observacionesController =
      TextEditingController();

  //Datos temperatura
  final TextEditingController _patronCelsiusController =
      TextEditingController();
  final TextEditingController _patronFahrenheitController =
      TextEditingController();
  final TextEditingController _ibcCelsiusController = TextEditingController();
  final TextEditingController _ibcFahrenheitController =
      TextEditingController();
  final TextEditingController _errorCelsiusController = TextEditingController();
  final TextEditingController _errorFahrenheitController =
      TextEditingController();
  final TextEditingController _incertidumbreCelsiusController =
      TextEditingController();
  final TextEditingController _incertidumbreFahrenheitController =
      TextEditingController();

  //Datos presion
  final TextEditingController _patronKgCm2Controller = TextEditingController();
  final TextEditingController _patronPSIController = TextEditingController();
  final TextEditingController _patronKPAController = TextEditingController();
  final TextEditingController _ibcKgCm2Controller = TextEditingController();
  final TextEditingController _ibcPSIController = TextEditingController();
  final TextEditingController _ibcKPAController = TextEditingController();
  final TextEditingController _errorKgCm2Controller = TextEditingController();
  final TextEditingController _errorPSIController = TextEditingController();
  final TextEditingController _errorKPAController = TextEditingController();
  final TextEditingController _incertidumbreKgCm2Controller =
      TextEditingController();
  final TextEditingController _incertidumbrePSIController =
      TextEditingController();
  final TextEditingController _incertidumbreKPAController =
      TextEditingController();

  //Datos densidad
  final TextEditingController _patronOperacionController =
      TextEditingController();
  final TextEditingController _patronReferenciaController =
      TextEditingController();
  final TextEditingController _ibcOperacionController = TextEditingController();
  final TextEditingController _ibcReferenciaController =
      TextEditingController();
  final TextEditingController _errorReferenciaController =
      TextEditingController();
  final TextEditingController _incertidumbreReferenciaController =
      TextEditingController();
  final TextEditingController _patronCorregidoOperacionController =
      TextEditingController();
  final TextEditingController _patronCorregidoReferenciaController =
      TextEditingController();
  final TextEditingController _ibcCorregidoOperacionController =
      TextEditingController();
  final TextEditingController _ibcCorregidoReferenciaController =
      TextEditingController();
  final TextEditingController _errorCorregidoReferenciaController =
      TextEditingController();
  final TextEditingController _incertidumbreCorregidoReferenciaController =
      TextEditingController();
  final TextEditingController _factorCorreccionController =
      TextEditingController();

  //Corridas flujo
  final List _listaCorridas = [];
  late Corrida _corridaActual;
  late final List<Corrida> _corridasRegistradas = [];

  //Lecturas temperatura
  final List _listaLecturasTemperatura = [];
  late LecturaTemperatura _lecturaActualTemperatura;
  late final List<LecturaTemperatura> _lecturasRegistradasTemperatura = [];

  //Lecturas presion
  final List _listaLecturasPresion = [];
  late LecturaPresion _lecturaActualPresion;
  late final List<LecturaPresion> _lecturasRegistradasPresion = [];

  late CalibracionEquipo _calibracionEquipo;

  CalibracionService calibracionService = CalibracionServiceImpl();

  File? fileCertificado;
  late Uint8List? fileBytes;

  bool editandoCorrida = false;
  bool editandoLecturaTemperatura = false;
  bool editandoLecturaPresion = false;
  int indiceCorridaEditando = -1;
  int indiceCorridaEditandoTemperatura = -1;
  int indiceCorridaEditandoPresion = -1;

  final FocusNode _focusNodeCaudal = FocusNode();
  final FocusNode _focusNodeTemperatura = FocusNode();
  final FocusNode _focusNodePresion = FocusNode();

  DireccionService direccionService = DireccionServiceImpl();
  LaboratorioCalibracionService laboratorioService =
      LaboratorioCalibracionServiceImpl();

  Subdireccion? selectedSubdireccion;

  late Future<List<Direccion>> _futureDirecciones;
  Direccion? selectedDireccion;
  Direccion? direccionSeleccionada;

  List<Subdireccion> subdirecciones = [];
  Subdireccion? subdireccionSeleccionada;

  List<Gerencia> gerencias = [];
  Gerencia? gerenciaSeleccionada;

  List<Instalacion> instalaciones = [];
  Instalacion? instalacionSeleccionada;

  List<PatinMedicion> patinesMedicion = [];
  PatinMedicion? patinMedicionSeleccionado;

  List<TrenMedicion> trenesMedicion = [];
  TrenMedicion? trenMedicionSeleccionado;

  List<Equipo> equiposTren = [];
  Equipo? equipoSeleccionado;

  late Future<List<LaboratorioCalibracion>> _futureLaboratorios;
  LaboratorioCalibracion? laboratorioSeleccionado;

  ProductosService productosService = ProductoServiceImpl();
  late Future<List<Producto>> _futureProductos;
  Producto? productoSeleccionado;

  bool habilitaGerencia = false;

  bool _editingM3 = false;
  bool _editingBbl = false;
  bool _editingCelsius = false;
  bool _editingFahrenheit = false;
  bool _editingPulsosM3 = false;
  bool _editingPulsosBbl = false;
  bool _editingPresion = false;
  bool _editingPresionPSI = false;
  bool _editingPresionKPa = false;

  static const double factor = 6.28981; // m³/h a bbl/h
  static const double factorPulsos = 0.158987; // bbl → m³

  static const double factorPresion = 14.22334; // PSI → kg/cm²

  Future<void> _seleccionarFecha(BuildContext context) async {
    final theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // fecha mínima
      lastDate: DateTime(2100), // fecha máxima
      locale: Locale("es", "ES"), // idioma español
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(
                context,
              ).colorScheme.primary, // Color del encabezado y selección
              onPrimary: Theme.of(
                context,
              ).colorScheme.onPrimary, // Texto en el encabezado
              onSurface: Theme.of(
                context,
              ).colorScheme.onSurface, // Texto de días
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _fechaController.text = formato.format(picked);
        selectedFecha = picked;
        selectedFechaProxima = picked.add(
          Duration(
            days: equipoSeleccionado != null
                ? equipoSeleccionado!.intervaloCalibracion
                : 0,
          ),
        );
        _fechaProximaController.text = formato.format(selectedFechaProxima);
      });
    }
  }

  void _onCaudalM3Changed(String value) {
    if (_editingBbl) return; // evita recursividad
    setState(() => _editingM3 = true);
    if (value.isNotEmpty) {
      double m3 = double.tryParse(value) ?? 0;
      _caudalBblController.text = convertidor.formatoMiles(
        Conversiones.caudalM3ToBbl(m3),
        2,
      );
    } else {
      _caudalBblController.clear();
    }
    setState(() => _editingM3 = false);
  }

  void _onCaudalBblChanged(String value) {
    if (_editingM3) return; // evita recursividad
    setState(() => _editingBbl = true);
    if (value.isNotEmpty) {
      double bbl = double.tryParse(value) ?? 0;
      _caudalM3Controller.text = convertidor.formatoMiles(
        Conversiones.caudalBblToM3(bbl),
        2,
      );
    } else {
      _caudalM3Controller.clear();
    }
    setState(() => _editingBbl = false);
  }

  void _onPulsosM3Changed(String value) {
    if (_editingPulsosBbl) return; // evita recursividad
    setState(() => _editingPulsosM3 = true);
    if (value.isNotEmpty) {
      double pm3 = double.tryParse(value) ?? 0;
      _kFactorPulsosBblController.text = convertidor.formatoMiles(
        Conversiones.m3ToBbl(pm3),
        3,
      );
    } else {
      _kFactorPulsosBblController.clear();
    }
    setState(() => _editingPulsosM3 = false);
  }

  void _onPulsosBblChanged(String value) {
    if (_editingPulsosM3) return; // evita recursividad
    setState(() => _editingPulsosBbl = true);
    if (value.isNotEmpty) {
      double pbbl = double.tryParse(value) ?? 0;
      _kFactorPulsosM3Controller.text = convertidor.formatoMiles(
        Conversiones.bblToM3(pbbl),
        3,
      );
    } else {
      _kFactorPulsosM3Controller.clear();
    }
    setState(() => _editingPulsosBbl = false);
  }

  void _onPresionChanged(String value) {
    if (_editingPresionPSI && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresion = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      _presionPSIController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToPsi(kgcm2),
        2,
      );
      _presionKPaController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        2,
      );
    } else {
      _presionPSIController.clear();
      _presionKPaController.clear();
    }
    setState(() => _editingPresion = false);
  }

  void _onPresionPSIChanged(String value) {
    if (_editingPresion && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresionPSI = true);
    if (value.isNotEmpty) {
      double psi = double.tryParse(value) ?? 0;
      _presionController.text = convertidor.formatoMiles(
        Conversiones.psiToKgCm2(psi),
        2,
      );
      _presionKPaController.text = convertidor.formatoMiles(
        Conversiones.psiToKPa(psi),
        2,
      );
    } else {
      _presionController.clear();
      _presionKPaController.clear();
    }
    setState(() => _editingPresionPSI = false);
  }

  void _onPresionKPaChanged(String value) {
    if (_editingPresionPSI && _editingPresion) return; // evita recursividad
    setState(() => _editingPresionKPa = true);
    if (value.isNotEmpty) {
      double kPa = double.tryParse(value) ?? 0;
      _presionController.text = convertidor.formatoMiles(
        Conversiones.kPaToKgCm2(kPa),
        2,
      );
      _presionPSIController.text = convertidor.formatoMiles(
        Conversiones.kPaToPsi(kPa),
        2,
      );
    } else {
      _presionController.clear();
      _presionPSIController.clear();
    }
    setState(() => _editingPresion = false);
  }

  void _onCelsiusChanged(String value) {
    if (_editingFahrenheit) return; // evita recursividad
    setState(() => _editingCelsius = true);
    if (value.isNotEmpty) {
      double celsius = double.tryParse(value) ?? 0;
      _temperaturaFahrenheitController.text = convertidor.formatoMiles(
        Conversiones.celsiusToFahrenheit(celsius),
        2,
      );
    } else {
      _temperaturaFahrenheitController.clear();
    }
    setState(() => _editingCelsius = false);
  }

  void _onFahrenheitChanged(String value) {
    if (_editingCelsius) return; // evita recursividad
    setState(() => _editingFahrenheit = true);
    if (value.isNotEmpty) {
      double fahrenheit = double.tryParse(value) ?? 0;
      _temperaturaCentigradosController.text = convertidor.formatoMiles(
        Conversiones.fahrenheitToCelsius(fahrenheit),
        2,
      );
    } else {
      _temperaturaCentigradosController.clear();
    }
    setState(() => _editingFahrenheit = false);
  }

  void _onCelsiusPatronChanged(String value) {
    double celsius = double.tryParse(value) ?? 0;
    if (_editingFahrenheit) return; // evita recursividad
    setState(() => _editingCelsius = true);
    if (value.isNotEmpty) {
      _patronFahrenheitController.text = convertidor.formatoMiles(
        Conversiones.celsiusToFahrenheit(celsius),
        3,
      );
    } else {
      _patronFahrenheitController.clear();
    }
    setState(() => _editingCelsius = false);
    calcularErrorTemperatura();
  }

  void _onFahrenheitPatronChanged(String value) {
    double fahrenheit = double.tryParse(value) ?? 0;
    if (_editingCelsius) return; // evita recursividad
    setState(() => _editingFahrenheit = true);
    if (value.isNotEmpty) {
      _patronCelsiusController.text = convertidor.formatoMiles(
        Conversiones.fahrenheitToCelsius(fahrenheit),
        3,
      );
    } else {
      _patronCelsiusController.clear();
    }
    setState(() => _editingFahrenheit = false);
    calcularErrorTemperatura();
  }

  void _onCelsiusIBCChanged(String value) {
    if (_editingFahrenheit) return; // evita recursividad
    setState(() => _editingCelsius = true);
    if (value.isNotEmpty) {
      double celsius = double.tryParse(value) ?? 0;
      _ibcFahrenheitController.text = convertidor.formatoMiles(
        Conversiones.celsiusToFahrenheit(celsius),
        3,
      );
    } else {
      _ibcFahrenheitController.clear();
    }
    setState(() => _editingCelsius = false);
    calcularErrorTemperatura();
  }

  void _onFahrenheitIBCChanged(String value) {
    if (_editingCelsius) return; // evita recursividad
    setState(() => _editingFahrenheit = true);
    if (value.isNotEmpty) {
      double fahrenheit = double.tryParse(value) ?? 0;
      _ibcCelsiusController.text = convertidor.formatoMiles(
        Conversiones.fahrenheitToCelsius(fahrenheit),
        3,
      );
    } else {
      _ibcCelsiusController.clear();
    }
    setState(() => _editingFahrenheit = false);
    calcularErrorTemperatura();
  }

  void _onCelsiusIncertidumbreChanged(String value) {
    if (_editingFahrenheit) return; // evita recursividad
    setState(() => _editingCelsius = true);
    if (value.isNotEmpty) {
      double celsius = double.tryParse(value) ?? 0;
      _incertidumbreFahrenheitController.text = convertidor.formatoMiles(
        Conversiones.celsiusToFahrenheit(celsius),
        3,
      );
    } else {
      _incertidumbreFahrenheitController.clear();
    }
    setState(() => _editingCelsius = false);
  }

  void _onFahrenheitIncertidumbreChanged(String value) {
    if (_editingCelsius) return; // evita recursividad
    setState(() => _editingFahrenheit = true);
    if (value.isNotEmpty) {
      double fahrenheit = double.tryParse(value) ?? 0;
      _incertidumbreCelsiusController.text = convertidor.formatoMiles(
        Conversiones.fahrenheitToCelsius(fahrenheit),
        3,
      );
    } else {
      _incertidumbreCelsiusController.clear();
    }
    setState(() => _editingFahrenheit = false);
  }

  void calcularErrorTemperatura() {
    double celsiusPatron = double.tryParse(_patronCelsiusController.text) ?? 0;
    double celsiusIBC = double.tryParse(_ibcCelsiusController.text) ?? 0;
    double errorCelsius = (celsiusPatron - celsiusIBC);

    double fahrenheitPatron =
        double.tryParse(_patronFahrenheitController.text) ?? 0;
    double fahrenheitIBC = double.tryParse(_ibcFahrenheitController.text) ?? 0;
    double errorFahrenheit = (fahrenheitPatron - fahrenheitIBC);

    _errorCelsiusController.text = convertidor.formatoMiles(errorCelsius, 3);
    _errorFahrenheitController.text = convertidor.formatoMiles(
      errorFahrenheit,
      3,
    );
  }

  //Conversiones de presión
  void _onKgCm2PatronChanged(String value) {
    if (_editingPresionPSI && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresion = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      _patronPSIController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToPsi(kgcm2),
        3,
      );
      _patronKPAController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        3,
      );
    } else {
      _patronPSIController.clear();
      _patronKPAController.clear();
    }
    setState(() => _editingPresion = false);
    calcularErrorPresion();
  }

  void _onPSIPatronChanged(String value) {
    if (_editingPresion && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresionPSI = true);
    if (value.isNotEmpty) {
      double psi = double.tryParse(value) ?? 0;
      double kgcm2 = Conversiones.psiToKgCm2(psi);
      _patronKgCm2Controller.text = convertidor.formatoMiles(
        Conversiones.psiToKgCm2(psi),
        3,
      );
      _patronKPAController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        3,
      );
    } else {
      _patronPSIController.clear();
      _patronKPAController.clear();
    }
    setState(() => _editingPresionPSI = false);
    calcularErrorPresion();
  }

  void _onKPaPatronChanged(String value) {
    if (_editingPresion && _editingPresionPSI) return; // evita recursividad
    setState(() => _editingPresionKPa = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      _patronPSIController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToPsi(kgcm2),
        3,
      );
      _patronKPAController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        3,
      );
    } else {
      _patronPSIController.clear();
      _patronKPAController.clear();
    }
    setState(() => _editingPresionKPa = false);
    calcularErrorPresion();
  }

  void _onKgCm2IBCChanged(String value) {
    if (_editingPresionPSI && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresion = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      _ibcPSIController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToPsi(kgcm2),
        3,
      );
      _ibcKPAController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        3,
      );
    } else {
      _ibcPSIController.clear();
      _ibcKPAController.clear();
    }
    setState(() => _editingPresion = false);
    calcularErrorPresion();
  }

  void _onPSIIBCChanged(String value) {
    if (_editingPresion && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresionPSI = true);
    if (value.isNotEmpty) {
      double psi = double.tryParse(value) ?? 0;
      double kgcm2 = Conversiones.psiToKgCm2(psi);
      _ibcKgCm2Controller.text = convertidor.formatoMiles(
        Conversiones.psiToKgCm2(psi),
        3,
      );
      _ibcKPAController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        3,
      );
    } else {
      _ibcKgCm2Controller.clear();
      _ibcKPAController.clear();
    }
    setState(() => _editingPresionPSI = false);
    calcularErrorPresion();
  }

  void _onKPaIBCChanged(String value) {
    if (_editingPresion && _editingPresionPSI) return; // evita recursividad
    setState(() => _editingPresionKPa = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      _ibcPSIController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToPsi(kgcm2),
        3,
      );
      _ibcKPAController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        3,
      );
    } else {
      _ibcPSIController.clear();
      _ibcKPAController.clear();
    }
    setState(() => _editingPresionKPa = false);
    calcularErrorPresion();
  }

  void calcularErrorPresion() {
    double kgCm2Patron = double.tryParse(_patronKgCm2Controller.text) ?? 0;
    double kgCm2IBC = double.tryParse(_ibcKgCm2Controller.text) ?? 0;
    double errorKgCm2 = (kgCm2Patron - kgCm2IBC);

    double psiPatron = double.tryParse(_patronPSIController.text) ?? 0;
    double psiIBC = double.tryParse(_ibcPSIController.text) ?? 0;
    double errorPsi = (psiPatron - psiIBC);

    double kPaPatron = double.tryParse(_patronKPAController.text) ?? 0;
    double kPaIBC = double.tryParse(_ibcKPAController.text) ?? 0;
    double errorKPa = (kPaPatron - kPaIBC);

    _errorKgCm2Controller.text = convertidor.formatoMiles(errorKgCm2, 3);
    _errorPSIController.text = convertidor.formatoMiles(errorPsi, 3);
    _errorKPAController.text = convertidor.formatoMiles(errorKPa, 3);
  }

  void _onKgCm2IncertidumbreChanged(String value) {
    if (_editingPresionPSI && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresion = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      _incertidumbrePSIController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToPsi(kgcm2),
        3,
      );
      _incertidumbreKPAController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        3,
      );
    } else {
      _incertidumbrePSIController.clear();
      _incertidumbreKPAController.clear();
    }
    setState(() => _editingPresion = false);
    calcularErrorPresion();
  }

  void _onPSIIncertidumbreChanged(String value) {
    if (_editingPresion && _editingPresionKPa) return; // evita recursividad
    setState(() => _editingPresionPSI = true);
    if (value.isNotEmpty) {
      double psi = double.tryParse(value) ?? 0;
      double kgcm2 = Conversiones.psiToKgCm2(psi);
      _incertidumbreKgCm2Controller.text = convertidor.formatoMiles(
        Conversiones.psiToKgCm2(psi),
        3,
      );
      _incertidumbreKPAController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        3,
      );
    } else {
      _incertidumbreKgCm2Controller.clear();
      _incertidumbreKPAController.clear();
    }
    setState(() => _editingPresionPSI = false);
    calcularErrorPresion();
  }

  void _onKPaIncertidumbreChanged(String value) {
    if (_editingPresion && _editingPresionPSI) return; // evita recursividad
    setState(() => _editingPresionKPa = true);
    if (value.isNotEmpty) {
      double kgcm2 = double.tryParse(value) ?? 0;
      _incertidumbrePSIController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToPsi(kgcm2),
        3,
      );
      _incertidumbreKPAController.text = convertidor.formatoMiles(
        Conversiones.kgCm2ToKPa(kgcm2),
        3,
      );
    } else {
      _incertidumbrePSIController.clear();
      _incertidumbreKPAController.clear();
    }
    setState(() => _editingPresionKPa = false);
    calcularErrorPresion();
  }

  void calcularErrorDensidad(String value) {
    double patronReferencia =
        double.tryParse(_patronReferenciaController.text) ?? 0;
    double ibcReferencia = double.tryParse(_ibcReferenciaController.text) ?? 0;
    double errorReferencia = (ibcReferencia - patronReferencia);

    _errorReferenciaController.text = convertidor.formatoMiles(
      errorReferencia,
      3,
    );
  }

  void calcularErrorDensidadCorregido(String value) {
    double patronReferenciaCorregido =
        double.tryParse(_patronCorregidoReferenciaController.text) ?? 0;
    double ibcReferenciaCorregido =
        double.tryParse(_ibcCorregidoReferenciaController.text) ?? 0;
    double errorReferencia =
        (ibcReferenciaCorregido - patronReferenciaCorregido);

    _errorCorregidoReferenciaController.text = convertidor.formatoMiles(
      errorReferencia,
      3,
    );
  }

  bool validarEmail(String email) {
    final RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  @override
  void initState() {
    super.initState();
    _futureDirecciones = DataService().updateAndCacheData();
    _futureLaboratorios = laboratorioService.obtenerAllLaboratorios();
    _futureProductos = productosService.obtenerAllProductos();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.onPrimary,
      body: FutureBuilder<List<Direccion>>(
        future: _futureDirecciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: \\${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay direcciones disponibles'));
          } else {
            final lista = snapshot.data!;
            direccionSeleccionada ??= lista[0];
            return SingleChildScrollView(
              child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(color: theme.colorScheme.onPrimary),
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _keySeccionEquipo,
                      child: Container(
                        decoration: cajaFormulario.boxDecoration(context),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Equipo",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      _iconoAyudaSeccion(
                                        context,
                                        'Seleccione la ubicación del equipo a calibrar, inicie con la dirección, subdirección, gerencia (si aplica), instalación, patín de medición, tren de medición y finalmente el equipo.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    _buildDropdownButtonDireccion(
                                      context,
                                      hintText: "Dirección",
                                      items: _futureDirecciones,
                                      value: direccionSeleccionada,
                                      onChanged: (value) {
                                        setState(() {
                                          subdireccionSeleccionada = null;
                                          gerenciaSeleccionada = null;
                                          instalacionSeleccionada = null;
                                          patinMedicionSeleccionado = null;
                                          trenMedicionSeleccionado = null;
                                          equipoSeleccionado = null;
                                          subdirecciones = [];
                                          gerencias = [];
                                          instalaciones = [];
                                          patinesMedicion = [];
                                          trenesMedicion = [];
                                          equiposTren = [];
                                          direccionSeleccionada = value;
                                          subdirecciones =
                                              value!.subdirecciones;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonSubdireccion(
                                      context,
                                      hintText: "Subdirección",
                                      items: subdirecciones,
                                      value: subdireccionSeleccionada,
                                      onChanged: (value) {
                                        setState(() {
                                          gerenciaSeleccionada = null;
                                          instalacionSeleccionada = null;
                                          patinMedicionSeleccionado = null;
                                          trenMedicionSeleccionado = null;
                                          equipoSeleccionado = null;
                                          gerencias = [];
                                          instalaciones = [];
                                          patinesMedicion = [];
                                          trenesMedicion = [];
                                          equiposTren = [];
                                          subdireccionSeleccionada = value;
                                          if (value!.gerencias.isEmpty) {
                                            instalaciones = value.instalaciones;
                                            habilitaGerencia = false;
                                          } else {
                                            gerencias = value.gerencias;
                                            habilitaGerencia = true;
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    habilitaGerencia
                                        ? _buildDropdownButtonGerencia(
                                            context,
                                            hintText: "Gerencia",
                                            items: gerencias,
                                            value: gerenciaSeleccionada,
                                            onChanged: (value) {
                                              setState(() {
                                                instalacionSeleccionada = null;
                                                patinMedicionSeleccionado =
                                                    null;
                                                trenMedicionSeleccionado = null;
                                                equipoSeleccionado = null;
                                                instalaciones = [];
                                                patinesMedicion = [];
                                                trenesMedicion = [];
                                                equiposTren = [];
                                                gerenciaSeleccionada = value;
                                                instalaciones =
                                                    value!.instalaciones;
                                              });
                                            },
                                          )
                                        : SizedBox.shrink(),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonInstalaciones(
                                      context,
                                      hintText: "Instalación",
                                      items: instalaciones,
                                      value: instalacionSeleccionada,
                                      onChanged: (value) {
                                        setState(() {
                                          patinMedicionSeleccionado = null;
                                          trenMedicionSeleccionado = null;
                                          equipoSeleccionado = null;
                                          patinesMedicion = [];
                                          trenesMedicion = [];
                                          equiposTren = [];
                                          instalacionSeleccionada = value;
                                          patinesMedicion =
                                              value!.getPatinesMedicion;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonPatines(
                                      context,
                                      hintText: "Patín de Medición",
                                      items: patinesMedicion,
                                      value: patinMedicionSeleccionado,
                                      onChanged: (value) {
                                        setState(() {
                                          trenMedicionSeleccionado = null;
                                          equipoSeleccionado = null;
                                          trenesMedicion = [];
                                          equiposTren = [];
                                          patinMedicionSeleccionado = value;
                                          trenesMedicion =
                                              value!.getTrenMedicion;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonTrenes(
                                      context,
                                      hintText: "Tren de Medición",
                                      items: trenesMedicion,
                                      value: trenMedicionSeleccionado,
                                      onChanged: (value) {
                                        setState(() {
                                          equipoSeleccionado = null;
                                          equiposTren = [];
                                          trenMedicionSeleccionado = value;
                                          equiposTren = value!.getEquiposTren;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonEquipos(
                                      context,
                                      hintText: "Equipo",
                                      items: equiposTren,
                                      value: equipoSeleccionado,
                                      onChanged: (value) {
                                        setState(() {
                                          equipoSeleccionado = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Form(
                      key: _keySeccionDatosCalibracion,
                      child: Container(
                        decoration: cajaFormulario.boxDecoration(context),
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: Row(
                                    children: [
                                      Text(
                                        "Datos calibración",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.tertiary,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      _iconoAyudaSeccion(
                                        context,
                                        'Elige el laboratorio que realizó la calibración, ingrese el producto calibrado, el número y archivo del certificado, así como la fecha de calibración y la fecha de la próxima calibración.',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    _buildDropdownButtonLaboratorio(
                                      context,
                                      hintText: "Laboratorio de calibración",
                                      items: _futureLaboratorios,
                                      value: laboratorioSeleccionado,
                                      onChanged: (value) {
                                        setState(() {
                                          laboratorioSeleccionado = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    _buildDropdownButtonProducto(
                                      context,
                                      hintText: "Producto",
                                      items: _futureProductos,
                                      value: productoSeleccionado,
                                      onChanged: (value) {
                                        setState(() {
                                          productoSeleccionado = value;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildTextFormField(
                                            context,
                                            hintText: "No. Certificado",
                                            validatorText:
                                                'Favor de escribir el número de certificado',
                                            controllerText:
                                                _certificadoController,
                                            decimales: 0,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildFileFormField(
                                            context,
                                            hintText: "Archivo certificado",
                                            validatorText:
                                                'Favor de seleccionar el archivo del certificado',
                                            controllerText: _archivoController,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildDateFormField(
                                            context,
                                            hintText: "Fecha calibración",
                                            validatorText:
                                                'Favor de escribir la fecha',
                                            controllerText: _fechaController,
                                            tipoFecha: 1,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 12,
                                        ), // separación entre campos
                                        Expanded(
                                          child: _buildDateFormField(
                                            context,
                                            hintText: "Próxima calibración",
                                            validatorText:
                                                'Favor de escribir la fecha',
                                            controllerText:
                                                _fechaProximaController,
                                            tipoFecha: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildSeccionPorTipoSensor(context),
                    SizedBox(height: 20),
                    _buildSeccionExtras(context),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _guardarCalibracion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                        ),
                        child: Text('Registrar'),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _guardarCalibracion() async {
    bool exito = false;
    if (equipoSeleccionado?.getIdTipoSensor.toString() == '1') {
      if (_corridasRegistradas.isEmpty && _corridasRegistradas.length < 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          mensajes.error(context, 'Debe registrar al menos 5 corridas'),
        );
        return;
      } else {
        if (!_keySeccionEquipo.currentState!.validate() &&
            !_keySeccionDatosCalibracion.currentState!.validate() &&
            !_keySeccionExtras.currentState!.validate()) {
          return;
        }

        final datosDeFlujo = DatosCalibracionFlujo(_corridasRegistradas);

        _calibracionEquipo = CalibracionEquipo(
          0,
          _certificadoController.text,
          selectedFecha,
          selectedFechaProxima,
          double.tryParse(_linealidadController.text) ?? 0,
          double.tryParse(_reproducibilidadController.text) ?? 0,
          _observacionesController.text,
          '', // ruta certificado
          equipoSeleccionado!.getTagEquipo,
          laboratorioSeleccionado!.getIdLaboratorioCalibracion,
          0,
          productoSeleccionado!,
          datosDeFlujo,
        );
      }
    } else if (equipoSeleccionado?.getIdTipoSensor.toString() == '2') {
      if (_lecturasRegistradasTemperatura.isEmpty &&
          _lecturasRegistradasTemperatura.length < 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          mensajes.error(context, 'Debe registrar al menos 5 lecturas'),
        );
        return;
      } else {
        if (!_keySeccionEquipo.currentState!.validate() &&
            !_keySeccionDatosCalibracion.currentState!.validate()) {
          return;
        }

        final datosDeTemperatura = DatosCalibracionTemperatura(
          _lecturasRegistradasTemperatura,
        );

        _calibracionEquipo = CalibracionEquipo(
          0,
          _certificadoController.text,
          selectedFecha,
          selectedFechaProxima,
          0,
          0,
          '',
          '', // ruta certificado
          equipoSeleccionado!.getTagEquipo,
          laboratorioSeleccionado!.getIdLaboratorioCalibracion,
          0,
          productoSeleccionado!,
          datosDeTemperatura,
        );
      }
    } else if (equipoSeleccionado?.getIdTipoSensor.toString() == '3') {
      if (_lecturasRegistradasPresion.isEmpty &&
          _lecturasRegistradasPresion.length < 5) {
        ScaffoldMessenger.of(context).showSnackBar(
          mensajes.error(context, 'Debe registrar al menos 5 lecturas'),
        );
        return;
      } else {
        if (!_keySeccionEquipo.currentState!.validate() &&
            !_keySeccionDatosCalibracion.currentState!.validate()) {
          return;
        }

        final datosDePresion = DatosCalibracionPresion(
          _lecturasRegistradasPresion,
        );

        _calibracionEquipo = CalibracionEquipo(
          0,
          _certificadoController.text,
          selectedFecha,
          selectedFechaProxima,
          0,
          0,
          '',
          '', // ruta certificado
          equipoSeleccionado!.getTagEquipo,
          laboratorioSeleccionado!.getIdLaboratorioCalibracion,
          0,
          productoSeleccionado!,
          datosDePresion,
        );
      }
    } else if (equipoSeleccionado?.getIdTipoSensor.toString() == '4') {
      if (!_keySeccionEquipo.currentState!.validate() &&
          !_keySeccionDatosCalibracion.currentState!.validate() &&
          !_keySeccionDensimetro.currentState!.validate()) {
        return;
      }

      LecturaDensidad lecturaDensidad = LecturaDensidad(
        0,
        double.tryParse(_patronOperacionController.text.replaceAll(',', '')) ??
            0,
        double.tryParse(_patronReferenciaController.text.replaceAll(',', '')) ??
            0,
        double.tryParse(_ibcOperacionController.text.replaceAll(',', '')) ?? 0,
        double.tryParse(_ibcReferenciaController.text.replaceAll(',', '')) ?? 0,
        double.tryParse(_errorReferenciaController.text.replaceAll(',', '')) ??
            0,
        double.tryParse(
              _incertidumbreReferenciaController.text.replaceAll(',', ''),
            ) ??
            0,
        double.tryParse(
              _patronCorregidoOperacionController.text.replaceAll(',', ''),
            ) ??
            0,
        double.tryParse(
              _patronCorregidoReferenciaController.text.replaceAll(',', ''),
            ) ??
            0,
        double.tryParse(
              _ibcCorregidoOperacionController.text.replaceAll(',', ''),
            ) ??
            0,
        double.tryParse(
              _ibcCorregidoReferenciaController.text.replaceAll(',', ''),
            ) ??
            0,
        double.tryParse(
              _errorCorregidoReferenciaController.text.replaceAll(',', ''),
            ) ??
            0,
        double.tryParse(
              _incertidumbreCorregidoReferenciaController.text.replaceAll(
                ',',
                '',
              ),
            ) ??
            0,
        double.tryParse(_factorCorreccionController.text.replaceAll(',', '')) ??
            0,
        0,
      );

      final datosDeDensidad = DatosCalibracionDensidad(lecturaDensidad);

      _calibracionEquipo = CalibracionEquipo(
        0,
        _certificadoController.text,
        selectedFecha,
        selectedFechaProxima,
        0,
        0,
        '',
        '', // ruta certificado
        equipoSeleccionado!.getTagEquipo,
        laboratorioSeleccionado!.getIdLaboratorioCalibracion,
        0,
        productoSeleccionado!,
        datosDeDensidad,
      );
    }

    exito = await calibracionService.registrarCalibracionEquipo(
      direccionSeleccionada!.nombre,
      subdireccionSeleccionada!.nombre,
      gerenciaSeleccionada!.nombre,
      instalacionSeleccionada!.nombreInstalacion,
      patinMedicionSeleccionado!.getTagPatin,
      trenMedicionSeleccionado!.tagTren,
      _calibracionEquipo,
      fileBytes!,
    );

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        mensajes.info(context, 'Calibración registrada con éxito'),
      );
      //limpiar formulario
      setState(() {
        _laboratorioController.clear();
        _productoController.clear();
        _archivoController.clear();
        _certificadoController.clear();
        fileBytes = null;
        fileCertificado = null;
        _keySeccionEquipo.currentState!.reset();
        _keySeccionDatosCalibracion.currentState!.reset();
        direccionSeleccionada = null;
        subdireccionSeleccionada = null;
        gerenciaSeleccionada = null;
        instalacionSeleccionada = null;
        patinMedicionSeleccionado = null;
        trenMedicionSeleccionado = null;
        equipoSeleccionado = null;
        laboratorioSeleccionado = null;
        productoSeleccionado = null;
        _corridasRegistradas.clear();
        _lecturasRegistradasTemperatura.clear();
        _lecturasRegistradasPresion.clear();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        mensajes.error(context, 'Error al registrar la calibración'),
      );
    }
  }

  void _agregarCorrida() {
    if (!_keySeccionCorridas.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(mensajes.info(context, 'Se  agregó una corrida'));
    _corridaActual = Corrida(
      _listaCorridas.length + 1,
      double.tryParse(_caudalM3Controller.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_caudalBblController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(
            _temperaturaCentigradosController.text.replaceAll(',', ''),
          ) ??
          0,
      double.tryParse(
            _temperaturaFahrenheitController.text.replaceAll(',', ''),
          ) ??
          0,
      double.tryParse(_presionController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_presionPSIController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_presionKPaController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_meterFactorController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_kFactorPulsosM3Controller.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_kFactorPulsosBblController.text.replaceAll(',', '')) ??
          0,
      double.tryParse(_repetibilidadController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_frecuenciaController.text.replaceAll(',', '')) ?? 0,
      0,
    );

    setState(() {
      if (editandoCorrida && indiceCorridaEditando != -1) {
        // Si estamos editando, reemplazamos la corrida en el índice correspondiente
        _corridasRegistradas[indiceCorridaEditando] = _corridaActual;
        _listaCorridas[indiceCorridaEditando] = _corridaActual;
        editandoCorrida = false;
        indiceCorridaEditando = -1;
      } else {
        _listaCorridas.add(_corridaActual);
        _corridasRegistradas.add(_corridaActual);
      }
    });

    _linealidadController.text = convertidor.calcularLinealidad(
      _corridasRegistradas,
    );

    // dar focus después de limpiar
    FocusScope.of(context).requestFocus(_focusNodeCaudal);
  }

  void _agregarLecturaTemperatura() {
    if (!_keySeccionTemperatura.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      mensajes.info(context, 'Se  agregó una lectura de temperatura'),
    );
    _lecturaActualTemperatura = LecturaTemperatura(
      _listaLecturasTemperatura.length + 1,
      double.tryParse(_patronCelsiusController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_patronFahrenheitController.text.replaceAll(',', '')) ??
          0,
      double.tryParse(_ibcCelsiusController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_ibcFahrenheitController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_errorCelsiusController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_errorFahrenheitController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(
            _incertidumbreCelsiusController.text.replaceAll(',', ''),
          ) ??
          0,
      double.tryParse(
            _incertidumbreFahrenheitController.text.replaceAll(',', ''),
          ) ??
          0,
      0,
    );

    setState(() {
      if (editandoLecturaTemperatura &&
          indiceCorridaEditandoTemperatura != -1) {
        // Si estamos editando, reemplazamos la corrida en el índice correspondiente
        _lecturasRegistradasTemperatura[indiceCorridaEditandoTemperatura] =
            _lecturaActualTemperatura;
        _listaLecturasTemperatura[indiceCorridaEditandoTemperatura] =
            _lecturaActualTemperatura;
        editandoLecturaTemperatura = false;
        indiceCorridaEditandoTemperatura = -1;
      } else {
        _listaLecturasTemperatura.add(_lecturaActualTemperatura);
        _lecturasRegistradasTemperatura.add(_lecturaActualTemperatura);
      }
    });
    // dar focus después de limpiar
    _limpiaLecturaTemperatura();
    FocusScope.of(context).requestFocus(_focusNodeTemperatura);
  }

  void _agregarLecturaPresion() {
    if (!_keySeccionPresion.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(mensajes.info(context, 'Se  agregó una lectura de presión'));
    _lecturaActualPresion = LecturaPresion(
      _listaLecturasPresion.length + 1,
      double.tryParse(_patronKgCm2Controller.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_patronPSIController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_patronKPAController.text.replaceAll(',', '')) ?? 0,

      double.tryParse(_ibcKgCm2Controller.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_ibcPSIController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_ibcKPAController.text.replaceAll(',', '')) ?? 0,

      double.tryParse(_errorKgCm2Controller.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_errorPSIController.text.replaceAll(',', '')) ?? 0,
      double.tryParse(_errorKPAController.text.replaceAll(',', '')) ?? 0,

      double.tryParse(_incertidumbreKgCm2Controller.text.replaceAll(',', '')) ??
          0,
      double.tryParse(_incertidumbrePSIController.text.replaceAll(',', '')) ??
          0,
      double.tryParse(_incertidumbreKPAController.text.replaceAll(',', '')) ??
          0,
      0,
    );

    setState(() {
      if (editandoLecturaPresion && indiceCorridaEditandoPresion != -1) {
        // Si estamos editando, reemplazamos la corrida en el índice correspondiente
        _lecturasRegistradasPresion[indiceCorridaEditandoPresion] =
            _lecturaActualPresion;
        _listaLecturasPresion[indiceCorridaEditandoPresion] =
            _lecturaActualPresion;
        editandoLecturaPresion = false;
        indiceCorridaEditandoPresion = -1;
      } else {
        _listaLecturasPresion.add(_lecturaActualPresion);
        _lecturasRegistradasPresion.add(_lecturaActualPresion);
      }
    });
    // dar focus después de limpiar
    _limpiaLecturaPresion();
    FocusScope.of(context).requestFocus(_focusNodePresion);
  }

  void _limpiaCorrida() {
    setState(() {
      _caudalM3Controller.clear();
      _caudalBblController.clear();
      _temperaturaCentigradosController.clear();
      _temperaturaFahrenheitController.clear();
      _presionController.clear();
      _presionPSIController.clear();
      _presionKPaController.clear();
      _meterFactorController.clear();
      _kFactorPulsosM3Controller.clear();
      _kFactorPulsosBblController.clear();
      _frecuenciaController.clear();
      _repetibilidadController.clear();
    });

    FocusScope.of(context).requestFocus(_focusNodeCaudal);
  }

  void _limpiaLecturaTemperatura() {
    setState(() {
      _patronCelsiusController.clear();
      _patronFahrenheitController.clear();
      _ibcCelsiusController.clear();
      _ibcFahrenheitController.clear();
      _errorCelsiusController.clear();
      _errorFahrenheitController.clear();
      _incertidumbreCelsiusController.clear();
      _incertidumbreFahrenheitController.clear();
    });

    FocusScope.of(context).requestFocus(_focusNodeTemperatura);
  }

  void _limpiaLecturaPresion() {
    setState(() {
      _patronKgCm2Controller.clear();
      _patronPSIController.clear();
      _patronKPAController.clear();

      _ibcKgCm2Controller.clear();
      _ibcPSIController.clear();
      _ibcKPAController.clear();

      _errorKgCm2Controller.clear();
      _errorPSIController.clear();
      _errorKPAController.clear();

      _incertidumbreKgCm2Controller.clear();
      _incertidumbrePSIController.clear();
      _incertidumbreKPAController.clear();
      _incertidumbrePSIController.clear();
    });

    FocusScope.of(context).requestFocus(_focusNodePresion);
  }

  InputDecoration _inputDecoration(String label) =>
      InputDecoration(labelText: label, border: const OutlineInputBorder());

  Widget _buildTextFormField(
    BuildContext context, {
    required String hintText,
    required String validatorText,
    required TextEditingController controllerText,
    bool obscureText = false,
    FocusNode? focusNode,
    ValueChanged<String>? onChanged,
    required int decimales,
    bool? readOnly = false,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(5),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && decimales > 0) {
            String textoFormateado = convertidor.formatoMiles(
              double.tryParse(controllerText.text) ?? 0,
              decimales,
            );
            controllerText.text = textoFormateado;
          }
        },
        child: TextFormField(
          focusNode: focusNode,
          controller: controllerText,
          obscureText: obscureText,
          style: TextStyle(color: theme.colorScheme.primary),
          decoration: _inputDecoration(hintText),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validatorText;
            }
            return null;
          },
          onChanged: onChanged,
          readOnly: readOnly!,
        ),
      ),
    );
  }

  Widget _buildDateFormField(
    BuildContext context, {
    required String hintText,
    required String validatorText,
    required TextEditingController controllerText,
    bool obscureText = false,
    FocusNode? focusNode,
    required int tipoFecha,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        focusNode: focusNode,
        readOnly: true,
        controller: controllerText,
        obscureText: obscureText,
        style: TextStyle(color: theme.colorScheme.primary),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.calendar_today),
          hintText: hintText,
          label: Text(hintText),
          hintStyle: TextStyle(color: theme.colorScheme.surface),
          border: const OutlineInputBorder(),
        ),
        onTap: () => tipoFecha == 1 ? _seleccionarFecha(context) : null,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorText;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownButtonDireccion(
    BuildContext context, {
    required String hintText,
    required Future<List<Direccion>> items,
    required Direccion? value,
    required ValueChanged<Direccion?> onChanged,
  }) {
    //future to list
    final theme = Theme.of(context);
    return FutureBuilder<List<Direccion>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final direcciones = snapshot.data!;
          return DropdownButtonFormField<Direccion>(
            isExpanded: true,
            decoration: _inputDecoration(hintText),
            initialValue: value,
            dropdownColor: theme.colorScheme.tertiaryContainer,
            items: direcciones.map((Direccion item) {
              return DropdownMenuItem<Direccion>(
                value: item,
                child: Text(item.getNombre),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona una opción';
              }
              return null;
            },
          );
        }
      },
    );
  }

  Widget _buildDropdownButtonSubdireccion(
    BuildContext context, {
    required String hintText,
    required List<Subdireccion> items,
    required Subdireccion? value,
    required ValueChanged<Subdireccion?> onChanged,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<Subdireccion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: theme.colorScheme.tertiaryContainer,
      items: items.map((Subdireccion item) {
        return DropdownMenuItem<Subdireccion>(
          value: item,
          child: Text(item.nombre),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonGerencia(
    BuildContext context, {
    required String hintText,
    required List<Gerencia> items,
    required Gerencia? value,
    required ValueChanged<Gerencia?> onChanged,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<Gerencia>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: theme.colorScheme.tertiaryContainer,
      items: items.map((Gerencia item) {
        return DropdownMenuItem<Gerencia>(
          value: item,
          child: Text(item.nombre),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonInstalaciones(
    BuildContext context, {
    required String hintText,
    required List<Instalacion> items,
    required Instalacion? value,
    required ValueChanged<Instalacion?> onChanged,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<Instalacion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: theme.colorScheme.tertiaryContainer,
      items: items.map((Instalacion item) {
        return DropdownMenuItem<Instalacion>(
          value: item,
          child: Text(item.getNombreInstalacion),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonPatines(
    BuildContext context, {
    required String hintText,
    required List<PatinMedicion> items,
    required PatinMedicion? value,
    required ValueChanged<PatinMedicion?> onChanged,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<PatinMedicion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: theme.colorScheme.tertiaryContainer,
      items: items.map((PatinMedicion item) {
        return DropdownMenuItem<PatinMedicion>(
          value: item,
          child: Text(item.getNombrePatin),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonTrenes(
    BuildContext context, {
    required String hintText,
    required List<TrenMedicion> items,
    required TrenMedicion? value,
    required ValueChanged<TrenMedicion?> onChanged,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<TrenMedicion>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: theme.colorScheme.tertiaryContainer,
      items: items.map((TrenMedicion item) {
        return DropdownMenuItem<TrenMedicion>(
          value: item,
          child: Text(item.getTagTren),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonEquipos(
    BuildContext context, {
    required String hintText,
    required List<Equipo> items,
    required Equipo? value,
    required ValueChanged<Equipo?> onChanged,
  }) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<Equipo>(
      isExpanded: true,
      decoration: _inputDecoration(hintText),
      initialValue: value,
      dropdownColor: theme.colorScheme.tertiaryContainer,
      items: items.map((Equipo item) {
        return DropdownMenuItem<Equipo>(
          value: item,
          child: Text(item.getTagEquipo),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null) {
          return 'Por favor selecciona una opción';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownButtonLaboratorio(
    BuildContext context, {
    required String hintText,
    required Future<List<LaboratorioCalibracion>> items,
    required LaboratorioCalibracion? value,
    required ValueChanged<LaboratorioCalibracion?> onChanged,
  }) {
    //future to list
    final theme = Theme.of(context);
    return FutureBuilder<List<LaboratorioCalibracion>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final direcciones = snapshot.data!;
          return DropdownButtonFormField<LaboratorioCalibracion>(
            isExpanded: true,
            decoration: _inputDecoration(hintText),
            initialValue: value,
            dropdownColor: theme.colorScheme.tertiaryContainer,
            items: direcciones.map((LaboratorioCalibracion item) {
              return DropdownMenuItem<LaboratorioCalibracion>(
                value: item,
                child: Text(item.getNombre),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona una opción';
              }
              return null;
            },
          );
        }
      },
    );
  }

  Widget _buildDropdownButtonProducto(
    BuildContext context, {
    required String hintText,
    required Future<List<Producto>> items,
    required Producto? value,
    required ValueChanged<Producto?> onChanged,
  }) {
    //future to list
    final theme = Theme.of(context);
    return FutureBuilder<List<Producto>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final direcciones = snapshot.data!;
          return DropdownButtonFormField<Producto>(
            isExpanded: true,
            decoration: _inputDecoration(hintText),
            initialValue: value,
            dropdownColor: theme.colorScheme.tertiaryContainer,
            items: direcciones.map((Producto item) {
              return DropdownMenuItem<Producto>(
                value: item,
                child: Text(item.getProducto),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null) {
                return 'Por favor selecciona una opción';
              }
              return null;
            },
          );
        }
      },
    );
  }

  /*void _pickFileWeb() {
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = '.pdf';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final file = uploadInput.files!.first;
      final reader = html.FileReader();

      reader.readAsArrayBuffer(file);
      reader.onLoadEnd.listen((e) {
        _archivoController.text = file.name;
        fileBytes = reader.result as Uint8List;
      });
    });
  }*/

  Future<void> _pickFileWeb() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null && result.files.isNotEmpty) {
    setState(() {
      _archivoController.text = result.files.single.name;

      if (kIsWeb) {
        // En web NO hay path, solo bytes
        fileBytes = result.files.single.bytes;
        fileCertificado = null; // o ignóralo
      } else {
        // En móvil/escritorio SÍ hay path
        fileCertificado = File(result.files.single.path!);
        fileBytes = null; // o ambas, según necesites
      }
    });
  }
}

  Widget _buildFileFormField(
    BuildContext context, {
    required String hintText,
    required String validatorText,
    required TextEditingController controllerText,
    bool obscureText = false,
    FocusNode? focusNode,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(5),
      child: TextFormField(
        focusNode: focusNode,
        readOnly: true,
        controller: controllerText,
        obscureText: obscureText,
        style: TextStyle(color: theme.colorScheme.primary),
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.upload_file),
          hintText: hintText,
          label: Text(hintText),
          hintStyle: TextStyle(color: theme.colorScheme.surface),
          border: const OutlineInputBorder(),
        ),
        onTap: () => _pickFileWeb(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Por favor selecciona un archivo PDF";
          }
          return null;
        },
      ),
    );
  }

  IconButton _iconoAyudaSeccion(BuildContext context, String mensaje) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(
        Icons.help_outline_rounded, // ícono más estilizado
        color: theme.colorScheme.primary,
        size: 22,
      ),
      tooltip: 'Ayuda',
      onPressed: () {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(mensajes.ayuda(context, mensaje));
      },
    );
  }

  //Secciones cambiantes por tipo equipo
  Widget _seccionCorridas(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _keySeccionCorridas,
      child: Container(
        decoration: cajaFormulario.boxDecoration(context),
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        "Corridas",
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(width: 10),
                      _iconoAyudaSeccion(
                        context,
                        'Ingrese los datos de la corrida de calibración y agreguela a la tabla, las conversiones se hacen en automático, también elimine las corridas que no sean necesarias.',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Caudal (m³/hr)",
                            validatorText: 'Favor de escribir el caudal',
                            controllerText: _caudalM3Controller,
                            focusNode: _focusNodeCaudal,
                            onChanged: _onCaudalM3Changed,
                            decimales: 2,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Caudal (bbl/hr)",
                            validatorText: 'Favor de escribir el caudal',
                            controllerText: _caudalBblController,
                            onChanged: _onCaudalBblChanged,
                            decimales: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Temperatura (°C)",
                            validatorText: 'Favor de escribir la temperatura',
                            controllerText: _temperaturaCentigradosController,
                            onChanged: _onCelsiusChanged,
                            decimales: 2,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Temperatura (°F)",
                            validatorText: 'Favor de escribir la temperatura',
                            controllerText: _temperaturaFahrenheitController,
                            onChanged: _onFahrenheitChanged,
                            decimales: 2,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Presión (kg/cm2)",
                            validatorText: 'Favor de escribir la presión',
                            controllerText: _presionController,
                            onChanged: _onPresionChanged,
                            decimales: 2,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Presión (PSI)",
                            validatorText: 'Favor de escribir la presión',
                            controllerText: _presionPSIController,
                            onChanged: _onPresionPSIChanged,
                            decimales: 2,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Presión (kPa)",
                            validatorText: 'Favor de escribir la presión',
                            controllerText: _presionKPaController,
                            onChanged: _onPresionKPaChanged,
                            decimales: 2,
                          ),
                        ),
                      ],
                    ),
                    _buildTextFormField(
                      context,
                      hintText: "Meter Factor",
                      validatorText: 'Favor de escribir el Meter Factor',
                      controllerText: _meterFactorController,
                      decimales: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "K Factor (pulsos/m3)",
                            validatorText:
                                'Favor de escribir el K Factor (pulsos/m3)',
                            controllerText: _kFactorPulsosM3Controller,
                            onChanged: _onPulsosM3Changed,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "K Factor (pulsos/bbl)",
                            validatorText:
                                'Favor de escribir el K Factor (pulsos/bbl)',
                            controllerText: _kFactorPulsosBblController,
                            onChanged: _onPulsosBblChanged,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),

                    _buildTextFormField(
                      context,
                      hintText: "Frecuencia (Hz)",
                      validatorText: 'Favor de escribir la frecuencia',
                      controllerText: _frecuenciaController,
                      decimales: 2,
                    ),
                    _buildTextFormField(
                      context,
                      hintText: "Repetibilidad (%)",
                      validatorText: 'Favor de escribir la repetibilidad',
                      controllerText: _repetibilidadController,
                      decimales: 3,
                    ),
                    SizedBox(height: 20),
                    Table(
                      border: TableBorder.symmetric(
                        inside: const BorderSide(color: Colors.black, width: 1),
                        outside: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                          ),
                          children: [
                            tablaCalibracion.cabeceraTabla(context, 'Caudal'),
                            tablaCalibracion.cabeceraTabla(context, 'Caudal'),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Temperatura',
                            ),
                            tablaCalibracion.cabeceraTabla(context, 'Presión'),
                            tablaCalibracion.cabeceraTabla(context, 'Meter'),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Frecuencia',
                            ),
                            tablaCalibracion.cabeceraTabla(context, 'K Factor'),
                            tablaCalibracion.cabeceraTabla(context, 'K Factor'),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Repetibilidad',
                            ),
                            tablaCalibracion.cabeceraTabla(context, 'Editar'),
                            tablaCalibracion.cabeceraTabla(context, 'Borrar'),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                          ),
                          children: [
                            tablaCalibracion.cabeceraTabla(context, 'm³/hr'),
                            tablaCalibracion.cabeceraTabla(context, 'bbl/hr'),
                            tablaCalibracion.cabeceraTabla(context, '°C'),
                            tablaCalibracion.cabeceraTabla(context, 'Kg/m2'),
                            tablaCalibracion.cabeceraTabla(context, 'Factor'),
                            tablaCalibracion.cabeceraTabla(context, 'Hz'),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Pulsos/m³',
                            ),
                            tablaCalibracion.cabeceraTabla(
                              context,
                              'Pulsos/bbl',
                            ),
                            tablaCalibracion.cabeceraTabla(context, '%'),
                            tablaCalibracion.cabeceraTabla(context, ''),
                            tablaCalibracion.cabeceraTabla(context, ''),
                          ],
                        ),
                        ...(_corridasRegistradas.isNotEmpty
                            ? _corridasRegistradas
                                  .map(
                                    (corrida) => TableRow(
                                      decoration: BoxDecoration(
                                        color:
                                            theme.colorScheme.tertiaryContainer,
                                      ),
                                      children: [
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.caudalM3Hr,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.caudalBblHr,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.temperaturaC,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.presionKgCm2,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.meterFactor,
                                            5,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.frecuenciaHz,
                                            2,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.kFactorPulseM3,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.kFactorPulseBbl,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            corrida.repetibilidad,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.editarFilaTabla(context, () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // This is an alert dialog that asks for confirmation to delete something.
                                              return AlertDialog(
                                                title: Text(
                                                  "¿Quieres editar esta corrida?",
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                        'Se cargaran los datos de la corrida en los campos de entrada para su edición',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(
                                                        false,
                                                      ); // Return false if cancelled
                                                    },
                                                    child: Text("Cancelar"),
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            theme
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                    ),
                                                    onPressed: () async {
                                                      // Call a function that deletes the data when confirmed.
                                                      setState(() {
                                                        int
                                                        index = _corridasRegistradas
                                                            .indexWhere(
                                                              (c) =>
                                                                  c.idCorrida ==
                                                                  corrida
                                                                      .idCorrida,
                                                            );
                                                        _corridaActual =
                                                            _corridasRegistradas[index];
                                                        _caudalM3Controller
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .caudalM3Hr,
                                                              2,
                                                            );
                                                        _caudalBblController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .caudalBblHr,
                                                              2,
                                                            );
                                                        _temperaturaCentigradosController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .temperaturaC,
                                                              2,
                                                            );
                                                        _temperaturaFahrenheitController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .temperaturaF,
                                                              2,
                                                            );
                                                        _presionController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .presionKgCm2,
                                                              2,
                                                            );
                                                        _presionPSIController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .presionPSI,
                                                              2,
                                                            );
                                                        _presionKPaController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .presionKPa,
                                                              2,
                                                            );
                                                        _meterFactorController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .meterFactor,
                                                              5,
                                                            );
                                                        _kFactorPulsosM3Controller
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .kFactorPulseM3,
                                                              3,
                                                            );
                                                        _kFactorPulsosBblController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .kFactorPulseBbl,
                                                              3,
                                                            );
                                                        _frecuenciaController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .frecuenciaHz,
                                                              2,
                                                            );
                                                        _repetibilidadController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _corridaActual
                                                                  .repetibilidad,
                                                              3,
                                                            );
                                                        editandoCorrida = true;
                                                        indiceCorridaEditando =
                                                            index;
                                                      });

                                                      Navigator.of(
                                                        context,
                                                      ).pop(true);
                                                    },
                                                    child: Text(
                                                      "Editar",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          _linealidadController.text =
                                              convertidor.calcularLinealidad(
                                                _corridasRegistradas,
                                              );
                                        }),
                                        tablaCalibracion.borraFilaTabla(context, () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // This is an alert dialog that asks for confirmation to delete something.
                                              return AlertDialog(
                                                title: Text(
                                                  "¿Quieres quitar esta corrida?",
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                        'Quitarás la corrida de la tabla y del cálculo',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            theme
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(
                                                        false,
                                                      ); // Return false if cancelled
                                                    },
                                                    child: Text("Cancelar"),
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            theme
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                    ),
                                                    onPressed: () async {
                                                      // Call a function that deletes the data when confirmed.
                                                      setState(() {
                                                        int
                                                        index = _corridasRegistradas
                                                            .indexWhere(
                                                              (c) =>
                                                                  c.idCorrida ==
                                                                  corrida
                                                                      .idCorrida,
                                                            );
                                                        _corridasRegistradas
                                                            .removeWhere(
                                                              (c) =>
                                                                  c.idCorrida ==
                                                                  corrida
                                                                      .idCorrida,
                                                            );
                                                        _listaCorridas.removeAt(
                                                          index,
                                                        );
                                                      });

                                                      Navigator.of(
                                                        context,
                                                      ).pop(true);
                                                    },
                                                    child: Text(
                                                      "Quitar",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                          _linealidadController.text =
                                              convertidor.calcularLinealidad(
                                                _corridasRegistradas,
                                              );
                                        }),
                                      ],
                                    ),
                                  )
                                  .toList()
                            : [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiaryContainer,
                                  ),
                                  children: List.generate(
                                    11,
                                    (index) => Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(''),
                                    ),
                                  ),
                                ),
                              ]),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: editandoCorrida
                    ? ElevatedButton(
                        onPressed: _agregarCorrida,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                        ),
                        child: const Text('Agregar edición'),
                      )
                    : ElevatedButton(
                        onPressed: _agregarCorrida,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                        ),
                        child: const Text('Agregar corrida'),
                      ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _limpiaCorrida,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('Limpiar corrida'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccionExtras(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _keySeccionExtras,
      child: Container(
        decoration: cajaFormulario.boxDecoration(context),
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        "Extras",
                        style: TextStyle(
                          fontSize: 20,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(width: 10),
                      _iconoAyudaSeccion(
                        context,
                        'La linealidad se calcula automáticamente al agregar o eliminar corridas, solo agrega observaciones si es necesario.',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Linealidad (%)",
                            validatorText: 'Favor de escribir la linealidad',
                            controllerText: _linealidadController,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Reproducibilidad (%)",
                            validatorText:
                                'Favor de escribir la reproducibilidad',
                            controllerText: _reproducibilidadController,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),
                    _buildTextFormField(
                      context,
                      hintText: "Observaciones",
                      validatorText: 'Favor de escribir las observaciones',
                      controllerText: _observacionesController,
                      decimales: 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccionTemperatura(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _keySeccionTemperatura,
      child: Container(
        decoration: cajaFormulario.boxDecoration(context),
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        "Temperatura",
                        style: TextStyle(
                          fontSize: 20,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(width: 10),
                      _iconoAyudaSeccion(
                        context,
                        'Llena los campos adicionales de temperatura si aplica.',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura Patrón (°C)",
                            validatorText: 'Favor de escribir el caudal',
                            controllerText: _patronCelsiusController,
                            focusNode: _focusNodeTemperatura,
                            onChanged: _onCelsiusPatronChanged,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura Patrón (°F)",
                            validatorText: 'Favor de escribir el caudal',
                            controllerText: _patronFahrenheitController,
                            onChanged: _onFahrenheitPatronChanged,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura IBC (°C)",
                            validatorText: 'Favor de escribir la temperatura',
                            controllerText: _ibcCelsiusController,
                            onChanged: _onCelsiusIBCChanged,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura IBC (°F)",
                            validatorText: 'Favor de escribir la temperatura',
                            controllerText: _ibcFahrenheitController,
                            onChanged: _onFahrenheitIBCChanged,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Error de medida (°C )",
                            validatorText: '',
                            controllerText: _errorCelsiusController,
                            decimales: 3,
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Error de medida (°F )",
                            validatorText: '',
                            controllerText: _errorFahrenheitController,
                            decimales: 3,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Incertidumbre (°C )",
                            validatorText: '',
                            controllerText: _incertidumbreCelsiusController,
                            onChanged: _onCelsiusIncertidumbreChanged,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Incertidumbre (°F )",
                            validatorText: '',
                            controllerText: _incertidumbreFahrenheitController,
                            onChanged: _onFahrenheitIncertidumbreChanged,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Table(
                      border: TableBorder.symmetric(
                        inside: const BorderSide(color: Colors.black, width: 1),
                        outside: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                          ),
                          children: [
                            tablaCalibracion.cabeceraTabla(context, 'Patrón'),
                            tablaCalibracion.cabeceraTabla(context, 'Patrón'),
                            tablaCalibracion.cabeceraTabla(context, 'IBC'),
                            tablaCalibracion.cabeceraTabla(context, 'IBC'),
                            tablaCalibracion.cabeceraTabla(context, 'Error'),
                            tablaCalibracion.cabeceraTabla(context, 'Error'),
                            tablaCalibracion.cabeceraTabla(context, 'Incer.'),
                            tablaCalibracion.cabeceraTabla(context, 'Incer.'),
                            tablaCalibracion.cabeceraTabla(context, 'Editar'),
                            tablaCalibracion.cabeceraTabla(context, 'Borrar'),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                          ),
                          children: [
                            tablaCalibracion.cabeceraTabla(context, '°C'),
                            tablaCalibracion.cabeceraTabla(context, '°F'),
                            tablaCalibracion.cabeceraTabla(context, '°C'),
                            tablaCalibracion.cabeceraTabla(context, '°F'),
                            tablaCalibracion.cabeceraTabla(context, '°C'),
                            tablaCalibracion.cabeceraTabla(context, '°F'),
                            tablaCalibracion.cabeceraTabla(context, '°C'),
                            tablaCalibracion.cabeceraTabla(context, '°F'),
                            tablaCalibracion.cabeceraTabla(context, ''),
                            tablaCalibracion.cabeceraTabla(context, ''),
                          ],
                        ),
                        ...(_lecturasRegistradasTemperatura.isNotEmpty
                            ? _lecturasRegistradasTemperatura
                                  .map(
                                    (lectura) => TableRow(
                                      decoration: BoxDecoration(
                                        color:
                                            theme.colorScheme.tertiaryContainer,
                                      ),
                                      children: [
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.patronCelsius,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.patronFahrenheit,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.ibcCelsius,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.ibcFahrenheit,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.errorCelsius,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.errorFahrenheit,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.incertidumbreCelsius,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.incertidumbreFahrenheit,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.editarFilaTabla(context, () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // This is an alert dialog that asks for confirmation to delete something.
                                              return AlertDialog(
                                                title: Text(
                                                  "¿Quieres editar esta lectura de temperatura?",
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                        'Se cargaran los datos de la lectura de temperatura en los campos de entrada para su edición',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(
                                                        false,
                                                      ); // Return false if cancelled
                                                    },
                                                    child: Text("Cancelar"),
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            theme
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                    ),
                                                    onPressed: () async {
                                                      // Call a function that deletes the data when confirmed.
                                                      setState(() {
                                                        int
                                                        index = _lecturasRegistradasTemperatura
                                                            .indexWhere(
                                                              (l) =>
                                                                  l.idLectura ==
                                                                  lectura
                                                                      .idLectura,
                                                            );
                                                        _lecturaActualTemperatura =
                                                            _lecturasRegistradasTemperatura[index];
                                                        _patronCelsiusController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualTemperatura
                                                                  .patronCelsius,
                                                              3,
                                                            );
                                                        _patronFahrenheitController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualTemperatura
                                                                  .patronFahrenheit,
                                                              3,
                                                            );
                                                        _errorCelsiusController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualTemperatura
                                                                  .errorCelsius,
                                                              3,
                                                            );
                                                        _errorFahrenheitController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualTemperatura
                                                                  .errorFahrenheit,
                                                              3,
                                                            );
                                                        _ibcCelsiusController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualTemperatura
                                                                  .ibcCelsius,
                                                              3,
                                                            );
                                                        _ibcFahrenheitController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualTemperatura
                                                                  .ibcFahrenheit,
                                                              3,
                                                            );
                                                        _incertidumbreCelsiusController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualTemperatura
                                                                  .incertidumbreCelsius,
                                                              3,
                                                            );
                                                        _incertidumbreFahrenheitController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualTemperatura
                                                                  .incertidumbreFahrenheit,
                                                              3,
                                                            );
                                                        editandoLecturaTemperatura =
                                                            true;
                                                        indiceCorridaEditandoTemperatura =
                                                            index;
                                                      });

                                                      Navigator.of(
                                                        context,
                                                      ).pop(true);
                                                    },
                                                    child: Text(
                                                      "Editar",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                        tablaCalibracion.borraFilaTabla(context, () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // This is an alert dialog that asks for confirmation to delete something.
                                              return AlertDialog(
                                                title: Text(
                                                  "¿Quieres quitar esta medición?",
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                        'Quitarás la medición de la tabla y del cálculo',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            theme
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(
                                                        false,
                                                      ); // Return false if cancelled
                                                    },
                                                    child: Text("Cancelar"),
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            theme
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                    ),
                                                    onPressed: () async {
                                                      // Call a function that deletes the data when confirmed.
                                                      setState(() {
                                                        int
                                                        index = _lecturasRegistradasTemperatura
                                                            .indexWhere(
                                                              (l) =>
                                                                  l.idLectura ==
                                                                  lectura
                                                                      .idLectura,
                                                            );
                                                        _lecturasRegistradasTemperatura
                                                            .removeWhere(
                                                              (l) =>
                                                                  l.idLectura ==
                                                                  lectura
                                                                      .idLectura,
                                                            );
                                                        _listaLecturasTemperatura
                                                            .removeAt(index);
                                                      });

                                                      Navigator.of(
                                                        context,
                                                      ).pop(true);
                                                    },
                                                    child: Text(
                                                      "Quitar",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                  )
                                  .toList()
                            : [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiaryContainer,
                                  ),
                                  children: List.generate(
                                    10,
                                    (index) => Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(''),
                                    ),
                                  ),
                                ),
                              ]),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: editandoLecturaTemperatura
                    ? ElevatedButton(
                        onPressed: _agregarLecturaTemperatura,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                        ),
                        child: const Text('Agregar edición'),
                      )
                    : ElevatedButton(
                        onPressed: _agregarLecturaTemperatura,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                        ),
                        child: const Text('Agregar lectura'),
                      ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _limpiaLecturaTemperatura,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: const Text('Limpiar lectura'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccionPresion(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _keySeccionPresion,
      child: Container(
        decoration: cajaFormulario.boxDecoration(context),
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        "Presión",
                        style: TextStyle(
                          fontSize: 20,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(width: 10),
                      _iconoAyudaSeccion(
                        context,
                        'Llena los campos adicionales de temperatura si aplica.',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura Patrón (kg/cm²)",
                            validatorText:
                                'Favor de escribir lectura de patrón',
                            controllerText: _patronKgCm2Controller,
                            focusNode: _focusNodePresion,
                            onChanged: _onKgCm2PatronChanged,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura Patrón (psi)",
                            validatorText:
                                'Favor de escribir lectura de patrón',
                            controllerText: _patronPSIController,
                            onChanged: _onPSIPatronChanged,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura Patrón (kPa)",
                            validatorText:
                                'Favor de escribir lectura de patrón',
                            controllerText: _patronKPAController,
                            onChanged: _onKPaPatronChanged,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura IBC (kg/cm²)",
                            validatorText: 'Favor de escribir lectura de IBC',
                            controllerText: _ibcKgCm2Controller,
                            onChanged: _onKgCm2IBCChanged,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura IBC (psi)",
                            validatorText: 'Favor de escribir lectura de IBC',
                            controllerText: _ibcPSIController,
                            onChanged: _onPSIIBCChanged,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Lectura IBC (kPa)",
                            validatorText: 'Favor de escribir lectura de IBC',
                            controllerText: _ibcKPAController,
                            onChanged: _onKPaIBCChanged,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Error de medida (kg/cm²)",
                            validatorText: '',
                            controllerText: _errorKgCm2Controller,
                            decimales: 3,
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Error de medida (psi)",
                            validatorText: '',
                            controllerText: _errorPSIController,
                            decimales: 3,
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Error de medida (kPa)",
                            validatorText: '',
                            controllerText: _errorKPAController,
                            decimales: 3,
                            readOnly: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Incertidumbre (kg/cm²)",
                            validatorText:
                                'Favor de escribir lectura de incertidumbre',
                            controllerText: _incertidumbreKgCm2Controller,
                            onChanged: _onKgCm2IncertidumbreChanged,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Incertidumbre (psi)",
                            validatorText:
                                'Favor de escribir lectura de incertidumbre',
                            controllerText: _incertidumbrePSIController,
                            onChanged: _onPSIIncertidumbreChanged,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Incertidumbre (kPa)",
                            validatorText:
                                'Favor de escribir lectura de incertidumbre',
                            controllerText: _incertidumbreKPAController,
                            onChanged: _onKPaIncertidumbreChanged,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Table(
                      border: TableBorder.symmetric(
                        inside: const BorderSide(color: Colors.black, width: 1),
                        outside: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                          ),
                          children: [
                            tablaCalibracion.cabeceraTabla(context, 'Patrón'),
                            tablaCalibracion.cabeceraTabla(context, 'Patrón'),
                            tablaCalibracion.cabeceraTabla(context, 'Patrón'),
                            tablaCalibracion.cabeceraTabla(context, 'IBC'),
                            tablaCalibracion.cabeceraTabla(context, 'IBC'),
                            tablaCalibracion.cabeceraTabla(context, 'IBC'),
                            tablaCalibracion.cabeceraTabla(context, 'Error'),
                            tablaCalibracion.cabeceraTabla(context, 'Error'),
                            tablaCalibracion.cabeceraTabla(context, 'Error'),
                            tablaCalibracion.cabeceraTabla(context, 'Incer.'),
                            tablaCalibracion.cabeceraTabla(context, 'Incer.'),
                            tablaCalibracion.cabeceraTabla(context, 'Incer.'),
                            tablaCalibracion.cabeceraTabla(context, 'Editar'),
                            tablaCalibracion.cabeceraTabla(context, 'Borrar'),
                          ],
                        ),
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                          ),
                          children: [
                            tablaCalibracion.cabeceraTabla(context, 'kg/cm²'),
                            tablaCalibracion.cabeceraTabla(context, 'psi'),
                            tablaCalibracion.cabeceraTabla(context, 'kPa'),
                            tablaCalibracion.cabeceraTabla(context, 'kg/cm²'),
                            tablaCalibracion.cabeceraTabla(context, 'psi'),
                            tablaCalibracion.cabeceraTabla(context, 'kPa'),
                            tablaCalibracion.cabeceraTabla(context, 'kg/cm²'),
                            tablaCalibracion.cabeceraTabla(context, 'psi'),
                            tablaCalibracion.cabeceraTabla(context, 'kPa'),
                            tablaCalibracion.cabeceraTabla(context, 'kg/cm²'),
                            tablaCalibracion.cabeceraTabla(context, 'psi'),
                            tablaCalibracion.cabeceraTabla(context, 'kPa'),
                            tablaCalibracion.cabeceraTabla(context, ''),
                            tablaCalibracion.cabeceraTabla(context, ''),
                          ],
                        ),
                        ...(_lecturasRegistradasPresion.isNotEmpty
                            ? _lecturasRegistradasPresion
                                  .map(
                                    (lectura) => TableRow(
                                      decoration: BoxDecoration(
                                        color:
                                            theme.colorScheme.tertiaryContainer,
                                      ),
                                      children: [
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.patronKgCm2,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.patronPSI,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.patronkPa,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.ibcKgCm2,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.ibcPSI,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.ibckPa,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.errorKgCm2,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.errorPSI,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.errorkPa,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.incertidumbreKgCm2,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.incertidumbrePSI,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.celdaTabla(
                                          context,
                                          convertidor.formatoMiles(
                                            lectura.incertidumbrekPa,
                                            3,
                                          ),
                                        ),
                                        tablaCalibracion.editarFilaTabla(context, () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // This is an alert dialog that asks for confirmation to delete something.
                                              return AlertDialog(
                                                title: Text(
                                                  "¿Quieres editar esta lectura de presión?",
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                        'Se cargaran los datos de la lectura de presión en los campos de entrada para su edición',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(
                                                        false,
                                                      ); // Return false if cancelled
                                                    },
                                                    child: Text("Cancelar"),
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            theme
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                    ),
                                                    onPressed: () async {
                                                      // Call a function that deletes the data when confirmed.
                                                      setState(() {
                                                        int
                                                        index = _lecturasRegistradasPresion
                                                            .indexWhere(
                                                              (l) =>
                                                                  l.idLectura ==
                                                                  lectura
                                                                      .idLectura,
                                                            );
                                                        _lecturaActualPresion =
                                                            _lecturasRegistradasPresion[index];
                                                        _patronKgCm2Controller
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .patronKgCm2,
                                                              3,
                                                            );
                                                        _patronPSIController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .patronPSI,
                                                              3,
                                                            );
                                                        _patronKPAController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .patronkPa,
                                                              3,
                                                            );
                                                        _ibcKgCm2Controller
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .ibcKgCm2,
                                                              3,
                                                            );
                                                        _ibcPSIController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .ibcPSI,
                                                              3,
                                                            );
                                                        _ibcKPAController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .ibckPa,
                                                              3,
                                                            );
                                                        _errorKgCm2Controller
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .errorKgCm2,
                                                              3,
                                                            );
                                                        _errorPSIController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .errorPSI,
                                                              3,
                                                            );
                                                        _errorKPAController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .errorkPa,
                                                              3,
                                                            );
                                                        _incertidumbreKgCm2Controller
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .incertidumbreKgCm2,
                                                              3,
                                                            );
                                                        _incertidumbrePSIController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .incertidumbrePSI,
                                                              3,
                                                            );
                                                        _incertidumbreKPAController
                                                            .text = convertidor
                                                            .formatoMiles(
                                                              _lecturaActualPresion
                                                                  .incertidumbrekPa,
                                                              3,
                                                            );
                                                        editandoLecturaPresion =
                                                            true;
                                                        indiceCorridaEditandoPresion =
                                                            index;
                                                      });

                                                      Navigator.of(
                                                        context,
                                                      ).pop(true);
                                                    },
                                                    child: Text(
                                                      "Editar",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                        tablaCalibracion.borraFilaTabla(context, () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // This is an alert dialog that asks for confirmation to delete something.
                                              return AlertDialog(
                                                title: Text(
                                                  "¿Quieres quitar esta medición?",
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(
                                                    children: <Widget>[
                                                      Text(
                                                        'Quitarás la medición de la tabla y del cálculo',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            theme
                                                                .colorScheme
                                                                .primary,
                                                          ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context).pop(
                                                        false,
                                                      ); // Return false if cancelled
                                                    },
                                                    child: Text("Cancelar"),
                                                  ),
                                                  ElevatedButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStateProperty.all(
                                                            theme
                                                                .colorScheme
                                                                .secondary,
                                                          ),
                                                    ),
                                                    onPressed: () async {
                                                      // Call a function that deletes the data when confirmed.
                                                      setState(() {
                                                        int
                                                        index = _lecturasRegistradasPresion
                                                            .indexWhere(
                                                              (l) =>
                                                                  l.idLectura ==
                                                                  lectura
                                                                      .idLectura,
                                                            );
                                                        _lecturasRegistradasPresion
                                                            .removeWhere(
                                                              (l) =>
                                                                  l.idLectura ==
                                                                  lectura
                                                                      .idLectura,
                                                            );
                                                        _listaLecturasPresion
                                                            .removeAt(index);
                                                      });

                                                      Navigator.of(
                                                        context,
                                                      ).pop(true);
                                                    },
                                                    child: Text(
                                                      "Quitar",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }),
                                      ],
                                    ),
                                  )
                                  .toList()
                            : [
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiaryContainer,
                                  ),
                                  children: List.generate(
                                    14,
                                    (index) => Padding(
                                      padding: EdgeInsets.all(2.0),
                                      child: Text(''),
                                    ),
                                  ),
                                ),
                              ]),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: editandoLecturaPresion
                    ? ElevatedButton(
                        onPressed: _agregarLecturaPresion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                        ),
                        child: const Text('Agregar edición'),
                      )
                    : ElevatedButton(
                        onPressed: _agregarLecturaPresion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onSecondary,
                        ),
                        child: const Text('Agregar lectura'),
                      ),
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _limpiaLecturaPresion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  child: const Text('Limpiar lectura'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _seccionDensimetro(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _keySeccionDensimetro,
      child: Container(
        decoration: cajaFormulario.boxDecoration(context),
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        "Densímetro",
                        style: TextStyle(
                          fontSize: 20,
                          color: theme.colorScheme.tertiary,
                        ),
                      ),
                      SizedBox(width: 10),
                      _iconoAyudaSeccion(
                        context,
                        'Llena los campos adicionales del densímetro si aplica.',
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Antes corrección",
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Patrón Operación (kg/m³)",
                            validatorText:
                                'Favor de escribir la condición de referencia',
                            controllerText: _patronOperacionController,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Patrón Referencia (kg/m³)",
                            validatorText:
                                'Favor de escribir la condición de referencia',
                            controllerText: _patronReferenciaController,
                            decimales: 3,
                            onChanged: calcularErrorDensidad,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "IBC Operación (kg/m³)",
                            validatorText:
                                'Favor de escribir la lectura IBC en operación',
                            controllerText: _ibcOperacionController,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "IBC Referencia (kg/m³)",
                            validatorText:
                                'Favor de escribir la lectura IBC en referencia',
                            controllerText: _ibcReferenciaController,
                            decimales: 3,
                            onChanged: calcularErrorDensidad,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Error medida referencia (kg/m³)",
                            validatorText:
                                'Favor de escribir la lectura IBC en operación',
                            controllerText: _errorReferenciaController,
                            decimales: 3,
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Incertidumbre (kg/m³)",
                            validatorText: 'Favor de escribir la incertidumbre',
                            controllerText: _incertidumbreReferenciaController,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    const Divider(),
                    const SizedBox(width: 12),
                    Text(
                      "Después corrección",
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Patrón Operación (kg/m³)",
                            validatorText:
                                'Favor de escribir la condición de referencia',
                            controllerText: _patronCorregidoOperacionController,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Patrón Referencia (kg/m³)",
                            validatorText:
                                'Favor de escribir la condición de referencia',
                            controllerText:
                                _patronCorregidoReferenciaController,
                            decimales: 3,
                            onChanged: calcularErrorDensidadCorregido,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "IBC Operación (kg/m³)",
                            validatorText:
                                'Favor de escribir la lectura IBC en operación',
                            controllerText: _ibcCorregidoOperacionController,
                            decimales: 3,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "IBC Referencia (kg/m³)",
                            validatorText:
                                'Favor de escribir la lectura IBC en referencia',
                            controllerText: _ibcCorregidoReferenciaController,
                            decimales: 3,
                            onChanged: calcularErrorDensidadCorregido,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Error medida referencia (kg/m³)",
                            validatorText: '',
                            controllerText: _errorCorregidoReferenciaController,
                            decimales: 3,
                            readOnly: true,
                          ),
                        ),
                        const SizedBox(width: 12), // separación entre campos
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Incertidumbre (kg/m³)",
                            validatorText: 'Favor de escribir la incertidumbre',
                            controllerText:
                                _incertidumbreCorregidoReferenciaController,
                            decimales: 3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    const Divider(),
                    const SizedBox(width: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextFormField(
                            context,
                            hintText: "Factor de corrección",
                            validatorText: '',
                            controllerText: _factorCorreccionController,
                            decimales: 5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeccionPorTipoSensor(BuildContext context) {
    if (equipoSeleccionado == null) {
      return const SizedBox.shrink();
    }

    // Se chequea el tipo de sensor:
    if (equipoSeleccionado!.idTipoSensor == '1') {
      return _seccionCorridas(context);
    } else if (equipoSeleccionado!.idTipoSensor == '2') {
      return _seccionTemperatura(context);
    } else if (equipoSeleccionado!.idTipoSensor == '3') {
      return _seccionPresion(context);
    } else if (equipoSeleccionado!.idTipoSensor == '4') {
      return _seccionDensimetro(context);
    } else {
      // Si no coincide con ninguno
      return const SizedBox.shrink();
    }
  }

  Widget _buildSeccionExtras(BuildContext context) {
    if (equipoSeleccionado == null) {
      return const SizedBox.shrink();
    }

    // Se chequea el tipo de sensor:
    if (equipoSeleccionado!.idTipoSensor == '1') {
      return _seccionExtras(context);
    } else {
      // Si no coincide con ninguno
      return const SizedBox.shrink();
    }
  }
}
