import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:aplicacionbancaria/Modelo/WarningModel.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Modelo/Empleado.dart';
import '../Vista/Vista_Administrador.dart';
import '../Vista/Vista_Escritorio.dart';
import '../Vista/Vista_Ventanilla.dart';
import '../Modelo/Usuario.dart';

class ControladorLogin {
  final supabase = Supabase.instance.client;
  VentanaModelo colorsv = VentanaModelo();

  Future<void> login(String nombreUsuario, String password, BuildContext context) async {
    try {
      // Buscar al usuario en la base de datos por su nombre de usuario

      final response = await supabase
          .from('usuarios')
          .select()
          .eq('nombreusuario', nombreUsuario)
          .limit(1);

      if (response == null || response.isEmpty) {
        _mostrarError(context, "Usuario no encontrado.");
        return;
      }

      final userData = response[0];

      // Verificar la contraseña (esto debería hacerse con hashing en producción)
      if (userData['contrasena'] != password) {
        _mostrarError(context, "Contraseña incorrecta.");
        return;
      }

      // Crear objeto Usuario con los datos obtenidos
      Usuario usuario = Usuario.fromJson(userData);
      usuario.idUsuario = userData['idusuario']; // Asegúrate de que este campo existe en tu tabla

      // Buscar al empleado relacionado en la tabla empleados
      final empleadoResponse = await supabase
          .from('empleados')
          .select()
          .eq('idempleado', usuario.idempleado)
          .limit(1);

      if (empleadoResponse == null || empleadoResponse.isEmpty) {
       
        _mostrarError(context, "Empleado relacionado no encontrado.");
        return;
      }

      final empleadoData = empleadoResponse[0];
      final empleado = Empleado.fromJson(empleadoData);

      // Redirigir según el puesto de trabajo del empleado
      if (empleadoData['puestotrabajo'] == 'Administracion') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AdministradorView(usuario: usuario, mostrarMenu: false, empleado: empleado),
          ),
        );
      } else if (empleadoData['puestotrabajo'] == 'Escritorio') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EscritorioView(usuario: usuario, mostrarMenu: false, empleado: empleado),
          ),
        );
      } else if (empleadoData['puestotrabajo'] == 'Ventanilla') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                VistaVentanilla(usuario: usuario, mostrarMenu: true, empleado: empleado),
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

 

  Future<List<Empleado>> obtenerUsuariosEscritorio() async {
    try {
      final response = await supabase
          .from('empleados')
          .select()
          .eq('puestotrabajo', 'Escritorio');

      if (response == null || response.isEmpty) {
        return [];
      }

      return (response as List).map((data) {
        return Empleado(
         
      id: data['idempleado'],
      nombreEmpleado: data['nombreempleado'],
      sexo: data['sexo'],
      fechaCumpleanos: DateTime.parse(data['fechacumpleanos']),
      rfc: data['rfc'],
      direccion: data['direccion'],
      numeroTelefono: data['numerotelefono'],
      estadoCivil: data['estadocivil'],
      puestoTrabajo: data['puestotrabajo'],
      correoElectronico: data['correoelectronico'],
      numeroIdentificacionOficial: data['numeroidentificacionoficial'],

        );
      }).toList();
    } catch (e) {
      print('Error al obtener usuarios tipo escritorio: ${e.toString()}');
      return [];
    }
  }

  Future<void> altaEmpleado(Empleado empleado) async {
    try {
      final response = await supabase.from('empleados').insert({
        'idempleado': empleado.id,
        'nombreempleado': empleado.nombreEmpleado,
        'sexo': empleado.sexo,
        'fechacumpleanos': empleado.fechaCumpleanos.toIso8601String(),
        'rfc': empleado.rfc,
        'direccion': empleado.direccion,
        'numerotelefono': empleado.numeroTelefono,
        'estadocivil': empleado.estadoCivil,
        'puestotrabajo': empleado.puestoTrabajo,
        'correoelectronico': empleado.correoElectronico,
        'numeroidentificacionoficial': empleado.numeroIdentificacionOficial,
      });

      if (response == null) {
        print('Error al insertar el empleado.');
      } else {
        print('Empleado insertado correctamente.');
      }
    } catch (e) {
      print('Error al dar de alta al empleado: ${e.toString()}');
    }
  }
   

  Future<void> altaUsuario(Usuario usuario) async {
    try {
      final response = await supabase.from('usuarios').insert({
        'idusuario': usuario.idUsuario,
        'nombreusuario': usuario.nombreUsuario,
        'departamento': usuario.departamento,
        'contrasena': usuario.contrasena,
        'idempleado': usuario.idempleado,
      });

      if (response == null) {
        print('Error al insertar el usuario.');
      } else {
        print('Usuario insertado correctamente.');
      }
    } catch (e) {
      print('Error al dar de alta al usuario: ${e.toString()}');
    }
  }


  Future<void> inicializarEstadistica(String id) async {
    try {
      final response = await supabase.from('estadisticas').insert({
        'id': id,
        'numerosolicitudes': 0,
        'solucionesaprobadas': 0,
        'solucionesrechazadas': 0,
        'solucionespendientes': 0,
      });

      if (response == null) {
        print('Error al insertar la estadística.');
      } else {
        print('Estadística inicializada correctamente.');
      }
    } catch (e) {
      print('Error al inicializar la estadística: ${e.toString()}');
    }
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
  // no toquen mas este metodo es de prueba

}
