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
import 'screens/vista_registro_calibracion.dart';
import 'screens/vista_reporte_calibracion.dart';

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
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFDE688C),
      onPrimaryContainer: Colors.black,
      secondary: const Color(0xFF1E5B4F),
      onSecondary: Colors.white,
      secondaryContainer: const Color(0xFF57C7B0),
      onSecondaryContainer: Colors.black,
      tertiary: const Color(0xFFA57F2C),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFE6D194),
      onTertiaryContainer: Colors.black,
      surface: isDark ? const Color(0xFF121212) : Colors.white,
      onSurface: isDark ? Colors.white : const Color(0xFF161A1D),
      outline: isDark ? Colors.white54 : const Color(0xFF5F5F5F),
      error: Colors.red,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: baseColorScheme,
      scaffoldBackgroundColor: baseColorScheme.surface,
      fontFamily: 'Montserrat', // 🎨 Fuente más moderna y elegante
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: baseColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: baseColorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: baseColorScheme.onSurface),
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
