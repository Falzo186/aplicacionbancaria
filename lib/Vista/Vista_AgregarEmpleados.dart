import 'package:aplicacionbancaria/Controlador/Controlador_Login.dart';
import 'package:aplicacionbancaria/Modelo/Usuario.dart';
import 'package:flutter/material.dart';

import '../Modelo/Empleado.dart';


class VistaFormularioEmpleado extends StatefulWidget {
  @override
  _VistaFormularioEmpleadoState createState() => _VistaFormularioEmpleadoState();
}

class _VistaFormularioEmpleadoState extends State<VistaFormularioEmpleado> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idEmpleadoController = TextEditingController();
  final TextEditingController _nombreEmpleadoController = TextEditingController();
  final TextEditingController _fechaCumpleanosController = TextEditingController();
  final TextEditingController _nombreUsuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _rfcController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _correoElectronicoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final controlador = ControladorLogin();

  String? _selectedDepartamento;
  String? _selectedEstadoCivil;
  String? _selectedGenero;
  List<String> _selectedBeneficios = [];

  final List<String> _departamentos = [
    'Administración',
    'Ventanilla',
    'Escritorio'
  ];

  final List<String> _estadosCiviles = [
    'Soltero',
    'Casado',
    'Viudo',
    'Divorciado',
  ];

  final List<String> _beneficios = [
    'Seguro Médico',
    'Vales de Despensa',
    'Bonos',
    'PTU',
    'Fondo de Ahorro'
  ];

  @override
  void initState() {
    super.initState();
    _generateEmployeeId();
  }

  void _generateEmployeeId() {
    // Simulate generating a unique employee ID
    final uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    _idEmpleadoController.text = uniqueId;
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final empleado = Empleado(
        id: _idEmpleadoController.text,
        nombreEmpleado: _nombreEmpleadoController.text,
        sexo: _selectedGenero ?? '',
        fechaCumpleanos: DateTime.parse(_fechaCumpleanosController.text),
        rfc: _rfcController.text,
        direccion: _direccionController.text,
        numeroTelefono: _telefonoController.text,
        estadoCivil: _selectedEstadoCivil ?? '',
        puestoTrabajo: _nombreUsuarioController.text,
        correoElectronico: _correoElectronicoController.text,
        numeroIdentificacionOficial: _contrasenaController.text,
      );

      final usuario = Usuario(
        idUsuario: _idEmpleadoController.text,
        nombreUsuario: _nombreUsuarioController.text,
        contrasena: _contrasenaController.text,
        departamento: _selectedDepartamento ?? '',
        idempleado: _idEmpleadoController.text,
      );

      controlador.altaEmpleado(empleado);
      controlador.altaUsuario(usuario as Usuario);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Empleado y usuario registrados exitosamente')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registro de Empleado',
          style: TextStyle(
            fontFamily: 'Lato',
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w200,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF472F2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
                _buildSectionTitle('Información Básica'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledField(
                        'ID del Empleado:',
                        _idEmpleadoController,
                        enabled: false,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildLabeledDropdown(
                        'Género:',
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
                const SizedBox(height: 16),
                _buildLabeledField('Nombre Completo:', _nombreEmpleadoController),
                _buildSectionTitle('Datos Laborales'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledField(
                        'Fecha Cumpleaños:',
                        _fechaCumpleanosController,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildLabeledField('Nombre Usuario:', _nombreUsuarioController),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledDropdown(
                        'Departamento:',
                        _departamentos,
                        value: _selectedDepartamento,
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartamento = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildLabeledField(
                        'Contraseña:',
                        _contrasenaController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabeledDropdown(
                  'Estado civil:',
                  _estadosCiviles,
                  value: _selectedEstadoCivil,
                  onChanged: (value) {
                    setState(() {
                      _selectedEstadoCivil = value;
                    });
                  },
                ),
                _buildSectionTitle('Información Adicional'),
                const SizedBox(height: 16),
                _buildLabeledField('RFC:', _rfcController),
                const SizedBox(height: 16),
                _buildLabeledField('Teléfono:', _telefonoController, keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _buildLabeledField('Email:', _correoElectronicoController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                _buildLabeledField('Dirección:', _direccionController, lines: 2),
                const SizedBox(height: 16),
                _buildMultiSelectDropdown('Beneficios:', _beneficios),
                const SizedBox(height: 30),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                          side: const BorderSide(color: Color(0xFF472F2F)),
                        ),
                        child: const Text(
                          'Cancelar',
                          style: TextStyle(color: Color(0xFF472F2F)),
                        ),
                      ),
                      const SizedBox(width: 30),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                        ),
                        child: const Text('Registrar Empleado'),
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


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Color(0xFF472F2F),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Mali',
      ),
    );
  }

  Widget _buildLabeledField(String label, TextEditingController controller, {
    bool enabled = true,
    VoidCallback? onTap,
    TextInputType? keyboardType,
    int lines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mali',
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: lines == 1 ? 56 : null,
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            maxLines: lines,
            readOnly: onTap != null,
            onTap: onTap,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromARGB(255, 250, 247, 223),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
              suffixIcon: onTap != null
                  ? IconButton(
                      icon: const Icon(Icons.calendar_today, color: Color(0xFFA76E46)),
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
    List<String> items, {
    String? value,
    ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mali',
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 56,
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFECE9CF),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
                borderSide: const BorderSide(color: Colors.black, width: 1),
              ),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFA76E46)),
            dropdownColor: const Color(0xFFECE9CF),
          ),
        ),
      ],
    );
  }
  Widget _buildMultiSelectDropdown(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Mali',
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showMultiSelectDialog(items),
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFECE9CF),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.black, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _selectedBeneficios.isEmpty
                        ? 'Seleccione beneficios'
                        : _selectedBeneficios.join(', '),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Color(0xFFA76E46)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _fechaCumpleanosController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _showMultiSelectDialog(List<String> items) async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedItems: _selectedBeneficios,
        );
      },
    );

    if (results != null) {
      setState(() {
        _selectedBeneficios = results;
      });
    }
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> items;
  final List<String> initialSelectedItems;

  const MultiSelectDialog({
    required this.items,
    required this.initialSelectedItems,
  });

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = List.from(widget.initialSelectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Seleccione beneficios'),
      content: SingleChildScrollView(
        child: Column(
          children: widget.items.map((item) {
            return CheckboxListTile(
              title: Text(item),
              value: _selectedItems.contains(item),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedItems.add(item);
                  } else {
                    _selectedItems.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _selectedItems),
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
