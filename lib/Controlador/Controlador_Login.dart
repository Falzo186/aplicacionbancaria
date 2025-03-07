
import 'package:aplicacionbancaria/Vista/Vista_Escritorio.dart';
import 'package:flutter/material.dart';

import '../Modelo/Usuario.dart';
import '../Vista/Vista_Administrador.dart';

class ControladorLogin {

  void login(String username, String password, BuildContext context) {
    Usuario? usuario = usuarios.firstWhere(
      (usuario) => usuario.nombreUsuario == username && usuario.contrasena == password,
    ); 
    if (usuario != null) {
      if (usuario.puestoTrabajo == 'Administrador') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdministradorView(usuario: usuario),
          ),
        );
      } else if (usuario.puestoTrabajo == 'Cajero') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EscritorioView(usuario: usuario),
          ),
        );
      } else {
        // Manejar otros tipos de usuarios si es necesario
      }
    } else {
      // Mostrar mensaje de error si las credenciales son incorrectas
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Usuario o contraseña incorrectos'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  List<Usuario> usuarios = [
    Usuario(
      nombre: 'Juan',
      apellido: 'Perez',
      correoElectronico: 'juan.perez@example.com',
      numeroTelefono: '555-1234',
      direccion: 'Calle 123, Ciudad',
      nombreUsuario: 'juanperez',
      contrasena: 'password123',
      fechaNacimiento: DateTime(1990, 5, 10),
      numeroIdentificacion: 'ID123456',
      puestoTrabajo: 'Administrador',
    ),
    Usuario(
      nombre: 'Maria',
      apellido: 'Gomez',
      correoElectronico: 'maria.gomez@example.com',
      numeroTelefono: '555-5678',
      direccion: 'Avenida 456, Ciudad',
      nombreUsuario: 'mariagomez',
      contrasena: 'password456',
      fechaNacimiento: DateTime(1995, 8, 20),
      numeroIdentificacion: 'ID789012',
      puestoTrabajo: 'Cajero',
    ),
    Usuario(
      nombre: 'Carlos',
      apellido: 'Lopez',
      correoElectronico: 'carlos.lopez@example.com',
      numeroTelefono: '555-9101',
      direccion: 'Plaza 789, Ciudad',
      nombreUsuario: 'carloslopez',
      contrasena: 'password789',
      fechaNacimiento: DateTime(1988, 12, 15),
      numeroIdentificacion: 'ID345678',
      puestoTrabajo: 'Usuario Normal',
    ),
  ];
}
