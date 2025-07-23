import 'package:flutter/material.dart';

class TablaCalibracion extends StatelessWidget {
  const TablaCalibracion({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.symmetric(
        inside: const BorderSide(color: Colors.black, width: 1),
        outside: const BorderSide(color: Colors.black, width: 2),
      ),
      /*columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(2),
            3: FlexColumnWidth(2),
          },*/
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
                child: Text('1', textAlign: TextAlign.center),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8.0), child: Text('')),
            const Padding(padding: EdgeInsets.all(8.0), child: Text('')),
            const Padding(padding: EdgeInsets.all(8.0), child: Text('')),
          ],
        ),
        TableRow(
          children: const [
            SizedBox.shrink(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Presión (kg/cm3)',
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
          children: const [
            SizedBox.shrink(),
            Padding(padding: EdgeInsets.all(8.0), child: Text('')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('')),
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
          children: const [
            SizedBox.shrink(),
            Padding(padding: EdgeInsets.all(8.0), child: Text('')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('')),
            Padding(padding: EdgeInsets.all(8.0), child: Text('')),
          ],
        ),
      ],
    );
  }
}
