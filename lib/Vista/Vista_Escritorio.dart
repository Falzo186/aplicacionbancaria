import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../Modelo/Usuario.dart';
import 'Vista_BuscarCliente.dart';
import 'Vista_FormularioCliente.dart';
import 'Vista_InversionesDisponibles.dart';
import 'Vista_PrestamosDisponibles.dart';
import 'Vista_SegurosDisponibles.dart';

class EscritorioView extends StatefulWidget {
  final Usuario usuario;
  EscritorioView({super.key, required this.usuario});

  @override
  _EscritorioViewState createState() => _EscritorioViewState();
}

class _EscritorioViewState extends State<EscritorioView> {
  VentanaModelo colorsv = VentanaModelo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      endDrawer: _buildDrawer(),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: Row(children: [_buildSideLogo(), _buildMenu()])),
            ],
          ).animate().fade(duration: 500.ms).slideY(begin: -0.1),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.brown.shade700, Colors.brown.shade500],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Escritorio",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Matrícula: 102937456",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 30),
            onPressed: () => Scaffold.of(context).openEndDrawer(),
          ),
        ],
      ),
    );
  }

  Widget _buildSideLogo() {
    return Expanded(
      flex: 2,
      child: Center(
        child: Image.asset(
          'lib/Recursos/logo.png',
          width: 300,
          opacity: AlwaysStoppedAnimation(0.8),
        ).animate().scale(duration: 500.ms),
      ),
    );
  }

  Widget _buildMenu() {
    return Expanded(
      flex: 3,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton("🔍 Consultas Clientes", _onConsultasClientesPressed),
            _buildButton("💰 Inversiones", _onInversionesPressed),
            _buildButton("📄 Prestaciones", _onPrestacionesPressed),
            _buildButton("🛡️ Seguros", _onSegurosPressed),
            _buildButton("⚙️ Alta Clientes", _onAltaClientesPressed),
          ],
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
            decoration: BoxDecoration(color: Colors.brown.shade700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menú',
                  style: GoogleFonts.poppins(
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
                  'Matrícula: 102937456',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.redAccent),
            title: Text('Cerrar Sesión', style: TextStyle(fontSize: 18)),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber.shade700,
              minimumSize: Size(double.infinity, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
          .animate()
          .fade(duration: 500.ms)
          .scale(begin: Offset(0.9, 0.9), end: Offset(1.0, 1.0)),
    );
  }

  void _onConsultasClientesPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaBuscarCliente(usuario: widget.usuario),
      ),
    );
  }

  void _onInversionesPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => VistaInversionesDisponibles(usuario: widget.usuario),
      ),
    );
  }

  void _onPrestacionesPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => VistaPrestamosDisponibles(usuario: widget.usuario),
      ),
    );
  }

  void _onSegurosPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaSegurosDisponibles(usuario: widget.usuario),
      ),
    );
  }

  void _onAltaClientesPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VistaFormularioCliente()),
    );
  }
}
