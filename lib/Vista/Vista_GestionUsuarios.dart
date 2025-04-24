import 'package:aplicacionbancaria/Controlador/Controlador_Login.dart';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Usuario.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:flutter/material.dart';
import '../Controlador/Controlador_Reportes.dart';
import '../Modelo/ReporteSolicitud.dart';

class VistaReporteUsuarios extends StatefulWidget {
  const VistaReporteUsuarios({super.key});

  @override
  _VistaReporteUsuariosState createState() => _VistaReporteUsuariosState();
}

class _VistaReporteUsuariosState extends State<VistaReporteUsuarios> {
  VentanaModelo colorsv = VentanaModelo();
  List<Usuario> usuarios = []; // Lista de usuarios
  List<ReporteSolicitud> reportes =
      []; // Lista de reportes del usuario seleccionado
  Usuario? usuarioSeleccionado; // Usuario seleccionado
  final Controlador = ControladorLogin();
  final ControladorReporte = ControladorReportes();

  @override
  void initState() {
    super.initState();
    _cargarUsuarios(); // Cargar la lista de usuarios al iniciar
  }

  // Método para cargar la lista de usuarios (simulado)
  void _cargarUsuarios() {
    // Aquí puedes reemplazar con la lógica para obtener usuarios desde la base de datos
    Controlador.obtenerUsuariosEscritorio()
        .then((usuarios) {
          setState(() {
            this.usuarios = usuarios;
          });
        })
        .catchError((error) {
          // Manejo de errores al cargar usuarios
          print("Error al cargar usuarios: $error");
        });
  }

  // Método para cargar los reportes del usuario seleccionado
  Future<void> _cargarReportes(String nombreUsuario) async {
    // Aquí puedes reemplazar con la lógica para obtener reportes desde la base de datos
    try {
      print("Cargando reportes para el usuario: $nombreUsuario");
      final reportesObtenidos =
          await ControladorReporte.obtenerReportesPorUsuario(nombreUsuario);
      setState(() {
        reportes = reportesObtenidos;
      });
    } catch (error) {
      // Manejo de errores al cargar reportes
      print("Error al cargar reportes: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsv.colorBackground,
      appBar: CustomAppBar(
        backgroundColor: colorsv.colorAppbar,
        title: Text(
          "Reporte de Usuarios",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorsv.colorTexto2),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Contenedor izquierdo: Lista de usuarios
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: usuarios.length,
                  itemBuilder: (context, index) {
                    final usuario = usuarios[index];
                    return Card(
                      color: colorsv.colorCard,
                      child: ListTile(
                        title: Text(usuario.nombre),
                        subtitle: Text("Cuenta: ${usuario.nombreUsuario}"),
                        onTap: () {
                          setState(() {
                            usuarioSeleccionado =
                                usuario; // Guarda el usuario seleccionado
                            reportes
                                .clear(); // Limpia la lista de reportes mientras carga
                          });

                          // Luego, carga los reportes y actualiza el estado
                          _cargarReportes(usuario.nombreUsuario);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Contenedor derecho: Lista de reportes del usuario seleccionado
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                child:
                    usuarioSeleccionado == null
                        ? Center(
                          child: Text(
                            "Seleccione un usuario para ver los reportes",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reportes de ${usuarioSeleccionado!.nombre}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            Expanded(
                              child: ListView.builder(
                                itemCount: reportes.length,
                                itemBuilder: (context, index) {
                                  final reporte = reportes[index];
                                  return Card(
                                    color: colorsv.colorCard,
                                    child: ListTile(
                                      title: Text(reporte.tipoSolicitud),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "ID Solicitud: ${reporte.idSolicitud}",
                                          ),
                                          Text("Estado: ${reporte.estado}"),
                                        ],
                                      ),
                                      onTap: () {
                                        // Acción al seleccionar un reporte
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Detalles del Reporte",
                                              ),
                                              content: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    "ID Solicitud: ${reporte.idSolicitud}",
                                                  ),
                                                  Text(
                                                    "Tipo de Solicitud: ${reporte.tipoSolicitud}",
                                                  ),
                                                  Text(
                                                    "Cliente: ${reporte.clienteNombre}",
                                                  ),
                                                  Text(
                                                    "Estado: ${reporte.estado}",
                                                  ),
                                                  Text(
                                                    "Fecha de Solicitud: ${_formatearFecha(reporte.fechaSolicitud)}",
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () =>
                                                          Navigator.of(
                                                            context,
                                                          ).pop(),
                                                  child: Text("Cerrar"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final anio = fecha.year.toString();
    final hora = fecha.hour % 12 == 0 ? 12 : fecha.hour % 12;
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final amPm = fecha.hour >= 12 ? 'PM' : 'AM';

    return '$dia/$mes/$anio $hora:$minutos $amPm';
  }
}
