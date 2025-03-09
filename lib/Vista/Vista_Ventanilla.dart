import 'package:aplicacionbancaria/Vista/Vista_DatosCliente.dart';
import 'package:aplicacionbancaria/Vista/Vista_Ventanilla2.dart';
import 'package:flutter/material.dart';

import '../Controlador/Controlador_DatosCliente.dart';
import '../Controlador/Controlador_Ventanilla.dart';
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
  final controlador = ControladorVentanilla();
  final controladorCliente = ControladorDatoscliente();
  List<Cliente> clientes = [];
  List<Cliente> filteredClientes = [];

  @override
  void initState() {
    super.initState();
    clientes = controladorCliente.obtenerClientes();
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
                // Aquí se pueden agregar más widgets 
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
      color: const Color.fromARGB(255, 153, 107, 22),
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  VistaVentanilla2(cliente: cliente),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cliente.nombreCompleto, 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Row(
                children: [
                  CircleAvatar(backgroundColor: Colors.blue),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Cuenta: ${cliente.numeroCuenta}", 
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text("Tel: ${cliente.telefono}", 
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                        Text("Email: ${cliente.correoElectronico}", 
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),
                ],
              ),
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
