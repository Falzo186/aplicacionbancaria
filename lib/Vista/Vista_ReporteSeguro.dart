import 'package:aplicacionbancaria/Controlador/Controlador_Seguros.dart';
import 'package:flutter/material.dart';
import '../Controlador/Controlador_DatosCliente.dart';
import '../Controlador/Controlador_Reportes.dart';
import '../Modelo/ReporteSolicitud.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Seguro.dart';

final Color colorAppbar = Color(0xFF472F2F);
final Color colorBackground = Color(0xFFB1ACAC);
final Color colorCard = Color(0xFFEDECEC);
final Color colorTexto = Color(0xFF140A0A);
final Color colorBotonAceptar = Color(0xFF138A43);
final Color colorBotonRechazar = Colors.redAccent;

class VistaReporteSeguros extends StatefulWidget {
  const VistaReporteSeguros({super.key});

  @override
  _VistaReporteSegurosState createState() => _VistaReporteSegurosState();
}

class _VistaReporteSegurosState extends State<VistaReporteSeguros> {
  List<ReporteSolicitud> reportes = [];
  ReporteSolicitud? reporteSeleccionado;
  Cliente? clienteSeleccionado;
  Seguro? seguroSeleccionado;
  final controlador = ControladorReportes();
  final ControladorClientes = ControladorDatoscliente();
  final ControladorSeguro = ControladorSeguros();

  @override
  void initState() {
    super.initState();
    _cargarReportes();
  }

  void _cargarReportes() {
    controlador.obtenerReportesSegurosPendientes().then((data) {
      setState(() {
        reportes = data;
      });
    }).catchError((error) {
      debugPrint("Error al cargar reportes: $error");
    });
  }

  Future<void> seleccionarReporte(ReporteSolicitud reporte) async {
    setState(() {
      reporteSeleccionado = reporte;
    });
    final cliente = await ControladorClientes.buscarCliente(reporte.clienteId);
    final seguro = await ControladorSeguro.obtenerSeguro(reporte.idsolicitado);
    setState(() {
      clienteSeleccionado = cliente;
      seguroSeleccionado = seguro;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controlador.obtenerReportesSegurosPendientes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: colorBackground,
            appBar: AppBar(
              backgroundColor: colorAppbar,
              title: Text("Reporte de Solicitudes de Seguros"),
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
              title: Text("Reporte de Solicitudes de Seguros"),
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
              title: Text("Reporte de Solicitudes de Seguros"),
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
                                  "Información del Seguro",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const Divider(),
                                Text("Número de Póliza: ${seguroSeleccionado?.numeroPoliza ?? 'Cargando...'}"),
                                Text("Tipo de Seguro: ${seguroSeleccionado?.tipoSeguro ?? 'Cargando...'}"),
                                Text("Monto de Cobertura: \$${seguroSeleccionado?.montoCobertura.toStringAsFixed(2) ?? 'Cargando...'}"),
                                Text("Costo Total: \$${seguroSeleccionado?.costoTotal.toStringAsFixed(2) ?? 'Cargando...'}"),
                                Text("Pago Mensual: \$${seguroSeleccionado?.pagoMensual.toStringAsFixed(2) ?? 'Cargando...'}"),
                                Text("Fecha de Inicio: ${seguroSeleccionado?.fechaInicio ?? 'Cargando...'}"),
                                Text("Fecha de Vencimiento: ${seguroSeleccionado?.fechaVencimiento ?? 'Cargando...'}"),
                                Text("Estado: ${seguroSeleccionado?.estado ?? 'Cargando...'}"),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
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
                                  Text("ID Seguro: ${reporte.idsolicitado}"),
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