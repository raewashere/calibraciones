import 'package:flutter/material.dart';

class VistaBienvenida extends StatelessWidget {
  final void Function(int)? onSeleccion;

  const VistaBienvenida({super.key, this.onSeleccion});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.onPrimary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Encabezado visual
              Icon(
                Icons.engineering,
                size: 80,
                color: colors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                "Bienvenido",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Gestiona y consulta calibraciones de equipos de medición",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.secondary,
                ),
              ),
              const SizedBox(height: 32),

              // Tarjetas de opciones
              _buildOptionCard(
                context,
                icon: Icons.tune,
                title: "Registro de calibraciones",
                subtitle: "Registra calibraciones de los equipos de medición",
                onTap: () => onSeleccion?.call(1),
              ),
              _buildOptionCard(
                context,
                icon: Icons.table_view,
                title: "Reporte de calibraciones",
                subtitle: "Accede a información de calibraciones previas",
                onTap: () => onSeleccion?.call(2),
              ),
              _buildOptionCard(
                context,
                icon: Icons.stacked_bar_chart,
                title: "Equipo de medición",
                subtitle: "Modifica información sobre los equipos",
                onTap: () => onSeleccion?.call(3),
              ),
              _buildOptionCard(
                context,
                icon: Icons.account_circle,
                title: "Cuenta",
                subtitle: "Actualiza contraseña y otros datos",
                onTap: () => onSeleccion?.call(4),
              ),

              const SizedBox(height: 20),
              Text(
                "PEMEX | Sistema de Calibración",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colors.secondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.onPrimaryContainer, size: 26),
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            subtitle: Text(subtitle, style: TextStyle(color: colors.secondary)),
            trailing: Icon(
              Icons.arrow_forward_ios_rounded,
              color: colors.secondary,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }
}
