//import 'package:firebase_auth/firebase_auth.dart';
import 'package:calibraciones/screens/vista_contrasenia.dart';
import 'package:calibraciones/screens/vista_detalle_calibracion.dart';
import 'package:calibraciones/screens/vista_inicio.dart';
import 'package:calibraciones/screens/vista_registro.dart';
import 'package:flutter/material.dart';
import 'screens/vista_login.dart';
//import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  runApp(PemexCalibraciones());
}

class PemexCalibraciones extends StatefulWidget {
  const PemexCalibraciones({super.key});

  @override
  State<StatefulWidget> createState() => _MainState();
}

class _MainState extends State<PemexCalibraciones> {
  //final User? usuarioActual = FirebaseAuth.instance.currentUser;
  late String? token = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calibraciones',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: Color(0xFF9B2247), // "#58111A"
          onPrimary: Color(0xFFE3E1E1), // "#E3E1E1"
          primaryContainer: Color(0xFFDE688C), // "#CC3448"
          onPrimaryContainer: Color(0xFF161A1D), // "#131010"

          secondary: Color(0xFF1E5B4F), // "#11584F"
          onSecondary: Color(0xFFE3E1E1), // "#E3E1E1"
          secondaryContainer: Color(0xFF57C7B0), // "#29A797"
          onSecondaryContainer: Color(0xFF161A1D), // "#131010"

          tertiary: Color(0xFFA57F2C), // "#2B1158"
          onTertiary: Color(0xFF161A1D), // "#E3E1E1"
          tertiaryContainer: Color(0xFFE6D194), // "#9472E7"
          onTertiaryContainer: Color(0xFF000F08), // "#CCC5B9"
          surface: Color(0xFF1E5B4F), // Default surface color
          outline: Color(0xFF161A1D),
          onSurface: Color(0xFF161A1D), // Default on surface color
          error: Colors.red, // Default error color
          onError: Colors.white, // Default on error color
          brightness: Brightness.light, // Can be Brightness.dark for dark theme
        ),
        useMaterial3: true,
        fontFamily: 'Roboto', // Font family
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 57, // Tamaño sugerido por las nuevas guías de Material 3
            fontWeight: FontWeight.bold,
            letterSpacing: -0.25,
          ),
          displayMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 45,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
          displaySmall: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.0,
          ),
          headlineMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.0,
          ),
          headlineSmall: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.0,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.0,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.15,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.25,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
          labelSmall: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
      home: VistaLogin(),
      routes: {
        '/login': (context) => VistaLogin(),
        '/registro': (context) => VistaRegistro(),
        '/inicio': (context) => VistaInicio(),
        '/contrasenia': (context) => VistaContrasenia(),
        '/detalle_calibracion': (context) => VistaDetalleCalibracion(),
      },
    );
  }
}
