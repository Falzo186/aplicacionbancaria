import 'package:aplicacionbancaria/Vista/Vista_DatosCliente.dart';
import 'package:flutter/material.dart';

import '../Modelo/Cliente.dart';
import '../Modelo/Usuario.dart';

class VistaVentanilla extends StatefulWidget {
  const VistaVentanilla({super.key, required this.usuario});
  final Usuario usuario;

  @override
  _VentanillaScreenState createState() => _VentanillaScreenState();
}

class _VentanillaScreenState extends State<VistaVentanilla> {
  bool _showMenu = false;
  double _menuWidth = 0;
  TextEditingController _searchController = TextEditingController();
  List<Cliente> clientes = [
    Cliente(
      numeroCuenta: '12345678901',
      nombreCompleto: 'Ana García',
      genero: 'Femenino',
      fechaNacimiento: DateTime(1990, 5, 15),
      identificacionOficial: 'INE123456789',
      rfc: 'GAGM900515XXX',
      estadoCivil: 'Soltera',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle A #123, Ciudad de México',
      telefono: '5512345678',
      correoElectronico: 'ana.garcia@email.com',
      ocupacion: 'Ingeniera de Software',
      empresa: 'Tech Solutions',
      direccionEmpresa: 'Av. B #456, Ciudad de México',
      telefonoEmpresa: '5587654321',
      ingresosMensuales: 35000.00,
      fuenteIngresos: 'Salario',
    ),
    Cliente(
      numeroCuenta: '98765432109',
      nombreCompleto: 'Juan Pérez',
      genero: 'Masculino',
      fechaNacimiento: DateTime(1985, 8, 22),
      identificacionOficial: 'INE987654321',
      rfc: 'PEPJ850822XXX',
      estadoCivil: 'Casado',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle C #789, Guadalajara',
      telefono: '3398765432',
      correoElectronico: 'juan.perez@email.com',
      ocupacion: 'Contador',
      empresa: 'Accounting Firm',
      direccionEmpresa: 'Av. D #101, Guadalajara',
      telefonoEmpresa: '3321436587',
      ingresosMensuales: 30000.00,
      fuenteIngresos: 'Salario',
    ),
    Cliente(
      numeroCuenta: '11223344556',
      nombreCompleto: 'María López',
      genero: 'Femenino',
      fechaNacimiento: DateTime(1992, 3, 10),
      identificacionOficial: 'INE112233445',
      rfc: 'LOMM920310XXX',
      estadoCivil: 'Soltera',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle E #111, Monterrey',
      telefono: '8155667788',
      correoElectronico: 'maria.lopez@email.com',
      ocupacion: 'Médico',
      empresa: 'Hospital ABC',
      direccionEmpresa: 'Av. F #222, Monterrey',
      telefonoEmpresa: '8199887766',
      ingresosMensuales: 45000.00,
      fuenteIngresos: 'Salario',
    ),
    Cliente(
      numeroCuenta: '66554433221',
      nombreCompleto: 'Carlos Ramírez',
      genero: 'Masculino',
      fechaNacimiento: DateTime(1988, 11, 30),
      identificacionOficial: 'INE665544332',
      rfc: 'RACJ881130XXX',
      estadoCivil: 'Casado',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle G #333, Puebla',
      telefono: '2221122334',
      correoElectronico: 'carlos.ramirez@email.com',
      ocupacion: 'Abogado',
      empresa: 'Law Firm XYZ',
      direccionEmpresa: 'Av. H #444, Puebla',
      telefonoEmpresa: '2224433221',
      ingresosMensuales: 40000.00,
      fuenteIngresos: 'Honorarios',
    ),
    Cliente(
      numeroCuenta: '10293847563',
      nombreCompleto: 'Laura Torres',
      genero: 'Femenino',
      fechaNacimiento: DateTime(1995, 7, 5),
      identificacionOficial: 'INE102938475',
      rfc: 'TOLR950705XXX',
      estadoCivil: 'Soltera',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle I #555, Querétaro',
      telefono: '4425566778',
      correoElectronico: 'laura.torres@email.com',
      ocupacion: 'Diseñadora Gráfica',
      empresa: 'Creative Studio',
      direccionEmpresa: 'Av. J #666, Querétaro',
      telefonoEmpresa: '4428877665',
      ingresosMensuales: 28000.00,
      fuenteIngresos: 'Freelance',
    ),
    Cliente(
      numeroCuenta: '36521487901',
      nombreCompleto: 'Pedro Sánchez',
      genero: 'Masculino',
      fechaNacimiento: DateTime(1983, 12, 12),
      identificacionOficial: 'INE365214879',
      rfc: 'SAPJ831212XXX',
      estadoCivil: 'Casado',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle K #777, León',
      telefono: '4771122334',
      correoElectronico: 'pedro.sanchez@email.com',
      ocupacion: 'Arquitecto',
      empresa: 'Construction Group',
      direccionEmpresa: 'Av. L #888, León',
      telefonoEmpresa: '4774433221',
      ingresosMensuales: 50000.00,
      fuenteIngresos: 'Salario',
    )
  ];

  List<Cliente> filteredClientes = [];

  @override
  void initState() {
    super.initState();
    filteredClientes = clientes;
  }

  void _filterClientes(String query) {
    final filtered = clientes.where((cliente) {
      final nombreLower = cliente.nombreCompleto.toLowerCase();
      final numeroCuentaLower = cliente.numeroCuenta.toLowerCase();
      final searchLower = query.toLowerCase();

      return nombreLower.contains(searchLower) || numeroCuentaLower.contains(searchLower);
    }).toList();

    setState(() {
      filteredClientes = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Ventanilla no. 4"),
            Text("Matrícula: 102346501", style: TextStyle(fontSize: 14)),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text("Sesión: ${widget.usuario.nombre} ${widget.usuario.apellido}")),
          ),
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              setState(() {
                _showMenu = !_showMenu;
                _menuWidth = _showMenu ? 200 : 0;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Ingrese el nombre o numero de cuenta del cliente",
                          border: OutlineInputBorder(),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        onChanged: _filterClientes,
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                      onPressed: () {
                        _filterClientes(_searchController.text);
                      },
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    color: Colors.grey[600],
                    child: ListView.builder(
                      itemCount: filteredClientes.length,
                      itemBuilder: (context, index) {
                        final cliente = filteredClientes[index];
                        return _buildClientCard(cliente);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: () {},
                  child: Text("Seleccionar"),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _menuWidth,
              height: MediaQuery.of(context).size.height,
              color: Color.fromARGB(255, 82, 59, 59),
              child: _showMenu
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Menú",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          Divider(),
                          // Información del usuario
                          Text(
                            "Usuario: ${widget.usuario.nombre} ${widget.usuario.apellido}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            "Correo: ${widget.usuario.correoElectronico}",
                            style: TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 160, 129, 129),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => onSelected(context, 1),
                            child: Text(
                              "Cerrar Sesión",
                              style: TextStyle(color: const Color.fromARGB(255, 17, 16, 16)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(Cliente cliente) {
    return Card(
      color: Colors.green[900],
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VistaDatosCliente(cliente: cliente),
          ),
        );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cliente.nombreCompleto, style: TextStyle(color: Colors.white)),
              Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cliente.numeroCuenta, style: TextStyle(color: Colors.white)),
                        Container(
                          height: 20,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(height: 30, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Datos del Usuario'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Nombre: ${widget.usuario.nombre}'),
                Text('Apellido: ${widget.usuario.apellido}'),
                Text('Email: ${widget.usuario.correoElectronico}'),
                // Añade más datos del usuario si es necesario
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cerrar'),
              ),
            ],
          ),
        );
        break;
      case 1:
        Navigator.of(context).pop();
        break;
    }
  }
}