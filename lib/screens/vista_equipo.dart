import 'package:flutter/material.dart';

class EquipoDataSource extends DataTableSource {
  final List<EquipoAux> equipos;
  final BuildContext context;

  EquipoDataSource(this.equipos, this.context);

  @override
  DataRow? getRow(int index) {
    if (index >= equipos.length) return null;
    final equipo = equipos[index];
    return DataRow(
      cells: [
        DataCell(Text(equipo.tag)),
        DataCell(Text(equipo.tipoMedicion)),
        DataCell(Text(equipo.estado)),
        DataCell(Text(equipo.marca)),
        DataCell(Text(equipo.modelo)),
        DataCell(Text(equipo.noSerie)),
        DataCell(Text(equipo.intCalibracion)),
        DataCell(Text(equipo.intVerificacion)),
        DataCell(Text(equipo.incertidumbre)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.tertiaryContainer,
                  content: Text('Acción para ${equipo.tag}'),
                ),
              );
            },
            child: const Text('mod'),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;
  @override
  int get rowCount => equipos.length;
  @override
  int get selectedRowCount => 0;
}

class EquipoAux {
  final String tag;
  final String tipoMedicion;
  final String estado;
  final String marca;
  final String modelo;
  final String noSerie;
  final String intCalibracion;
  final String intVerificacion;
  final String incertidumbre;

  EquipoAux(
    this.tag,
    this.tipoMedicion,
    this.estado,
    this.marca,
    this.modelo,
    this.noSerie,
    this.intCalibracion,
    this.intVerificacion,
    this.incertidumbre,
  );
}

class VistaEquipo extends StatefulWidget {
  const VistaEquipo({super.key});

  @override
  State<VistaEquipo> createState() => _VistaEquipoState();
}

class _VistaEquipoState extends State<VistaEquipo> {
  late EquipoDataSource _dataSource;

  List<EquipoAux> equipos = [
    EquipoAux(
      'TIT-160-1',
      'DINÁMICO',
      'OPERANDO',
      'FOXBORO',
      'RTT20-T1LCQFD-D2',
      '310606',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-160-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5B4M5Q4',
      '763668',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-1',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741565',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741564',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-142-1',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '740590',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-142-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '740591',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-160-1',
      'DINÁMICO',
      'OPERANDO',
      'FOXBORO',
      'RTT20-T1LCQFD-D2',
      '310606',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-160-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5B4M5Q4',
      '763668',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-1',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741565',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741564',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-142-1',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '740590',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-142-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '740591',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-160-1',
      'DINÁMICO',
      'OPERANDO',
      'FOXBORO',
      'RTT20-T1LCQFD-D2',
      '310606',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-160-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5B4M5Q4',
      '763668',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-1',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741565',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741564',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-142-1',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '740590',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-142-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '740591',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-160-1',
      'DINÁMICO',
      'OPERANDO',
      'FOXBORO',
      'RTT20-T1LCQFD-D2',
      '310606',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-160-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5B4M5Q4',
      '763668',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-1',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741565',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741564',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-142-1',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '740590',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-142-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '740591',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-160-1',
      'DINÁMICO',
      'OPERANDO',
      'FOXBORO',
      'RTT20-T1LCQFD-D2',
      '310606',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-160-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5B4M5Q4',
      '763668',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-1',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741565',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
    EquipoAux(
      'TIT-141-2',
      'DINÁMICO',
      'OPERANDO',
      'ROSEMOUNT',
      '3144PD1A1E5M5G1C2Q4XA',
      '741564',
      '01/01/2023',
      '01/06/2023',
      '0.01%',
    ),
  ];

  int? sortColumnIndex;
  bool sortAscending = true;

  void ordenarPorTag(int columnIndex, bool ascending) {
    equipos.sort(
      (a, b) => ascending ? a.tag.compareTo(b.tag) : b.tag.compareTo(a.tag),
    );
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  void ordenarPorTipo(int columnIndex, bool ascending) {
    equipos.sort(
      (a, b) => ascending
          ? a.tipoMedicion.compareTo(b.tipoMedicion)
          : b.tipoMedicion.compareTo(a.tipoMedicion),
    );
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  @override
  void initState() {
    super.initState();
    _dataSource = EquipoDataSource(equipos, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        //scrollDirection: Axis.horizontal,
        child: PaginatedDataTable(
          header: const Text('Lista de Equipos'),
          rowsPerPage: 8,
          columns: [
            DataColumn(label: const Text('TAG')),
            DataColumn(label: const Text('Tipo de medición')),
            DataColumn(label: const Text('Estado')),
            DataColumn(label: const Text('Marca')),
            DataColumn(label: const Text('Modelo')),
            DataColumn(label: const Text('No de serie')),
            DataColumn(label: const Text('Int. Calibración')),
            DataColumn(label: const Text('Int. Verificación')),
            DataColumn(label: const Text('Incertidumbre')),
            DataColumn(label: const Text('Acción')),
          ],
          source: _dataSource,
        ),
      ),
    );
  }
}
