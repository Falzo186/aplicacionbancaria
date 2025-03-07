import 'package:flutter/material.dart';

import '../Modelo/Usuario.dart';

class AdministradorView extends StatefulWidget {
  final Usuario usuario;

  const AdministradorView({super.key, required this.usuario});

  @override
  _AdministradorViewState createState() => _AdministradorViewState();
}

class _AdministradorViewState extends State<AdministradorView> {
  bool _showMenu = false;

  void _toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
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
              // Encabezado
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
                          "Gerente de piso",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "Matrícula: 10284827",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    Text(
                      "Sesión: ${widget.usuario.nombre} ${widget.usuario.apellido}",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: _toggleMenu,
                    ),
                  ],
                ),
              ),

              // Contenido principal
              Expanded(
                child: Row(
                  children: [
                    // Imagen
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: const Color(0xFFE0E0E0),
                        child: Center(
                          child: Image.asset(
                            'lib/Recursos/logo.png',
                            width: 450,
                          ),
                        ),
                      ),
                    ),
                    // Botones
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildButton("Consultas Clientes"),
                            _buildButton("Inversiones"),
                            _buildButton("Prestaciones"),
                            _buildButton("Seguros"),
                            _buildButton("Gestión de actividades"),
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

  Widget _buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC4A454),
          minimumSize: const Size(250, 50),
        ),
        onPressed: () {},
        child: Text(text, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}

