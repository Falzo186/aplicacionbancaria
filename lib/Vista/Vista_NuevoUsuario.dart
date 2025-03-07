import 'package:aplicacionbancaria/Controlador/Controlador_NuevoUsuario.dart';
import 'package:flutter/material.dart';

import '../Modelo/Usuario.dart';

class CrearUsuario extends StatefulWidget {
  @override
  _CrearUsuarioState createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _correoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _direccionController = TextEditingController();
  final _nombreUsuarioController = TextEditingController();
  final _contrasenaController = TextEditingController();
  String _tipoUsuario = 'Cliente';

  final controlador = ControladorNuevousuario();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Nuevo Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nombreController,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: InputDecoration(labelText: 'Apellido'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _correoController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el correo electrónico';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Número de Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el número de teléfono';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _direccionController,
                decoration: InputDecoration(labelText: 'Dirección'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreUsuarioController,
                decoration: InputDecoration(labelText: 'Nombre de Usuario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre de usuario';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contrasenaController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la contraseña';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _tipoUsuario,
                decoration: InputDecoration(labelText: 'Tipo de Usuario'),
                items: ['Cliente', 'Administrador']
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipoUsuario = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final nuevoUsuario = Usuario(
                      nombre: _nombreController.text,
                      apellido: _apellidoController.text,
                      correoElectronico: _correoController.text,
                      numeroTelefono: _telefonoController.text,
                      direccion: _direccionController.text,
                      nombreUsuario: _nombreUsuarioController.text,
                      contrasena: _contrasenaController.text,
                      tipoUsuario: _tipoUsuario,
                    );
                    controlador.agregarUsuario(nuevoUsuario);
                    cleanText();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Usuario creado exitosamente')),
                    );
                  }
                },
                child: Text('Crear Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _correoController.dispose();
    _telefonoController.dispose();
    _direccionController.dispose();
    _nombreUsuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  void cleanText() {
    _nombreController.clear();
    _apellidoController.clear();
    _correoController.clear();
    _telefonoController.clear();
    _direccionController.clear();
    _nombreUsuarioController.clear();
    _contrasenaController.clear();
  }
}




