import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aplicacionbancaria/Vista/Vista_Login.dart';
import 'package:window_size/window_size.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final String title = 'Cooperativa Bancaria';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Supabase
  await Supabase.initialize(
    url: 'https://jwykvwaepozxztlrohvx.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imp3eWt2d2FlcG96eHp0bHJvaHZ4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzI5NDY0ODAsImV4cCI6MjA0ODUyMjQ4MH0.YQKyKg7NIJ14oKSgUuIonDq_rqTc__7tGem50-CLqZM',
  );

  // Configurar ventana si está en escritorio
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(title);
    setWindowMinSize(const Size(1300, 900));
    setWindowMaxSize(Size.infinite);
    _centerWindow();
  }

  runApp(MyApp());
}

// Centrar ventana en escritorio
Future<void> _centerWindow() async {
  final screen = await getCurrentScreen();
  if (screen != null) {
    final screenFrame = screen.frame;
    final width = 1300.0;
    final height = 900.0;
    final left = (screenFrame.width - width) / 2;
    final top = (screenFrame.height - height) / 2;
    setWindowFrame(Rect.fromLTWH(left, top, width, height));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      home: VistaLogin(), // Pantalla de inicio de sesión
    );
  }
}
