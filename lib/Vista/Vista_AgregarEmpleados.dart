import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: VistaFormularioEmpleado(),
    theme: ThemeData(
      fontFamily: 'Mali',
    ),
  ));
}

class VistaFormularioEmpleado extends StatefulWidget {
  @override
  _VistaFormularioEmpleadoState createState() => _VistaFormularioEmpleadoState();
}

class _VistaFormularioEmpleadoState extends State<VistaFormularioEmpleado> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _numEmpleadoController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _fechaContratacionController = TextEditingController();
  final TextEditingController _puestoController = TextEditingController();
  final TextEditingController _salarioController = TextEditingController();
  final TextEditingController _nssController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();

  String? _selectedDepartamento;
  String? _selectedTipoContrato;
  String? _selectedGenero;
  List<String> _selectedBeneficios = [];

  final List<String> _departamentos = [
    'Administración',
    'Ventanilla',
    'Escritorio'
  ];

  final List<String> _tiposContrato = [
    'Tiempo Completo',
    'Medio Tiempo',
    'Por Proyecto',
    'Temporal'
  ];

  final List<String> _beneficios = [
    'Seguro Médico',
    'Vales de Despensa',
    'Bonos',
    'PTU',
    'Fondo de Ahorro'
  ];

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
                        _numEmpleadoController,
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
                _buildLabeledField('Nombre Completo:', _nombreController),
                _buildSectionTitle('Datos Laborales'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildLabeledField(
                        'Fecha Contratación:',
                        _fechaContratacionController,
                        onTap: () => _selectDate(context),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildLabeledField('Puesto:', _puestoController),
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
                      child: _buildLabeledDropdown(
                        'Tipo Contrato:',
                        _tiposContrato,
                        value: _selectedTipoContrato,
                        onChanged: (value) {
                          setState(() {
                            _selectedTipoContrato = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildLabeledField('Salario:', _salarioController, keyboardType: TextInputType.number),
                _buildSectionTitle('Información Adicional'),
                const SizedBox(height: 16),
                _buildLabeledField('NSS:', _nssController),
                const SizedBox(height: 16),
                _buildLabeledField('Teléfono:', _telefonoController, keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _buildLabeledField('Email:', _emailController, keyboardType: TextInputType.emailAddress),
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
        _fechaContratacionController.text =
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      print({
        'numero_empleado': _numEmpleadoController.text,
        'nombre': _nombreController.text,
        'genero': _selectedGenero,
        'fecha_contratacion': _fechaContratacionController.text,
        'puesto': _puestoController.text,
        'departamento': _selectedDepartamento,
        'tipo_contrato': _selectedTipoContrato,
        'salario': _salarioController.text,
        'nss': _nssController.text,
        'telefono': _telefonoController.text,
        'email': _emailController.text,
        'direccion': _direccionController.text,
        'beneficios': _selectedBeneficios,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Empleado registrado exitosamente')),
      );
      Navigator.pop(context);
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
