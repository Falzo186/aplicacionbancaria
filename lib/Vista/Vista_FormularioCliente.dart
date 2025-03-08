import 'package:flutter/material.dart';
import 'dart:math';

class VistaFormularioCliente extends StatefulWidget {
  @override
  _VistaFormularioClienteState createState() => _VistaFormularioClienteState();
}

class _VistaFormularioClienteState extends State<VistaFormularioCliente> {
  final _formKey = GlobalKey<FormState>();
  final _random = Random();

  // Controladores para los campos del formulario
  final TextEditingController _nombreCompletoController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _identificacionOficialController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _estadoCivilController = TextEditingController();
  final TextEditingController _nacionalidadController = TextEditingController();
  final TextEditingController _direccionCompletaController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoElectronicoController = TextEditingController();
  final TextEditingController _ocupacionController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  final TextEditingController _direccionEmpresaController = TextEditingController();
  final TextEditingController _telefonoEmpresaController = TextEditingController();
  final TextEditingController _ingresosMensualesController = TextEditingController();
  final TextEditingController _fuenteIngresosController = TextEditingController();

  String _generarNumeroCuenta() {
    return List.generate(11, (_) => _random.nextInt(10)).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Nuevo Cliente'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreCompletoController,
                decoration: InputDecoration(labelText: 'Nombre Completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el nombre completo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _generoController,
                decoration: InputDecoration(labelText: 'Género'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el género';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaNacimientoController,
                decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fecha de nacimiento';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _identificacionOficialController,
                decoration: InputDecoration(labelText: 'Identificación Oficial'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la identificación oficial';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rfcController,
                decoration: InputDecoration(labelText: 'RFC'),
              ),
              TextFormField(
                controller: _estadoCivilController,
                decoration: InputDecoration(labelText: 'Estado Civil'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el estado civil';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nacionalidadController,
                decoration: InputDecoration(labelText: 'Nacionalidad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la nacionalidad';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _direccionCompletaController,
                decoration: InputDecoration(labelText: 'Dirección Completa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección completa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el teléfono';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _correoElectronicoController,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el correo electrónico';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ocupacionController,
                decoration: InputDecoration(labelText: 'Ocupación'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la ocupación';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _empresaController,
                decoration: InputDecoration(labelText: 'Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la empresa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _direccionEmpresaController,
                decoration: InputDecoration(labelText: 'Dirección de la Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la dirección de la empresa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _telefonoEmpresaController,
                decoration: InputDecoration(labelText: 'Teléfono de la Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el teléfono de la empresa';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ingresosMensualesController,
                decoration: InputDecoration(labelText: 'Ingresos Mensuales'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese los ingresos mensuales';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fuenteIngresosController,
                decoration: InputDecoration(labelText: 'Fuente de Ingresos'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la fuente de ingresos';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String numeroCuenta = _generarNumeroCuenta();
                    // Aquí puedes manejar el envío de los datos del cliente
                    print('Número de Cuenta: $numeroCuenta');
                    print('Nombre Completo: ${_nombreCompletoController.text}');
                    // Imprimir o enviar los demás datos...
                  }
                },
                child: Text('Agregar Cliente'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}