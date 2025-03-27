import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:aplicacionbancaria/Vista/Vista_Ventanilla2.dart';
import 'package:flutter/material.dart';
import '../Controlador/Controlador_DatosCliente.dart';
import '../Controlador/Controlador_Ventanilla.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Usuario.dart';
import '../Modelo/Appbar_perso.dart';
import 'Vista_Login.dart';

class VistaVentanilla extends StatefulWidget {
  final Usuario usuario;
  //final CustomAppBar appBar;
  //VistaVentanilla({super.key, required this.usuario, required this.appBar})
  VistaVentanilla({Key? key, required this.usuario, required bool mostrarMenu});

  @override
  _VentanillaScreenState createState() => _VentanillaScreenState();
}

class _VentanillaScreenState extends State<VistaVentanilla> {
  bool _showMenu = false;
  int _currentTurn = 1;
  VentanaModelo colorsv = VentanaModelo();
  final ScrollController _scrollController = ScrollController();
  final controlador = ControladorVentanilla();
  final controladorCliente = ControladorDatoscliente();
  List<Cliente> clientes = [];
  List<Cliente> filteredClientes = [];

  @override
  void initState() {
    super.initState();
    _initializeClientes();
  }

  Future<void> _initializeClientes() async {
    clientes = await controladorCliente.obtenerClientes();
    setState(() {
      filteredClientes = clientes;
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
    if (filteredClientes.isEmpty && clientes.isNotEmpty) {
      filteredClientes = clientes;
    }
    return Scaffold(
      backgroundColor: colorsv.colorBackground,
      appBar: CustomAppBar(
        backgroundColor: colorsv.colorAppbar,
        title: Row(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _showMenu ? 500 : 0,
              curve: Curves.easeInOut,
              child: TextField(
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
                  _showMenu = !_showMenu;
                });
              },
            ),
            SizedBox(width: 40),
            Text(
              "Ventanilla No. 1",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      //widget.appBar, //se necesita un appbar personalizado y ver la forma de enviar cosas y solo se implemente aqui, al menos en consultas
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorsv.colorAppbar),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Usuario: ${widget.usuario.nombre} ${widget.usuario.apellido}',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    'Correo: ${widget.usuario.correoElectronico}',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.redAccent),
              title: Text('Cerrar Sesión', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => VistaLogin()),
                );
              },
            ),
          ],
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
              builder: (context) => VistaVentanilla2(cliente: cliente),
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
                    backgroundColor:
                        colorsv
                            .colorCircle, // Puedes cambiar el color del círculo
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
