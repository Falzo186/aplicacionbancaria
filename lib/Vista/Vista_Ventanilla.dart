import 'package:flutter/material.dart';

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
            decoration: InputDecoration(
              hintText: "Ingrese el nombre o código de identificación del usuario",
              border: OutlineInputBorder(),
              fillColor: Colors.white,
              filled: true,
            ),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                onPressed: () {},
                child: Icon(Icons.search),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: Container(
              color: Colors.grey[600],
              child: ListView(
                children: [
            _buildClientCard(),
            _buildClientCard(),
                ],
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

  Widget _buildClientCard() {
    return Card(
      color: Colors.green[900],
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nombre del cliente", style: TextStyle(color: Colors.white)),
            Row(
              children: [
                CircleAvatar(backgroundColor: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("No. de Cuenta", style: TextStyle(color: Colors.white)),
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
