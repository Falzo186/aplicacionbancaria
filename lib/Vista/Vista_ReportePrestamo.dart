import 'package:aplicacionbancaria/Controlador/Controlador_Prestamos.dart';
import 'package:flutter/material.dart';
import '../Controlador/Controlador_DatosCliente.dart';
import '../Controlador/Controlador_Reportes.dart';
import '../Modelo/ReporteSolicitud.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Prestamo.dart';


final Color colorAppbar = Color(0xFF472F2F);
final Color colorBackground = Color(0xFFB1ACAC);
final Color colorCard = Color(0xFFEDECEC);
final Color colorTexto = Color(0xFF140A0A);
final Color colorBotonAceptar = Color(0xFF138A43);
final Color colorBotonRechazar = Colors.redAccent;

class VistaReportePrestamos extends StatefulWidget {
  const VistaReportePrestamos({super.key});

  @override
  _VistaReportePrestamosState createState() => _VistaReportePrestamosState();
}

class _VistaReportePrestamosState extends State<VistaReportePrestamos> {
  List<ReporteSolicitud> reportes = [];
  ReporteSolicitud? reporteSeleccionado;
  Cliente? clienteSeleccionado;
  Prestamo? prestamoSeleccionado;
  final controlador = ControladorReportes();
  final ControladorClientes = ControladorDatoscliente();
  final ControladorPrestamo = ControladorPrestamos();

  @override
  @override
  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  void _cargarReportes() {
    controlador.obtenerReportesPrestamoPendientes().then((data) {
      setState(() {
        reportes = data as List<ReporteSolicitud>;
      });
    }).catchError((error) {
      // Manejo de errores si es necesario
      debugPrint("Error al cargar reportes: $error");
    });
  }

  

  Future<void> seleccionarReporte(ReporteSolicitud reporte) async {
    setState(() {
      reporteSeleccionado = reporte;
    });
    final cliente = await ControladorClientes.buscarCliente(reporte.clienteId) as Cliente?;
    final prestamo = await ControladorPrestamo.obtenerPrestamo(reporte.idsolicitado) as Prestamo?;
    setState(() {
      clienteSeleccionado = cliente;
      prestamoSeleccionado = prestamo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controlador.obtenerReportesPrestamoPendientes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: colorBackground,
            appBar: AppBar(
              backgroundColor: colorAppbar,
              title: Text("Reporte de Solicitudes de Préstamos"),
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: colorBackground,
            appBar: AppBar(
              backgroundColor: colorAppbar,
              title: Text("Reporte de Solicitudes de Préstamos"),
            ),
            body: Center(
              child: Text("Error al cargar los reportes"),
            ),
          );
        } else {
          reportes = snapshot.data as List<ReporteSolicitud>;
          return Scaffold(
            backgroundColor: colorBackground,
            appBar: AppBar(
              backgroundColor: colorAppbar,
              title: Text("Reporte de Solicitudes de Préstamos"),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Contenedor izquierdo: Información detallada
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: reporteSeleccionado == null
                          ? Center(
                              child: Text(
                                "Seleccione un reporte para ver los detalles",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Información del Reporte",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Text("ID Solicitud: ${reporteSeleccionado!.idSolicitud}"),
                                Text("Usuario: ${reporteSeleccionado!.usuarioNombre}"),
                                Text("Tipo de Solicitud: ${reporteSeleccionado!.tipoSolicitud}"),
                                Text("Estado: ${reporteSeleccionado!.estado}"),
                                Text("Fecha de Solicitud: ${reporteSeleccionado!.fechaSolicitud}"),
                                const SizedBox(height: 16),
                                Text(
                                  "Información del Cliente",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Text("Nombre: ${clienteSeleccionado?.nombreCompleto ?? 'Cargando...'}"),
                                Text("Número de Cuenta: ${clienteSeleccionado?.numeroCuenta ?? 'Cargando...'}"),
                                Text("Teléfono: ${clienteSeleccionado?.telefono ?? 'Cargando...'}"),
                                Text("Correo: ${clienteSeleccionado?.correoElectronico ?? 'Cargando...'}"),
                                const SizedBox(height: 16),
                                Text(
                                  "Información del Préstamo",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Text("Número de Préstamo: ${prestamoSeleccionado?.numeroPrestamo ?? 'Cargando...'}"),
                                Text("Monto: \$${prestamoSeleccionado?.monto.toStringAsFixed(2) ?? 'Cargando...'}"),
                                Text("Meses: ${prestamoSeleccionado?.meses ?? 'Cargando...'}"),
                                Text("Tasa de Interés: ${prestamoSeleccionado?.tasaInteres ?? 'Cargando...'}%"),
                                Text("Fecha de Inicio: ${prestamoSeleccionado?.fechaInicio ?? 'Cargando...'}"),
                                Text("Fecha de Pago: ${prestamoSeleccionado?.fechapago ?? 'Cargando...'}"),
                                Text("Estado: ${prestamoSeleccionado?.estado ?? 'Cargando...'}"),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Acción para aceptar la solicitud
                                        setState(() {
                                          reporteSeleccionado!.estado = "Aprobada";
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Solicitud aprobada")),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorBotonAceptar,
                                      ),
                                      child: Text("Aceptar"),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Acción para rechazar la solicitud
                                        setState(() {
                                          reporteSeleccionado!.estado = "Rechazada";
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Solicitud rechazada")),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colorBotonRechazar,
                                      ),
                                      child: Text("Rechazar"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Contenedor derecho: Lista de reportes
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.builder(
                        itemCount: reportes.length,
                        itemBuilder: (context, index) {
                          final reporte = reportes[index];
                          return Card(
                            color: colorCard,
                            child: ListTile(
                              title: Text(reporte.usuarioNombre),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID Préstamo: ${reporte.idsolicitado}"),
                                  Text("Cliente: ${reporte.clienteNombre}"),
                                ],
                              ),
                              onTap: () => seleccionarReporte(reporte),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}