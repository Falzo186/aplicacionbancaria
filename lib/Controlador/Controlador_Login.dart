import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:aplicacionbancaria/Modelo/WarningModel.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Vista/Vista_Administrador.dart';
import '../Vista/Vista_Escritorio.dart';
import '../Vista/Vista_Ventanilla.dart';
import '../Modelo/Usuario.dart';

class ControladorLogin {
  final supabase = Supabase.instance.client;
  VentanaModelo colorsv = VentanaModelo();

  Future<void> login(
    String nombreUsuario,
    String password,
    BuildContext context,
  ) async {
    try {
      // Buscar al usuario en la base de datos por su nombre de usuario
      final response =
          await supabase
              .from(
                'usuarios',
              ) // Asegúrate de que esta tabla existe en Supabase
              .select()
              .eq('nombre_usuario', nombreUsuario)
              .single();

      if (response == null) {
        _mostrarError(context, "Usuario no encontrado.");
        return;
      }

      // Verificar la contraseña (esto debería hacerse con hashing en producción)
      if (response['contrasena'] != password) {
        _mostrarError(context, "Contraseña incorrecta.");
        return;
      }

      // Crear objeto Usuario con los datos obtenidos
      Usuario usuario = Usuario(
        nombre: response['nombre'],
        apellido: response['apellido'],
        correoElectronico: response['correo_electronico'],
        numeroTelefono: response['numero_telefono'],
        direccion: response['direccion'],
        nombreUsuario: response['nombre_usuario'],
        contrasena:
            response['contrasena'], // ⚠️ En producción, nunca guardes contraseñas planas
        fechaNacimiento: DateTime.parse(response['fecha_nacimiento']),
        numeroIdentificacion: response['numero_identificacion'],
        puestoTrabajo: response['puesto_trabajo'],
      );

      // Redirigir según el puesto de trabajo
      if (usuario.puestoTrabajo == 'administrador') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    AdministradorView(usuario: usuario, mostrarMenu: false),
          ),
        );
      } else if (usuario.puestoTrabajo == 'escritorio') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    EscritorioView(usuario: usuario, mostrarMenu: false),
          ),
        );
      } else if (usuario.puestoTrabajo == 'cajero') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    VistaVentanilla(usuario: usuario, mostrarMenu: true),
          ),
        );
      }
    } catch (e) {
      _mostrarError(context, "Error al iniciar sesión: ${e.toString()}");
    }
  }

  //show error message
  void _mostrarError(BuildContext context, String mensaje) {
    final errorDialog = ErrorDialog(context: context, mensaje: mensaje);
    errorDialog.mostrar();
  }

  // no toquen mas este metodo es de prueba

  Future<void> insertarUsuarios() async {
    final supabase = Supabase.instance.client;

    final usuarios = [
      {
        'nombre': 'Lesly Dariana',
        'apellido': 'Aguilar Gomez',
        'correo_electronico': 'lesly@example.com',
        'numero_telefono': '1234567890',
        'direccion': 'Dirección 1',
        'nombre_usuario': 'lesly_admin',
        'contrasena': 'password123',
        'fecha_nacimiento': '1995-08-10',
        'numero_identificacion': 'ABC123',
        'puesto_trabajo': 'administrador',
      },
      {
        'nombre': 'Iram Said',
        'apellido': 'Gomez Rubio',
        'correo_electronico': 'iram@example.com',
        'numero_telefono': '0987654321',
        'direccion': 'Dirección 2',
        'nombre_usuario': 'iram_escritorio',
        'contrasena': 'password456',
        'fecha_nacimiento': '1998-02-15',
        'numero_identificacion': 'DEF456',
        'puesto_trabajo': 'escritorio',
      },
      {
        'nombre': 'Pedro Daniel',
        'apellido': 'Saldaña Nieto',
        'correo_electronico': 'pedro@example.com',
        'numero_telefono': '1122334455',
        'direccion': 'Dirección 3',
        'nombre_usuario': 'pedro_cajero',
        'contrasena': 'password789',
        'fecha_nacimiento': '2000-06-20',
        'numero_identificacion': 'GHI789',
        'puesto_trabajo': 'cajero',
      },
    ]; // hola ---

    for (var usuario in usuarios) {
      await supabase.from('usuarios').insert(usuario);
    }

    print('Usuarios insertados correctamente');
  }

  Future<List<Usuario>> obtenerUsuariosEscritorio() async {
    try {
      final response = await supabase
          .from('usuarios')
          .select()
          .eq('puesto_trabajo', 'escritorio');

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List).map((data) {
        return Usuario(
          nombre: data['nombre'],
          apellido: data['apellido'],
          correoElectronico: data['correo_electronico'],
          numeroTelefono: data['numero_telefono'],
          direccion: data['direccion'],
          nombreUsuario: data['nombre_usuario'],
          contrasena: data['contrasena'],
          fechaNacimiento: DateTime.parse(data['fecha_nacimiento']),
          numeroIdentificacion: data['numero_identificacion'],
          puestoTrabajo: data['puesto_trabajo'],
        );
      }).toList();
    } catch (e) {
      print('Error al obtener usuarios tipo escritorio: ${e.toString()}');
      return [];
    }
  }
  







}
