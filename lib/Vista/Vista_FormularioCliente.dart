import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VistaFormularioCliente extends StatefulWidget {
  @override
  _VistaFormularioClienteState createState() => _VistaFormularioClienteState();
}

class _VistaFormularioClienteState extends State<VistaFormularioCliente> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _numeroCuentaController = TextEditingController(text: _generarNumeroCuenta());
  final TextEditingController _nombreCompletoController = TextEditingController();
  final TextEditingController _generoController = TextEditingController();
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

  static String _generarNumeroCuenta() {
    Random random = Random();
    return List.generate(11, (_) => random.nextInt(10).toString()).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Cliente'),
        backgroundColor: Colors.brown,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(title: Text('Item 1'), onTap: () {}),
            ListTile(title: Text('Item 2'), onTap: () {}),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  color: Colors.brown[100],
                  child: Form(
                    key: _formKey,
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 3.5,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        _buildTextField('Número de Cuenta', _numeroCuentaController, readOnly: true),
                        _buildTextField('Nombre Completo', _nombreCompletoController),
                        _buildTextField('Género', _generoController),
                        _buildDatePicker('Fecha de Nacimiento'),
                        _buildTextField('Identificación Oficial', _identificacionOficialController),
                        _buildTextField('RFC (Opcional)', _rfcController),
                        _buildTextField('Estado Civil', _estadoCivilController),
                        _buildTextField('Nacionalidad', _nacionalidadController),
                        _buildTextField('Dirección Completa', _direccionCompletaController),
                        _buildTextField('Teléfono', _telefonoController),
                        _buildTextField('Correo Electrónico', _correoElectronicoController),
                        _buildTextField('Ocupación', _ocupacionController),
                        _buildTextField('Empresa', _empresaController),
                        _buildTextField('Dirección Empresa', _direccionEmpresaController),
                        _buildTextField('Teléfono Empresa', _telefonoEmpresaController),
                        _buildTextField('Ingresos Mensuales', _ingresosMensualesController),
                        _buildTextField('Fuente de Ingresos', _fuenteIngresosController),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _cancelar,
                  child: Text('CANCELAR'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                ),
                ElevatedButton(
                  onPressed: _agregarCliente,
                  child: Text('AGREGAR CLIENTE'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool readOnly = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      readOnly: readOnly,
      validator: (value) => value!.isEmpty ? 'Campo $label es requerido' : null,
    );
  }

  Widget _buildDatePicker(String label) {
    return _buildTextField(label, _fechaNacimientoController, readOnly: true);
  }

  void _agregarCliente() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String tieneCredito = "No";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cliente agregado correctamente. Crédito: $tieneCredito')));
    }
  }

  void _cancelar() {
    Navigator.pop(context);
  }
}
