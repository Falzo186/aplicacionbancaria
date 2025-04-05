import 'dart:math';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controlador/Controlador_DatosCliente.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/CuentaCliente.dart';

class VistaFormularioCliente extends StatefulWidget {
  @override
  _VistaFormularioClienteState createState() => _VistaFormularioClienteState();
}

class _VistaFormularioClienteState extends State<VistaFormularioCliente> {
  final _formKey = GlobalKey<FormState>();
  final controlador = ControladorDatoscliente(); // Instancia del controlador
  VentanaModelo colorsv =
      VentanaModelo(); // Instancia de la clase VentanaModelo

  // Controladores para cada campo
  final TextEditingController textControllerNumCuenta = TextEditingController();
  final TextEditingController textControllerNombreCompleto =
      TextEditingController();
  final TextEditingController textControllerFechaNac = TextEditingController();
  final TextEditingController textControllerIdentificacion =
      TextEditingController();
  final TextEditingController textControllerRFC = TextEditingController();
  final TextEditingController textControllerDireccion = TextEditingController();
  final TextEditingController textControllerTelefono = TextEditingController();
  final TextEditingController textControllerEmail = TextEditingController();
  final TextEditingController textControllerEmpresa = TextEditingController();
  final TextEditingController textControllerOcupacion = TextEditingController();
  final TextEditingController textControllerDirEmpresa =
      TextEditingController();
  final TextEditingController textControllerTelEmpresa =
      TextEditingController();
  final TextEditingController textControllerIngresos = TextEditingController();

  String? _selectedEstadoCivil;
  String? _selectedNacionalidad;
  String? _selectedFuenteIngresos;
  String? _selectedGenero;

  static String _generarNumeroCuenta() {
    Random random = Random();
    return List.generate(11, (_) => random.nextInt(10).toString()).join();
  }

  final List<String> _estadosCiviles = [
    'Soltero/a',
    'Casado/a',
    'Divorciado/a',
    'Viudo/a',
    'Unión Libre',
  ];

  final List<String> _nacionalidades = [
    'Mexicana',
    'Estadounidense',
    'Canadiense',
    'Española',
    'Colombiana',
    'Argentina',
    'Otra',
  ];

  final List<String> _fuentesIngresos = [
    'Empleo formal',
    'Negocio propio',
    'Honorarios profesionales',
    'Inversiones',
    'Pensión',
    'Otro',
  ];

  @override
  void initState() {
    super.initState();
    textControllerNumCuenta.text =
        _generarNumeroCuenta(); // Generar número de cuenta al iniciar
  }

  @override
  void dispose() {
    // Liberar los controladores
    textControllerNumCuenta.dispose();
    textControllerNombreCompleto.dispose();
    textControllerFechaNac.dispose();
    textControllerIdentificacion.dispose();
    textControllerRFC.dispose();
    textControllerDireccion.dispose();
    textControllerTelefono.dispose();
    textControllerEmail.dispose();
    textControllerEmpresa.dispose();
    textControllerOcupacion.dispose();
    textControllerDirEmpresa.dispose();
    textControllerTelEmpresa.dispose();
    textControllerIngresos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xA8ECE9CF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontFamily: 'Mali',
            fontSize: 24,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xAF472F2F),
          ),
        ),
      ),
      home: Scaffold(
        appBar: CustomAppBar(
          title: Text(
            'Formulario de Cliente',
            style: GoogleFonts.poppins(
              color: colorsv.colorTexto2,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
          backgroundColor: colorsv.colorAppbar,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colorsv.colorTexto2),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildLabeledField(
                          'Número de cuenta:',
                          textControllerNumCuenta,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        flex: 5,
                        child: _buildLabeledField(
                          'Nombre Completo:',
                          textControllerNombreCompleto,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        flex: 3,
                        child: _buildLabeledDropdown(
                          'Género/Sexo:',
                          ['Masculino', 'Femenino', 'Otro'],
                          value: _selectedGenero,
                          onChanged: (value) {
                            setState(() {
                              _selectedGenero = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Fecha de Nacimiento:',
                          textControllerFechaNac,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                textControllerFechaNac.text =
                                    "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: _buildLabeledDropdown(
                          'Estado Civil:',
                          _estadosCiviles,
                          value: _selectedEstadoCivil,
                          onChanged: (value) {
                            setState(() {
                              _selectedEstadoCivil = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: _buildLabeledDropdown(
                          'Nacionalidad:',
                          _nacionalidades,
                          value: _selectedNacionalidad,
                          onChanged: (value) {
                            setState(() {
                              _selectedNacionalidad = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Identificación Oficial:',
                          textControllerIdentificacion,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: _buildLabeledField(
                          'RFC (Opcional):',
                          textControllerRFC,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  _buildLabeledField(
                    'Dirección Completa:',
                    textControllerDireccion,
                    lines: 2,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Teléfono:',
                          textControllerTelefono,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: _buildLabeledField(
                          'Correo electrónico:',
                          textControllerEmail,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Empresa:',
                          textControllerEmpresa,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: _buildLabeledField(
                          'Ocupación:',
                          textControllerOcupacion,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Dirección Empresa:',
                          textControllerDirEmpresa,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: _buildLabeledField(
                          'Teléfono Empresa:',
                          textControllerTelEmpresa,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Ingresos Mensuales:',
                          textControllerIngresos,
                        ),
                      ),
                      const SizedBox(width: 30),
                      Expanded(
                        child: _buildLabeledDropdown(
                          'Fuente de ingresos:',
                          _fuentesIngresos,
                          value: _selectedFuenteIngresos,
                          onChanged: (value) {
                            setState(() {
                              _selectedFuenteIngresos = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                            side: const BorderSide(color: Color(0xAF472F2F)),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(color: Color(0xAF472F2F)),
                          ),
                        ),
                        const SizedBox(width: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final Cliente datosCliente = Cliente(
                                numeroCuenta: textControllerNumCuenta.text,
                                nombreCompleto:
                                    textControllerNombreCompleto.text,
                                genero: _selectedGenero ?? 'No especificado',
                                fechaNacimiento:
                                    DateTime.tryParse(
                                      textControllerFechaNac.text,
                                    ) ??
                                    DateTime.now(),
                                identificacionOficial:
                                    textControllerIdentificacion.text,
                                rfc:
                                    textControllerRFC.text.isNotEmpty
                                        ? textControllerRFC.text
                                        : null,
                                estadoCivil:
                                    _selectedEstadoCivil ?? 'No especificado',
                                nacionalidad:
                                    _selectedNacionalidad ?? 'No especificado',
                                direccionCompleta: textControllerDireccion.text,
                                telefono: textControllerTelefono.text,
                                correoElectronico: textControllerEmail.text,
                                ocupacion: textControllerOcupacion.text,
                                empresa: textControllerEmpresa.text,
                                direccionEmpresa: textControllerDirEmpresa.text,
                                telefonoEmpresa: textControllerTelEmpresa.text,
                                ingresosMensuales:
                                    double.tryParse(
                                      textControllerIngresos.text,
                                    ) ??
                                    0.0,
                                fuenteIngresos:
                                    _selectedFuenteIngresos ??
                                    'No especificado',
                                tieneCredito:
                                    false, // Cambiar según la lógica de tu aplicación
                                tieneSeguro:
                                    false, // Cambiar según la lógica de tu aplicación
                                tienePrestamo:
                                    false, // Cambiar según la lógica de tu aplicación
                              );
                              final CuentaCliente nuevaCuenta = CuentaCliente(
                                numeroCuenta: textControllerNumCuenta.text,
                                saldo: 0.0, // Saldo inicial
                                tipoCuenta:
                                    'Ahorro', // Tipo de cuenta predeterminado
                                fechaApertura: DateTime.now(),
                                estadoCuenta:
                                    'Activa', // Estado inicial de la cuenta
                              );
                              print(nuevaCuenta);

                              controlador.CrearCuenta(nuevaCuenta);
                              print(datosCliente.toMap());

                              print(datosCliente);
                              controlador.CrearCliente(datosCliente);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Cliente guardado exitosamente',
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                          ),
                          child: const Text('Guardar Cliente'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledField(
    String label,
    TextEditingController controller, {
    int lines = 1,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: lines == 1 ? 56 : null,
          child: TextFormField(
            controller: controller,
            maxLines: lines,
            enabled: enabled,
            readOnly: onTap != null,
            onTap: onTap,
            decoration: InputDecoration(
              suffixIcon:
                  onTap != null
                      ? IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Color(0x82A76E46),
                        ),
                        onPressed: onTap,
                      )
                      : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLabeledDropdown(
    String label,
    List<String> options, {
    String? value,
    ValueChanged<String?>? onChanged,
    Color iconColor = Colors.black,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(),
            value: value,
            items:
                options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  );
                }).toList(),
            onChanged: onChanged,
            icon: Icon(Icons.arrow_drop_down, color: iconColor),
            style: const TextStyle(fontSize: 16, color: Colors.black),
            dropdownColor: const Color(0xA8ECE9CF),
            borderRadius: BorderRadius.circular(4),
            elevation: 2,
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}
