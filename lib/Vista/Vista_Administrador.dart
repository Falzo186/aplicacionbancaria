import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:aplicacionbancaria/SistemaNotificaciones/Controlado_Notificaciones.dart';
import 'package:aplicacionbancaria/Vista/VistaAltaSeguro.dart';
import 'package:aplicacionbancaria/Vista/Vista_GestionUsuarios.dart';
import 'package:aplicacionbancaria/Vista/Vista_Inversiones.dart';
import 'package:aplicacionbancaria/Vista/Vista_ReportePrestamo.dart';
import 'package:aplicacionbancaria/Vista/Vista_ReporteSeguro.dart';
import 'package:aplicacionbancaria/Vista/Vista_Seguros.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Modelo/Usuario.dart';
import 'Vista_BuscarCliente.dart';
import 'Vista_Login.dart';
import 'Vista_Prestamos.dart';
import 'Vista_ReporteInvercion.dart';
import 'package:audioplayers/audioplayers.dart';

class AdministradorView extends StatefulWidget {
  final Usuario usuario;
  AdministradorView({
    super.key,
    required this.usuario,
    required bool mostrarMenu,
  });

  @override
  _AdministradorViewState createState() => _AdministradorViewState();
}

class _AdministradorViewState extends State<AdministradorView>
    with TickerProviderStateMixin {
  VentanaModelo colorsv = VentanaModelo();
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> notificaciones = [];
  final Controlador = ControladorNotificaciones();
  final AudioPlayer player = AudioPlayer();
  final List<AnimationController> _animationControllers = [];

  void initState() {
    super.initState();
    cargarNotificacionesAnteriores("28dc2001-518f-4cc0-9190-0ecd3f1c0ead");
    escucharNotificaciones("28dc2001-518f-4cc0-9190-0ecd3f1c0ead");
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    player.dispose();
    super.dispose();
  }

  void mostrarNotificacionesSecuenciales(
    BuildContext context,
    List<String> mensajes,
  ) async {
    OverlayState? overlayState = Overlay.of(context);
    if (overlayState == null) {
      print("Error: Overlay.of(context) es nulo.");
      return;
    }

    for (String mensaje in mensajes) {
      try {
        OverlayEntry overlayEntry;
        AnimationController controller = AnimationController(
          duration: Duration(milliseconds: 500),
          vsync: this,
        );
        _animationControllers.add(controller);

        Animation<Offset> offsetAnimation = Tween<Offset>(
          begin: Offset(1.0, 0.0),
          end: Offset(0.0, 0.0),
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

        // Reproducir sonido de notificación
        await player.play(AssetSource('sounds/notification.mp3'));

        overlayEntry = OverlayEntry(
          builder:
              (context) => Positioned(
                top: 100,
                right: 50,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: Material(
                    color: Colors.transparent,
                    child: AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 500),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade700,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          mensaje,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        );

        overlayState.insert(overlayEntry);
        controller.forward();

        await Future.delayed(Duration(seconds: 5));

        controller.reverse().then((_) {
          overlayEntry.remove();
        });
      } catch (e) {
        print("Error al mostrar notificación: $e");
      }
    }
  }

  void cargarNotificacionesAnteriores(String adminId) async {
    try {
      final response = await supabase
          .from('notificaciones')
          .select()
          .eq('admin_id', adminId)
          .order('fecha', ascending: true);

      setState(() {
        notificaciones = List<Map<String, dynamic>>.from(response as List);
      });

      List<String> mensajes =
          notificaciones.map((n) => n['mensaje'] as String).toList();
      mostrarNotificacionesSecuenciales(context, mensajes);
    } catch (e) {
      print("Error al cargar notificaciones anteriores: $e");
    }
  }

  void escucharNotificaciones(String adminId) {
    try {
      final stream = supabase
          .from('notificaciones')
          .stream(primaryKey: ['id'])
          .eq('admin_id', adminId);

      stream.listen((List<Map<String, dynamic>> data) {
        if (data.isNotEmpty) {
          final nuevaNotificacion = data.last;

          if (!notificaciones.any((n) => n['id'] == nuevaNotificacion['id'])) {
            setState(() {
              notificaciones.add(nuevaNotificacion);
            });

            print('Nueva notificación: ${nuevaNotificacion['mensaje']}');
            mostrarNotificacionesSecuenciales(context, [
              nuevaNotificacion['mensaje'],
            ]);
          }
        }
      });
    } catch (e) {
      print("Error al escuchar notificaciones: $e");
    }
  }

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
          colors: [Colors.brown.shade700, colorsv.colorAppbar],
        ),
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
                "Administrador",
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
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white, size: 30),
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                ),
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
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
            _buildButton("⚙️ Gestion de Actividades", _onGestionActividades),
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
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => VistaLogin()),
              );
            },
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
              minimumSize: Size(double.infinity, 75),
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
        builder: (context) => VistaInversiones(usuario: widget.usuario),
      ),
    );
  }

  void _onPrestacionesPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaPrestamos(usuario: widget.usuario),
      ),
    );
  }

  void _onSegurosPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaSeguros(usuario: widget.usuario),
      ),
    );
  }

  void _onGestionActividades() {
    _mostrarDialogoSolicitudes();
    Controlador.borrarNotificaciones("28dc2001-518f-4cc0-9190-0ecd3f1c0ead");
  }

  void _mostrarDialogoSolicitudes() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown.shade100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Gestión de Solicitudes",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.brown.shade800,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogButton(
                "Solicitudes de Préstamos",
                _onSolicitudesPrestamosPressed,
              ),
              _buildDialogButton(
                "Solicitudes de Seguros",
                _onSolicitudesSegurosPressed,
              ),
              _buildDialogButton(
                "Solicitudes de Inversiones",
                _onSolicitudesInversionesPressed,
              ),
              _buildDialogButton(
                "Gestión de Empleados",
                _onGestionEmpleadosPressed,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cerrar",
                style: TextStyle(color: Colors.brown.shade800),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber.shade700,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _onSolicitudesPrestamosPressed() {
    // Acción para solicitudes de préstamos
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VistaReportePrestamos()),
    );
  }

  void _onSolicitudesSegurosPressed() {
    // Acción para solicitudes de seguros
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VistaReporteSeguros()),
    );
  }

  void _onSolicitudesInversionesPressed() {
    // Acción para solicitudes de inversiones
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VistaReporteInversiones()),
    );
  }

  void _onGestionEmpleadosPressed() {
    // Acción para gestión de empleados
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VistaReporteUsuarios()),
    );
  }
}
