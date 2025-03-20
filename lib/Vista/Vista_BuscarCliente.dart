import 'package:aplicacionbancaria/Vista/Vista_DatosCliente.dart';
import 'package:flutter/material.dart';
import '../Controlador/Controlador_DatosCliente.dart';
import '../Controlador/Controlador_Ventanilla.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Usuario.dart';
import 'Vista_Login.dart';

final Color colorAppbar = Color(0xFF472F2F);
final Color colorBuscador = Color(0xFFD9D9D9);
final Color colorBackground = Color(0xFFB1ACAC);
final Color colorMenu = Color(0xFF5C3B3B);
final Color colorFondo = Color(0xFF676464);
final Color colorCard = Color(0xFFEDECEC);
final Color colorBoton = Color(0xFFA08181);
final Color colorTexto = Color(0xFF140A0A);
final Color colorTexto2 = Color(0xFFEEEEEE);
final Color colorIcon = Color(0xFF1F1010);
final Color colorCircle = Color(0xFF138A43);

class VistaBuscarCliente extends StatefulWidget {
  const VistaBuscarCliente({super.key, required this.usuario});
  final Usuario usuario;

  @override
  _VistaBuscarClienteScreenState createState() => _VistaBuscarClienteScreenState();
}

class _VistaBuscarClienteScreenState extends State<VistaBuscarCliente> {
  bool _showMenu = false;
  int _currentTurn = 1;
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
      backgroundColor: colorBackground,
     appBar: AppBar(
  backgroundColor: colorAppbar,
  title: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text('Escritorio Número 1'),
      Row(
        children: [
          Text(
            'TURNO',
            style: TextStyle(color: colorTexto2),
          ),
          SizedBox(width: 10),
          Container(
            width: 50,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colorBuscador,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$_currentTurn',
              textAlign: TextAlign.center,
              style: TextStyle(color: colorTexto),
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: colorTexto2),
            onPressed: () {
              setState(() {
                _currentTurn++;
              });
            },
          ),
          SizedBox(width: 10), // Espacio entre la flecha y el menú
          IconButton(
            icon: Icon(Icons.menu, color: colorTexto2),
            onPressed: () {
              setState(() {
                _showMenu = !_showMenu;
              });
            },
          ),
        ],
      ),
    ],
  ),
),

      body: Stack(
        children: [
          FutureBuilder(
            future: _initializeClientes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error al cargar datos"));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: colorFondo,
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
                      // Aquí se pueden agregar más widgets
                    ],
                  ),
                );
              }
            },
          ),
          Positioned(
            right: _showMenu ? 0 : -500,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              width: 220,
              height: MediaQuery.of(context).size.height,
              color: colorMenu,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: SingleChildScrollView(
                // HACE QUE EL MENÚ SEA SCROLLABLE
                child: AnimatedOpacity(
                  opacity: _showMenu ? 1 : 0,
                  duration: Duration(milliseconds: 250),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Menú",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        Divider(color: colorTexto2),
                        SizedBox(height: 5),
                        Text(
                          "Usuario: ${widget.usuario.nombre} ${widget.usuario.apellido}",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Correo: ${widget.usuario.correoElectronico}",
                          style: TextStyle(fontSize: 14, color: Colors.white70),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 20),
                        Divider(color: colorTexto2),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: colorBoton,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => VistaLogin(),
                                  ),
                                );
                              },
                              child: Text(
                                "Cerrar Sesión",
                                style: TextStyle(color: colorTexto),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientCard(Cliente cliente) {
    return Card(
      color: colorCard,
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
                    backgroundColor: colorCircle, // Puedes cambiar el color del círculo
                  ),
                  SizedBox(width: 10),
                  Text(
                    cliente.nombreCompleto,
                    style: TextStyle(
                      color: colorTexto,
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
                            color: colorTexto,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Tel: ${cliente.telefono}",
                          style: TextStyle(color: colorTexto, fontSize: 14),
                        ),
                        Text(
                          "Email: ${cliente.correoElectronico}",
                          style: TextStyle(color: colorTexto),
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
