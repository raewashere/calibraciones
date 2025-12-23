import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Pantallas
import 'screens/vista_login.dart';
import 'screens/vista_inicio.dart';
import 'screens/vista_registro.dart';
import 'screens/vista_cuenta.dart';
import 'screens/vista_contrasenia.dart';
import 'screens/vista_recuperacion_contrasenia.dart';
import 'screens/vista_modificacion_datos.dart';
import 'screens/vista_equipo.dart';
import 'screens/vista_detalle_calibracion.dart';
import 'screens/vista_detalle_equipo.dart';
import 'screens/vista_registro_calibracion.dart';
import 'screens/vista_reporte_calibracion.dart';
import 'package:calibraciones/services/data_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zkviewvpmswfgpiwpoez.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inprdmlld3ZwbXN3ZmdwaXdwb2V6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0NTgxMzQsImV4cCI6MjA3MDAzNDEzNH0.E5i81N4_usUAqcLySjGZUk7rGOFHOLBBk8p1nzYjHbw',
  );
  runApp(const PemexCalibraciones());
}

class PemexCalibraciones extends StatefulWidget {
  const PemexCalibraciones({super.key});

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<PemexCalibraciones> {
  final User? usuarioActual = Supabase.instance.client.auth.currentUser;

  @override
  void initState() {
    super.initState();
    recuperaJSON();
  }

  void recuperaJSON() async {
    // Aquí puedes implementar la lógica para recuperar el JSON si es necesario
    DataService().updateAndCacheData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calibraciones PEMEX',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'ES'), Locale('en', 'US')],
      initialRoute: '/login',
      routes: {
        '/login': (context) => const VistaLogin(),
        '/registro': (context) => const VistaRegistro(),
        '/inicio': (context) => const VistaInicio(),
        '/contrasenia': (context) => const VistaContrasenia(),
        '/detalle_calibracion': (context) => const VistaDetalleCalibracion(),
        '/detalle_equipo': (context) => const VistaDetalleEquipo(),
        '/registro_calibracion': (context) => const VistaRegistroCalibracion(),
        '/reporte_calibraciones': (context) => const VistaReporteCalibracion(),
        '/equipos': (context) => const VistaEquipo(),
        '/cuenta': (context) => const VistaCuenta(),
        '/recuperacion_contrasenia': (context) =>
            const VistaRecuperacionContrasenia(),
        '/modificacion_datos': (context) => const VistaModificacionDatos(),
      },
    );
  }

  /// 🔧 Tema unificado con soporte claro/oscuro y mejor tipografía
  ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    final baseColorScheme = ColorScheme(
      brightness: brightness,
      primary: const Color(0xFF9B2247),
      onPrimary: const Color(0xFFE6E6E6),
      primaryContainer: const Color(0xFFEE85B5),
      onPrimaryContainer: const Color(0xFF121212),
      secondary: const Color(0x000000ff),
      onSecondary: const Color(0xFFE6E6E6),
      secondaryContainer: const Color(0xFFA4D4B4),
      onSecondaryContainer: const Color(0xFF121212),
      tertiary: const Color(0xFFA57F2C),
      onTertiary: const Color(0xFF121212),
      tertiaryContainer: const Color(0xFFEFECCA),
      onTertiaryContainer: const Color(0xFF121212),
      surface: const Color(0xFFE6E6E6),
      onSurface: isDark ? const Color(0xFF121212) : const Color(0xFF121212),
      outline: isDark ? const Color(0xFFE6E6E6) : const Color(0xFF121212),
      error: Colors.red,
      onError: const Color(0xFFE6E6E6),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: baseColorScheme,
      scaffoldBackgroundColor: baseColorScheme.surface,
      fontFamily: 'Montserrat',
      textTheme: _buildTextTheme(baseColorScheme.onSurface),
      appBarTheme: AppBarTheme(
        backgroundColor: baseColorScheme.primary,
        foregroundColor: baseColorScheme.onPrimary,
        centerTitle: true,
        elevation: 2,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
      ),
      cardTheme: CardThemeData(
        color: baseColorScheme.surface,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      // *** CONFIGURACIÓN GLOBAL DE INPUTS DE TEXTO (EXISTENTE) ***
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFFE6E6E6) : const Color(0xFFE6E6E6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: baseColorScheme.secondary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: baseColorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: baseColorScheme.primary),
      ),
      // *** NUEVA CONFIGURACIÓN GLOBAL DE ICONOS ***
      iconTheme: IconThemeData(color: baseColorScheme.primary, size: 24),
      // *** NUEVA CONFIGURACIÓN GLOBAL DEL MENÚ DESPLEGABLE ***
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: _buildTextTheme(baseColorScheme.onSurface).bodyLarge,
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(baseColorScheme.surface),
          elevation: WidgetStateProperty.all(4),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: baseColorScheme.primary,
          foregroundColor: baseColorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      // Dentro de tu ThemeData...
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor:
              baseColorScheme.primary, // El color del texto es Primary
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ), // Mismo estilo de texto que ElevatedButton
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Mismo radio de borde
          ),
        ),
      ),
    );
  }

  /// 🧩 Tipografía refinada
  TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.bold,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    );
  }
}
