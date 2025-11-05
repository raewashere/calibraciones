import 'package:flutter/material.dart';

class Mensajes extends StatelessWidget {
  const Mensajes({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  // 🔹 SnackBar de ayuda o guía (informativo con ícono de ayuda)
  SnackBar ayuda(BuildContext context, String mensaje) {
    final theme = Theme.of(context);
    return SnackBar(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.95),
      duration: const Duration(seconds: 5),
      content: Row(
        children: [
          Icon(Icons.help_outline, color: theme.colorScheme.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(
                color: theme.colorScheme.onTertiaryContainer,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 SnackBar informativo (neutro, por ejemplo, para mostrar procesos)
  SnackBar info(BuildContext context, String mensaje) {
    final theme = Theme.of(context);
    return SnackBar(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: theme.colorScheme.secondaryContainer.withValues(alpha: 0.95),
      duration: const Duration(seconds: 5),
      content: Row(
        children: [
          Icon(Icons.info_outline, color: theme.colorScheme.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(
                color: theme.colorScheme.onSecondaryContainer,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 SnackBar de error (rojo o color primario oscuro)
  SnackBar error(BuildContext context, String mensaje) {
    final theme = Theme.of(context);
    return SnackBar(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      behavior: SnackBarBehavior.floating,
      backgroundColor: theme.colorScheme.errorContainer.withValues(alpha: 0.95),
      duration: const Duration(seconds: 5),
      content: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              mensaje,
              style: TextStyle(
                color: theme.colorScheme.onErrorContainer,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
