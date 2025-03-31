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
 

  final controlador = ControladorDatoscliente();
  static String _generarNumeroCuenta() {
    Random random = Random();
    return List.generate(11, (_) => random.nextInt(10).toString()).join();
  }

  @override
Widget build(BuildContext context) {
    return MaterialApp(
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
            backgroundColor: const Color(0xAF472F2F)),
        ),
      ),
      home: const NuevoClienteForm(),
    );
  }
}

class NuevoClienteForm extends StatefulWidget {
  const NuevoClienteForm({super.key});

  @override
  State<NuevoClienteForm> createState() => _NuevoClienteFormState();
}

class _NuevoClienteFormState extends State<NuevoClienteForm> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedEstadoCivil;
  String? _selectedNacionalidad;
  String? _selectedFuenteIngresos;

  // Opciones para los dropdowns
  final List<String> _estadosCiviles = [
    'Soltero/a',
    'Casado/a',
    'Divorciado/a',
    'Viudo/a',
    'Unión Libre'
  ];

  final List<String> _nacionalidades = [
    'Mexicana',
    'Estadounidense',
    'Canadiense',
    'Española',
    'Colombiana',
    'Argentina',
    'Otra'
  ];

  final List<String> _fuentesIngresos = [
    'Empleo formal',
    'Negocio propio',
    'Honorarios profesionales',
    'Inversiones',
    'Pensión',
    'Otro'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuevo Cliente',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xAF472F2F),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 20, 40, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Primera fila
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildLabeledField('Número de cuenta:', 'numCuenta'),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 5,
                      child: _buildLabeledField('Nombre Completo:', 'nombreCompleto'),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      flex: 3,
                      child: _buildLabeledDropdown(
                        'Género/Sexo:', 
                        ['Masculino', 'Femenino', 'Otro'], 
                        'genero',
                        iconColor: const Color(0x82A76E46),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),
                
                // Segunda fila - Ahora con dropdowns mejorados
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledField('Fecha de Nacimiento:', 'fechaNac'),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildLabeledDropdown(
                        'Estado Civil:', 
                        _estadosCiviles, 
                        'estadoCivil',
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
                        'nacionalidad',
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
                
                // Tercera fila
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledField('Identificación Oficial:', 'identificacion'),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildLabeledField('RFC (Opcional):', 'rfc'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),
                
                // Campos grandes
                _buildLabeledField('Dirección Completa:', 'direccion', lines: 2),
                
                const SizedBox(height: 25),
                
                // Cuarta fila
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledField('Teléfono:', 'telefono'),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildLabeledField('Correo electrónico:', 'email'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),
                
                // Quinta fila
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledField('Empresa:', 'empresa'),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildLabeledField('Ocupación:', 'ocupacion'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),
                
                // Sexta fila
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledField('Dirección Empresa:', 'dirEmpresa'),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildLabeledField('Telefono Empresa:', 'telEmpresa'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 25),
                
                // Séptima fila - Fuente de ingresos como dropdown
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildLabeledField('Ingresos Mensuales:', 'ingresos'),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildLabeledDropdown(
                        'Fuente de ingresos:', 
                        _fuentesIngresos, 
                        'fuenteIngresos',
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
                
                // Botones
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          side: const BorderSide(color: Color(0xAF472F2F)),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Color(0xAF472F2F)),
                        ),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
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
    );
  }

  Widget _buildLabeledField(String label, String fieldKey, {int lines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: lines == 1 ? 56 : null,
          child: TextFormField(
            key: Key(fieldKey),
            maxLines: lines,
            decoration: InputDecoration(
              suffixIcon: fieldKey == 'fechaNac' 
                ? IconButton(
                    icon: const Icon(Icons.calendar_today, color: Color(0x82A76E46)),
                    onPressed: () {},
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
    List<String> options, 
    String fieldKey, {
    String? value,
    ValueChanged<String?>? onChanged,
    Color iconColor = Colors.black,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: DropdownButtonFormField<String>(
            key: Key(fieldKey),
            decoration: const InputDecoration(),
            value: value,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged ?? (_) {},
            icon: Icon(Icons.arrow_drop_down, color: iconColor),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
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
