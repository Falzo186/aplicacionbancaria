import 'package:flutter/material.dart';

import '../Modelo/Usuario.dart';
import 'Vista_BuscarCliente.dart';
import 'Vista_FormularioCliente.dart';

class AdministradorView extends StatefulWidget {
  final Usuario usuario;
  const AdministradorView({super.key, required this.usuario});

  @override
  _EscritorioViewState createState() => _EscritorioViewState();
}

class _EscritorioViewState extends State<AdministradorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      endDrawer: _buildDrawer(), // Cambiado a endDrawer
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF5B3B32),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Escritorio",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "Matricula: 102937456",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      "Sesion: ${widget.usuario.nombre} ${widget.usuario.apellido}",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu, color: Colors.white),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer(); // Cambiado a openEndDrawer
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Image.asset(
                          'lib/Recursos/logo.png',
                          width: 1000,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 175, 156, 156),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildButton("Consultas Clientes", _onConsultasClientesPressed),
                            _buildButton("Inversiones", _onInversionesPressed),
                            _buildButton("Prestaciones", _onPrestacionesPressed),
                            _buildButton("Seguros", _onSegurosPressed),
                            _buildButton("Gestion de Actividades", _onAltaClientesPressed),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF5B3B32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                SizedBox(height: 10),
                Text(
                  'Usuario: ${widget.usuario.nombre} ${widget.usuario.apellido}',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Matricula: 102937456',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              Navigator.pop(context); // Regresa a la ventana anterior
            },
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC4A454),
          minimumSize: const Size(200, 40),
        ),
        onPressed: onPressed,
        child: Text(text, style: const TextStyle(color: Colors.black)),
      ),
    );
  }

  void _onConsultasClientesPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => VistaBuscarCliente(usuario: widget.usuario)));
  }

  void _onInversionesPressed() {
    print('Botón presionado: Inversiones');
  }

  void _onPrestacionesPressed() {
    print('Botón presionado: Prestaciones');
  }

  void _onSegurosPressed() {
    print('Botón presionado: Seguros');
  }

  void _onAltaClientesPressed() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => VistaFormularioCliente()));
  }
}

