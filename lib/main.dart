import 'dart:io';
import 'package:flutter/material.dart';
import 'package:aplicacionbancaria/Vista/Vista_Login.dart';
import 'package:window_size/window_size.dart';

final title = 'Cooperrativa Bancaria';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle(title);
    setWindowMinSize(const Size(1300, 900));
    setWindowMaxSize(Size.infinite);
    _centerWindow();
  }
  runApp(MyApp());
}

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
      debugShowCheckedModeBanner:
          false, // Opcional, para quitar el banner de debug
      title: title,
      home: VistaLogin(), // Iniciando directamente con la pantalla de login
    );
  }
}
