import 'package:calibraciones/models/_corrida.dart';
import 'package:flutter/material.dart';

class TablaCalibracion extends StatelessWidget {

  //TablaCalibracion({super.key});
  
  //Recibe parametros para llenar la tabla
  final Corrida corrida;

  const TablaCalibracion({
    super.key,
    required this.corrida
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.symmetric(
        inside: const BorderSide(color: Colors.black, width: 1),
        outside: const BorderSide(color: Colors.black, width: 2),
      ),
      children: [
        // Fila 1: Títulos
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[300]),
          children: const [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'No. Corrida',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Caudal (m3/hr)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Caudal (bbl/hr)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Temp. (°C)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        // Fila 2-6 con celda combinada en la primera columna
        TableRow(
          children: [
            // Celda combinada verticalmente (simulada)
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.fill,
              child: Container(
                color: Colors.amber[100],
                alignment: Alignment.center,
                height: 200, // Altura que cubre las siguientes 5 filas
                child: Text(corrida.idCorrida.toString(), textAlign: TextAlign.center),
              ),
            ),
            Padding(padding: EdgeInsets.all(8.0), child: Text(corrida.caudalM3Hr.toString())),
            Padding(padding: EdgeInsets.all(8.0), child: Text(corrida.caudalBblHr.toString())),
            Padding(padding: EdgeInsets.all(8.0), child: Text(corrida.temperaturaC.toString())),
          ],
        ),
        TableRow(
          children: const [
            SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Presión (kg/cm2)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Meter Factor',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Frecuencia (Hz)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        TableRow(
          children:  [
            SizedBox.shrink(),
            Padding(padding: EdgeInsets.all(8.0), child: Text("${corrida.presionKgCm2} (${corrida.presionPSI})")),
            Padding(padding: EdgeInsets.all(8.0), child: Text(corrida.meterFactor.toString())),
            Padding(padding: EdgeInsets.all(8.0), child: Text(corrida.frecuenciaHz.toString())),
          ],
        ),
        TableRow(
          children: const [
            SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'K Factor (Pulsos/m3)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'K Factor (Pulsos/bbl)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Repetiblidad  (%)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        TableRow(
          children: [
            SizedBox.shrink(),
            Padding(padding: EdgeInsets.all(8.0), child: Text(corrida.kFactorPulseM3.toString())),
            Padding(padding: EdgeInsets.all(8.0), child: Text(corrida.kFactoPulseBbl.toString())),
            Padding(padding: EdgeInsets.all(8.0), child: Text(corrida.repetibilidad.toString())),
          ],
        ),
      ],
    );
  }
}
