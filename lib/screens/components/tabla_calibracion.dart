import 'package:flutter/material.dart';

class TablaCalibracion extends StatelessWidget {
  const TablaCalibracion({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  TableCell cabeceraTabla(BuildContext context, String texto) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return TableCell(
      child: Container(
        decoration: BoxDecoration(
          color: colors.tertiary,
          border: Border.all(color: colors.tertiary, width: 0.5),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4.0),
        child: Text(
          texto,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleSmall?.copyWith(color: colors.onTertiary),
        ),
      ),
    );
  }

  TableCell celdaTabla(BuildContext context, String texto) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        decoration: BoxDecoration(
          color: colors.tertiaryContainer,
          border: Border.all(color: colors.tertiaryContainer, width: 0.5),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(4.0),
        child: Text(
          texto,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: colors.onTertiaryContainer,
          ),
        ),
      ),
    );
  }

  TableCell editarFilaTabla(BuildContext context, Function() onPressed) {
    final colors = Theme.of(context).colorScheme;
    return TableCell(
      child: Container(
        decoration: BoxDecoration(
          color: colors.tertiaryContainer,
          border: Border.all(color: colors.tertiaryContainer, width: 0.5),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(4.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: IconButton(
            icon: Icon(Icons.edit, color: colors.onTertiaryContainer),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  TableCell borraFilaTabla(BuildContext context, Function() onPressed) {
    final colors = Theme.of(context).colorScheme;
    return TableCell(
      child: Container(
        decoration: BoxDecoration(
          color: colors.tertiaryContainer,
          border: Border.all(color: colors.tertiaryContainer, width: 0.5),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(4.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: IconButton(
            icon: Icon(Icons.delete, color: colors.onTertiaryContainer),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
