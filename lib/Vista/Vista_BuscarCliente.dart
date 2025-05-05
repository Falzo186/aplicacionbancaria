import 'package:aplicacionbancaria/Controlador/Controlador_DatosCliente.dart';
import 'package:aplicacionbancaria/Controlador/Controlador_Ventanilla.dart';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Cliente.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:aplicacionbancaria/Vista/Vista_DatosCliente.dart';
import 'package:flutter/material.dart';
import '../Modelo/Empleado.dart';
import '../Modelo/Usuario.dart';

class VistaBuscarCliente extends StatefulWidget {
  VistaBuscarCliente({
    super.key,
    required this.usuario,
    required this.empleado,
  });
  final Usuario usuario;
  final Empleado empleado;

  @override
  _VistaBuscarClienteScreenState createState() =>
      _VistaBuscarClienteScreenState();
}

class _VistaBuscarClienteScreenState extends State<VistaBuscarCliente> {
  final TextEditingController _searchController = TextEditingController();
  bool _showMenu = false;
  VentanaModelo colorsv = VentanaModelo();
  final ScrollController _scrollController = ScrollController();
  final controlador = ControladorVentanilla();
  final controladorCliente = ControladorDatoscliente();
  List<Cliente> clientes = [];
  List<Cliente> filteredClientes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeClientes();
  }

  Future<void> _initializeClientes() async {
    clientes = await controladorCliente.obtenerClientes();
    setState(() {
      filteredClientes = clientes;
      _isLoading = false;
    });
  }

  void _filterClientes(String query) {
    final filtered =
        clientes.where((cliente) {
          final nombreLower = cliente.nombreCompleto.toLowerCase();
          final numeroCuentaLower = cliente.numeroCuenta.toLowerCase();
          final searchLower = query.toLowerCase();

          return nombreLower.contains(searchLower) ||
              numeroCuentaLower.contains(searchLower);
        }).toList();

    setState(() {
      filteredClientes = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: colorsv.colorBackground,
        appBar: CustomAppBar(
          backgroundColor: colorsv.colorAppbar,
          title: Text(
            "Cargando...",
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: colorsv.colorBackground,
      appBar: CustomAppBar(
        backgroundColor: colorsv.colorAppbar,
        title: Row(
          children: [
            Text(
              "Buscar Cliente",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 40),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _showMenu ? 500 : 0,
              curve: Curves.easeInOut,
              child: TextField(
                controller: _searchController,
                onChanged: _filterClientes,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _showMenu ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (_showMenu) {
                    _searchController.clear();
                    filteredClientes = clientes;
                  }
                  _showMenu = !_showMenu;
                });
              },
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: colorsv.colorFondo,
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 6,
                  radius: Radius.circular(20),
                  trackVisibility: true,
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: filteredClientes.length,
                    itemBuilder: (context, index) {
                      final cliente = filteredClientes[index];
                      return _buildClientCard(cliente);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildClientCard(Cliente cliente) {
    return Card(
      color: colorsv.colorCard,
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: colorsv.colorCircle,
                  ),
                  SizedBox(width: 10),
                  Text(
                    cliente.nombreCompleto,
                    style: TextStyle(
                      color: colorsv.colorTexto,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cuenta: ${cliente.numeroCuenta}",
                          style: TextStyle(
                            color: colorsv.colorTexto,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Tel: ${cliente.telefono}",
                          style: TextStyle(
                            color: colorsv.colorTexto,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Email: ${cliente.correoElectronico}",
                          style: TextStyle(color: colorsv.colorTexto),
                        ),
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
          builder:
              (context) => AlertDialog(
                title: Text('Datos del Usuario'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Nombre: ${widget.empleado.nombreEmpleado}'),
                    Text('Email: ${widget.empleado.correoElectronico}'),
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
