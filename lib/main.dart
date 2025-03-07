
import 'package:aplicacionbancaria/Vista/Vista_Consultas2.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:aplicacionbancaria/Vista/Vista_Login.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Opcional, para quitar el banner de debug
      title: 'Aplicacion Bancaria',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VistaLogin(), // Iniciando directamente con la pantalla de login
    );
  }
}

