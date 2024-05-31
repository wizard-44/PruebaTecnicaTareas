import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:prueba_tecnica/config/theme/app_theme.dart';
import 'package:prueba_tecnica/controllers/tarea_controller.dart';
import 'package:prueba_tecnica/presentation/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeApp();
  runApp(const MyApp());
}

/// Initializes the application's required services before launching.
Future<void> initializeApp() async {
  await Firebase.initializeApp();
  await initializeDateFormatting('es_EC', null);
}

/// Root widget of the application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TareaController()),
      ],
      child: MaterialApp(
        title: 'Tareas',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: const DashboardScreen(),
      ),
    );
  }
}

/// Defines the default theme for the app.
final ThemeData appTheme = AppTheme().getTheme();
