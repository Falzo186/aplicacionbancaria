import 'dart:math';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Bottom_person.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  BottomPerson guardar(String text, VoidCallback onPressed) {
    return BottomPerson(
      text: text,
      onPressed: onPressed,
      backgroundColor: colorsv.confirmado,
      userHeight: 20,
      borderRadius: 15.0,
      textStyle: GoogleFonts.poppins(
        color: colorsv.colorTextoLogin,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  BottomPerson cancelar(String text, VoidCallback onPressed) {
    return BottomPerson(
      text: text,
      onPressed: onPressed,
      backgroundColor: colorsv.denegado,
      userHeight: 20,
      borderRadius: 15.0,
      textStyle: GoogleFonts.poppins(
        color: colorsv.colorTextoLogin,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

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
    'Otra', // Ensure no duplicates
  ];

  final List<String> _fuentesIngresos = [
    'Empleo formal',
    'Negocio propio',
    'Honorarios profesionales',
    'Inversiones',
    'Pensión',
    'Otro',
  ];

  final List<String> _generos = [
    'Masculino',
    'Femenino',
    'No binario',
    'Prefiero no decirlo',
  ];

  @override
  void initState() {
    super.initState();
    textControllerNumCuenta.text =
        _generarNumeroCuenta(); // Generar número de cuenta al iniciar
  }

  @override
  void dispose() {
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
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorsv.colorFondo2,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Número de Cuenta',
                          textControllerNumCuenta,
                          enabled: false,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledField(
                          'Nombre Completo',
                          textControllerNombreCompleto,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledDropdown(
                          'Genero',
                          _generos,
                          value: _selectedGenero,
                          hint: 'Selecciona un género',
                          onChanged: (value) {
                            setState(() {
                              _selectedGenero = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Fecha de Nacimiento:',
                          textControllerFechaNac,
                          hint: 'YYYY-MM-DD',
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
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledField(
                          'Identificación',
                          textControllerIdentificacion,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledField(
                          'RFC',
                          textControllerRFC,
                          hint: 'Ej. ABCD880101XXX',
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Campo requerido';
                            if (!validarRFC(value)) return 'RFC inválido';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledDropdown(
                          'Estado Civil',
                          _estadosCiviles,
                          hint: 'Selecciona un estado civil',
                          onChanged: (value) {
                            setState(() {
                              _selectedEstadoCivil = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledDropdown(
                          'Nacionalidad',
                          _nacionalidades,
                          hint: 'Selecciona una nacionalidad',
                          onChanged: (value) {
                            setState(() {
                              _selectedNacionalidad = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledField(
                          'Dirección Completa',
                          textControllerDireccion,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Teléfono',
                          textControllerTelefono,
                          hint: '(833) 000-0000',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledField(
                          'Email',
                          textControllerEmail,
                          hint: 'correo@outlook.com',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledField(
                          'Ocupación',
                          textControllerOcupacion,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Datos de la Empresa',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colorsv.colorTexto,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Nombre de la Empresa',
                          textControllerEmpresa,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledField(
                          'Teléfono de la Empresa',
                          textControllerTelEmpresa,
                          hint: '(833) 000-0000',
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Dirección de la Empresa',
                          textControllerDirEmpresa,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildLabeledField(
                          'Ingresos Mensuales',
                          textControllerIngresos,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildLabeledDropdown(
                          'Fuente de Ingresos',
                          _fuentesIngresos,
                          onChanged: (value) {
                            setState(() {
                              _selectedFuenteIngresos = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: cancelar('Cancelar', () {
                          Navigator.pop(context);
                        }),
                      ),
                      Expanded(flex: 2, child: SizedBox()),
                      Expanded(child: guardar('Guardar', onPressed)),
                    ],
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
    String? hint,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: colorsv.colorTextoLogin),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: lines == 1 ? 56 : null,
          child: TextFormField(
            validator: validator,
            controller: controller,
            maxLines: lines,
            enabled: enabled,
            readOnly: onTap != null,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint, // ← aquí se usa el hint
              hintStyle: TextStyle(color: Colors.grey[500]),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: colorsv.colorFondo3Login),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(
                  color: colorsv.colorFondo3Login,
                  width: 2.0,
                ),
              ),
              fillColor: colorsv.colorLabel,
              filled: true,
              suffixIcon:
                  onTap != null
                      ? IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: colorsv.colorFondo3Login,
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
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: colorsv.colorTextoLogin),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorsv.colorLabel,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorsv.colorFondo3Login),
            ),
          ),
          hint: Text(
            hint ?? 'Selecciona una opción',
            style: const TextStyle(color: Color.fromARGB(255, 92, 87, 87)),
          ),
          items:
              options.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(
                    option,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              }).toList(),
          value: value,
          onChanged: onChanged,
          dropdownStyleData: DropdownStyleData(
            maxHeight: 200,
            decoration: BoxDecoration(
              color: colorsv.colorLabel,
              borderRadius: BorderRadius.circular(4),
            ),
            offset: const Offset(0, 0),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      ],
    );
  }

  void onPressed() {
    if (_formKey.currentState!.validate()) {
      final Cliente datosCliente = Cliente(
        numeroCuenta: textControllerNumCuenta.text,
        nombreCompleto: textControllerNombreCompleto.text,
        genero: _selectedGenero ?? 'No especificado',
        fechaNacimiento:
            DateTime.tryParse(textControllerFechaNac.text) ?? DateTime.now(),
        identificacionOficial: textControllerIdentificacion.text,
        rfc: textControllerRFC.text.isNotEmpty ? textControllerRFC.text : null,
        estadoCivil: _selectedEstadoCivil ?? 'No especificado',
        nacionalidad: _selectedNacionalidad ?? 'No especificado',
        direccionCompleta: textControllerDireccion.text,
        telefono: textControllerTelefono.text,
        correoElectronico: textControllerEmail.text,
        ocupacion: textControllerOcupacion.text,
        empresa: textControllerEmpresa.text,
        direccionEmpresa: textControllerDirEmpresa.text,
        telefonoEmpresa: textControllerTelEmpresa.text,
        ingresosMensuales: double.tryParse(textControllerIngresos.text) ?? 0.0,
        fuenteIngresos: _selectedFuenteIngresos ?? 'No especificado',
        tieneCredito: false,
        tieneSeguro: false,
        tienePrestamo: false,
      );
      final CuentaCliente nuevaCuenta = CuentaCliente(
        numeroCuenta: textControllerNumCuenta.text,
        saldo: 0.0,
        tipoCuenta: 'Ahorro',
        fechaApertura: DateTime.now(),
        estadoCuenta: 'Activa',
      );
      print(nuevaCuenta);

      controlador.CrearCuenta(nuevaCuenta);
      print(datosCliente.toMap());

      print(datosCliente);
      controlador.CrearCliente(datosCliente);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cliente guardado exitosamente')),
      );
      Navigator.pop(context);
    }
  }

  bool validarRFC(value) {
    final regex = RegExp(
      r'^([A-ZÑ&]{3,4}) ?-?([0-9]{2})([0-1][0-9])([0-3][0-9]) ?-?([A-Z\d]{2})([A\d])$',
    );
    return regex.hasMatch(value.toString().toUpperCase());
  }
}
