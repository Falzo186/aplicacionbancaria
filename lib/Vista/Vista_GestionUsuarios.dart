import 'package:aplicacionbancaria/Controlador/Controlador_Login.dart';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:flutter/material.dart';
import '../Controlador/Controlador_Estadistica.dart';
import '../Controlador/Controlador_Reportes.dart';
import '../Modelo/Empleado.dart';
import '../Modelo/Estadistica.dart';
import '../Modelo/ReporteSolicitud.dart';

class VistaReporteUsuarios extends StatefulWidget {
  final Empleado empleado;
  const VistaReporteUsuarios({super.key, required this.empleado});

  @override
  _VistaReporteUsuariosState createState() => _VistaReporteUsuariosState();
}

class _VistaReporteUsuariosState extends State<VistaReporteUsuarios> {
  VentanaModelo colorsv = VentanaModelo();
  List<Empleado> Empleados = []; // Lista de usuarios
  List<Estadistica> EstadisticasUsuarios = [];
  List<ReporteSolicitud> reportes =
      []; // Lista de reportes del usuario seleccionado
  Empleado? usuarioSeleccionado; // Usuario seleccionado
  final Controlador = ControladorLogin();
  final ControladorReporte = ControladorReportes();
  final ControladorEstadisticas = ControladorEstadistica();

  @override
  void initState() {
    super.initState();
    _cargarUsuarios(); // Cargar la lista de usuarios al iniciar
    _cargarEstadisticaUsuarios(); // Cargar las estadísticas al iniciar
  }

  // Método para cargar la lista de usuarios
  void _cargarUsuarios() {
    Controlador.obtenerUsuariosEscritorio()
        .then((usuarios) {
          setState(() {
            this.Empleados = usuarios;
          });
        })
        .catchError((error) {
          print("Error al cargar usuarios: $error");
        });
  }

  // Método para cargar las estadísticas de los usuarios
  Future<void> _cargarEstadisticaUsuarios() async {
    try {
      final estadisticas =
          await ControladorEstadisticas.obtenerTodasLasEstadisticas();
      setState(() {
        this.EstadisticasUsuarios = estadisticas;
      });
    } catch (error) {
      print("Error al cargar estadísticas: $error");
    }
  }

  // Método para obtener la estadística de un usuario específico
  Estadistica? _obtenerEstadisticaPorUsuario(String idUsuario) {
    return EstadisticasUsuarios.firstWhere(
        (estadistica) => estadistica.id == idUsuario,
        orElse: () => Estadistica(
              id: idUsuario,
              numeroSolicitudes: 0,
              SolucionesAprobadas: 0,
              SolucionesRechazadas: 0,
              SolucionesPendientes: 0,
            ));
        
  }

  Future<void> _cargarReportes(String idEmpleado) async {
    try {
      print("Cargando reportes para el usuario: $idEmpleado");
      final reportesObtenidos =
          await ControladorReporte.obtenerReportesPorUsuario(idEmpleado);
      setState(() {
        reportes = reportesObtenidos;
      });
    } catch (error) {
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
          "Reporte de Usuarios - ${widget.empleado.nombreEmpleado}",
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
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: Empleados.length,
                  itemBuilder: (context, index) {
                    final Empleado empleado = Empleados[index];
                    final estadistica =
                        _obtenerEstadisticaPorUsuario(empleado.id);
                    final estadisticaTexto = estadistica != null
                        ? "${estadistica.SolucionesAprobadas} de ${estadistica.numeroSolicitudes} solicitudes aprobadas"
                        : "Sin estadísticas disponibles";

                    return Card(
                      color: colorsv.colorCard,
                      child: ListTile(
                        title: Text(empleado.id),
                        trailing: Icon(Icons.person),
                        leading: Icon(Icons.account_circle),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Cuenta: ${empleado.nombreEmpleado}"),
                            Text(estadisticaTexto),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            usuarioSeleccionado = empleado;
                            reportes.clear();
                          });
                          _cargarReportes(empleado.id);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16.0),
                child: usuarioSeleccionado == null
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
                            "Reportes de ${usuarioSeleccionado!.nombreEmpleado}",
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
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
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

