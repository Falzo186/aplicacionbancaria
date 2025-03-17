import 'package:aplicacionbancaria/Vista/Vista_Ventanilla2.dart';
import 'package:flutter/material.dart';
import '../Controlador/Controlador_DatosCliente.dart';
import '../Controlador/Controlador_Ventanilla.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Usuario.dart';

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

class VistaVentanilla extends StatefulWidget {
  const VistaVentanilla({super.key, required this.usuario});
  final Usuario usuario;

  @override
  _VentanillaScreenState createState() => _VentanillaScreenState();
}

class _VentanillaScreenState extends State<VistaVentanilla> {
  bool _showMenu = false;
  TextEditingController _searchController = TextEditingController();
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Container(
          color: colorAppbar, // Color de fondo para toda la sección
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Ingrese el nombre o numero de cuenta del cliente",
                    hintStyle: TextStyle(color: colorTexto),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: colorBuscador,
                    filled: true,
                  ),
                  onChanged: _filterClientes,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                color: colorIcon,
                onPressed: () {
                  setState(() {
                    _showMenu = !_showMenu;
                  });
                },
                icon: Icon(Icons.menu),
              ),
            ],
          ),
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
                              onPressed: () => onSelected(context, 1),
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
