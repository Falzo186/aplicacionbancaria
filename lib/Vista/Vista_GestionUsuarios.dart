import 'package:aplicacionbancaria/Controlador/Controlador_Login.dart';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:aplicacionbancaria/Vista/Vista_AgregarEmpleados.dart';
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
  List<ReporteSolicitud> reportes =
      []; // Lista de reportes del usuario seleccionado
  Empleado? usuarioSeleccionado; // Usuario seleccionado
  Estadistica? estadisticaSeleccionada; // Estadística del usuario seleccionado
  final Controlador = ControladorLogin();
  final ControladorReporte = ControladorReportes();
  final ControladorEstadisticas = ControladorEstadistica();

  DateTime? fechaInicio; // Fecha de inicio para el filtro
  DateTime? fechaFin; // Fecha de fin para el filtro

  @override
  void initState() {
    super.initState();
    _cargarUsuarios(); // Cargar la lista de usuarios al iniciar
  }

  Future<void> _cargarReportes(String idEmpleado) async {
    try {
      final reportesObtenidos =
          await ControladorReporte.obtenerReportesPorUsuario(idEmpleado);
      setState(() {
        reportes = reportesObtenidos;
      });
    } catch (error) {
      print("Error al cargar reportes: $error");
    }
  }

  Future<void> _cargarEstadistica(String idEmpleado) async {
    try {
      final estadistica =
          await ControladorEstadisticas.obtenerEstadisticaPorId(idEmpleado);
      setState(() {
        estadisticaSeleccionada = estadistica;
      });
    } catch (error) {
      print("Error al cargar estadística: $error");
    }
  }

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

  List<ReporteSolicitud> _filtrarReportesPorFecha() {
    if (fechaInicio == null || fechaFin == null) {
      return reportes;
    }
    return reportes.where((reporte) {
      return reporte.fechaSolicitud.isAfter(fechaInicio!) &&
          reporte.fechaSolicitud.isBefore(fechaFin!);
    }).toList();
  }

  Future<void> _seleccionarFechaInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaInicio ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != fechaInicio) {
      setState(() {
        fechaInicio = picked;
      });
    }
  }

  Future<void> _seleccionarFechaFin(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechaFin ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != fechaFin) {
      setState(() {
        fechaFin = picked;
      });
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
                    return Card(
                      color: colorsv.colorCard,
                      child: ListTile(
                        title: Text(empleado.id),
                        trailing: Icon(Icons.person),
                        leading: Icon(Icons.account_circle),
                        subtitle: Text(
                          "Cuenta: ${empleado.nombreEmpleado}\nPuesto: ${empleado.puestoTrabajo}",
                        ),
                        onTap: () {
                          setState(() {
                            usuarioSeleccionado = empleado;
                            reportes.clear();
                            estadisticaSeleccionada = null;
                          });
                          _cargarReportes(empleado.id);
                          _cargarEstadistica(empleado.id);
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
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => _seleccionarFechaInicio(context),
                                child: Text(
                                  fechaInicio == null
                                      ? "Seleccionar Fecha Inicio"
                                      : "Inicio: ${_formatearFecha(fechaInicio!)}",
                                ),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                onPressed: () => _seleccionarFechaFin(context),
                                child: Text(
                                  fechaFin == null
                                      ? "Seleccionar Fecha Fin"
                                      : "Fin: ${_formatearFecha(fechaFin!)}",
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          if (estadisticaSeleccionada != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Row(
                                children: [
                                  Text(
                                    "Estadísticas: ",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Aprobadas: ${estadisticaSeleccionada!.SolucionesAprobadas}",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Rechazadas: ${estadisticaSeleccionada!.SolucionesRechazadas}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Pendientes: ${estadisticaSeleccionada!.SolucionesPendientes}",
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 88, 74, 73),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Porcentaje Aprobadas: ${estadisticaSeleccionada!.porcentajeAprobadas.toStringAsFixed(2)}%",
                                    style: TextStyle(
                                      color: estadisticaSeleccionada!
                                                  .porcentajeAprobadas >=
                                              70
                                          ? Colors.green
                                          : estadisticaSeleccionada!
                                                      .porcentajeAprobadas >=
                                                  40
                                              ? Colors.yellow
                                              : Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filtrarReportesPorFecha().length,
                              itemBuilder: (context, index) {
                                final reporte = _filtrarReportesPorFecha()[index];
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VistaFormularioEmpleado(),
            ),
          ).then((_) {
            _cargarUsuarios(); // Recargar la lista de usuarios después de agregar
          });
        },
        backgroundColor: colorsv.colorAppbar,
        child: Icon(Icons.add, color: Colors.white),
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

