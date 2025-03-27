import 'dart:math';
import 'package:aplicacionbancaria/Controlador/Controlador_DatosCliente.dart';
import 'package:aplicacionbancaria/Modelo/Cliente.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VistaFormularioCliente extends StatefulWidget {
  @override
  _VistaFormularioClienteState createState() => _VistaFormularioClienteState();
}

class _VistaFormularioClienteState extends State<VistaFormularioCliente> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _numeroCuentaController = TextEditingController(
    text: _generarNumeroCuenta(),
  );
  final TextEditingController _nombreCompletoController =
      TextEditingController();
  String _generoSeleccionado = 'Hombre';
  String _nacionalidadSeleccionada = 'Mexicana';
  String _estadoCivilSeleccionado = 'Soltero';
  final TextEditingController _identificacionOficialController =
      TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _direccionCompletaController =
      TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoElectronicoController =
      TextEditingController();
  final TextEditingController _ocupacionController = TextEditingController();
  final TextEditingController _empresaController = TextEditingController();
  final TextEditingController _direccionEmpresaController =
      TextEditingController();
  final TextEditingController _telefonoEmpresaController =
      TextEditingController();
  final TextEditingController _ingresosMensualesController =
      TextEditingController();
  final TextEditingController _fuenteIngresosController =
      TextEditingController();

  final controlador = ControladorDatoscliente();
  static String _generarNumeroCuenta() {
    Random random = Random();
    return List.generate(11, (_) => random.nextInt(10).toString()).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nuevo Cliente',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                child: Container(
                  color: Colors.brown[100],
                  child: Form(
                    key: _formKey,
                    child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 4.5,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      padding: const EdgeInsets.only(
                        top: 10,
                        left: 10,
                        right: 10,
                      ),
                      children: [
                        _buildTextField(
                          'Número de Cuenta',
                          _numeroCuentaController,
                          readOnly: true,
                        ),
                        _buildTextField(
                          'Nombre Completo',
                          _nombreCompletoController,
                        ),
                        _buildDropdown(
                          'Género',
                          ['Hombre', 'Mujer'],
                          _generoSeleccionado,
                          (nuevoValor) {
                            setState(() {
                              _generoSeleccionado = nuevoValor!;
                            });
                          },
                        ),
                        _buildDatePicker('Fecha de Nacimiento'),
                        _buildTextField(
                          'Identificación Oficial',
                          _identificacionOficialController,
                        ),
                        _buildTextField('RFC (Opcional)', _rfcController),
                        _buildDropdown(
                          'Estado Civil',
                          ['Soltero', 'Casado', 'Viudo'],
                          _estadoCivilSeleccionado,
                          (nuevoValor) {
                            setState(() {
                              _estadoCivilSeleccionado = nuevoValor!;
                            });
                          },
                        ),
                        _buildDropdown(
                          'Nacionalidad',
                          ['Mexicana', 'Estadounidense', 'Canadiense', 'Otra'],
                          _nacionalidadSeleccionada,
                          (nuevoValor) {
                            setState(() {
                              _nacionalidadSeleccionada = nuevoValor!;
                            });
                          },
                        ),
                        _buildTextField(
                          'Dirección Completa',
                          _direccionCompletaController,
                        ),
                        _buildTextField('Teléfono', _telefonoController),
                        _buildTextField(
                          'Correo Electrónico',
                          _correoElectronicoController,
                        ),
                        _buildTextField('Ocupación', _ocupacionController),
                        _buildTextField('Empresa', _empresaController),
                        _buildTextField(
                          'Dirección Empresa',
                          _direccionEmpresaController,
                        ),
                        _buildTextField(
                          'Teléfono Empresa',
                          _telefonoEmpresaController,
                        ),
                        _buildTextField(
                          'Ingresos Mensuales',
                          _ingresosMensualesController,
                        ),
                        _buildTextField(
                          'Fuente de Ingresos',
                          _fuenteIngresosController,
                        ),
                        SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _cancelar,
                              child: Text('CANCELAR'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _agregarCliente,
                              child: Text('AGREGAR CLIENTE'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      readOnly: readOnly,
      validator: (value) => value!.isEmpty ? 'Campo $label es requerido' : null,
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> opciones,
    String valorSeleccionado,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: valorSeleccionado,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      items: opciones
          .map((opcion) => DropdownMenuItem(
                value: opcion,
                child: Text(opcion),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? 'Campo $label es requerido' : null,
    );
  }

  Widget _buildDatePicker(String label) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: Colors.brown,
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
                colorScheme: ColorScheme.light(
                  primary: Colors.brown,
                ).copyWith(secondary: Colors.brown),
              ),
              child: child!,
            );
          },
        );
        if (pickedDate != null) {
          setState(() {
            _fechaNacimientoController.text =
                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
          });
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(
          label,
          _fechaNacimientoController,
          readOnly: true,
        ),
      ),
    );
  }

  void _agregarCliente() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final cliente = Cliente(
        numeroCuenta: _numeroCuentaController.text,
        nombreCompleto: _nombreCompletoController.text,
        genero: _generoSeleccionado,
        fechaNacimiento: DateTime.parse(_fechaNacimientoController.text.split('/').reversed.join('-')),
        identificacionOficial: _identificacionOficialController.text,
        rfc: _rfcController.text.isEmpty ? null : _rfcController.text,
        estadoCivil: _estadoCivilSeleccionado,
        nacionalidad: _nacionalidadSeleccionada,
        direccionCompleta: _direccionCompletaController.text,
        telefono: _telefonoController.text,
        correoElectronico: _correoElectronicoController.text,
        ocupacion: _ocupacionController.text,
        empresa: _empresaController.text,
        direccionEmpresa: _direccionEmpresaController.text,
        telefonoEmpresa: _telefonoEmpresaController.text,
        ingresosMensuales:
            double.tryParse(_ingresosMensualesController.text) ?? 0.0,
        fuenteIngresos: _fuenteIngresosController.text,
        tieneCredito: false,
        tieneSeguro: false,
        tienePrestamo: false,
      );

      try {
        await controlador.CrearCliente(cliente);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cliente agregado correctamente.')),
        );
      } catch (e) {
        print('Error al agregar cliente: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al agregar cliente: $e')));
      }
    }
  }

  void _cancelar() {
    Navigator.pop(context);
  }
}
