import 'dart:math';

import 'package:aplicacionbancaria/Controlador/Controlador_DatosCliente.dart';
import 'package:aplicacionbancaria/Controlador/Controlador_Reportes.dart';
import 'package:aplicacionbancaria/Modelo/Estadistica.dart';
import 'package:aplicacionbancaria/Modelo/Usuario.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Controlador/Controlador_Estadistica.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Empleado.dart';
import '../Modelo/Inversion.dart';
import '../Modelo/ReporteSolicitud.dart';
import '../SistemaNotificaciones/Controlado_Notificaciones.dart';

final Color colorAppbar = Color(0xFF472F2F);
final Color colorBackground = Color(0xFFB1ACAC);
final Color colorFondo = Color(0xFF676464);
final Color colorCard = Color(0xFFEDECEC);
final Color colorTexto = Color(0xFF140A0A);
final Color colorBoton = Color(0xFFA08181);
final Color colorCircle = Color(0xFF138A43);

class VistaSolicitudInversion extends StatefulWidget {
  final Inversion inversion;
  final Usuario usuario;
  final Empleado empleado;

  const VistaSolicitudInversion({
    super.key,
    required this.usuario,
    required this.inversion,
    required this.empleado,
  });

  @override
  _VistaSolicitudInversionState createState() => _VistaSolicitudInversionState();
}

class _VistaSolicitudInversionState extends State<VistaSolicitudInversion> {
  final TextEditingController _searchController = TextEditingController();
  List<Cliente> clientes = [];
  List<Cliente> filteredClientes = [];
  Cliente? selectedCliente;
  final controlador = ControladorDatoscliente();
  final ControladorReporte = ControladorReportes();
  final ControladorNotificacion = ControladorNotificaciones();
  final controladorestadistica= ControladorEstadistica();
  Estadistica? estadistica;

  @override
  void initState() {
    super.initState();
    _loadClientes();
  }

  Future<void> _loadClientes() async {
    final fetchedClientes = await controlador.obtenerClientes();
    setState(() {
      clientes = fetchedClientes;
      filteredClientes = fetchedClientes;
    });
  }

  void _filterClientes(String query) {
    setState(() {
      filteredClientes = clientes.where((cliente) {
        final nombreLower = cliente.nombreCompleto.toLowerCase();
        final numeroCuentaLower = cliente.numeroCuenta.toLowerCase();
        final searchLower = query.toLowerCase();

        return nombreLower.contains(searchLower) || numeroCuentaLower.contains(searchLower);
      }).toList();
    });
  }




Future<void> agregarEstadistica() async {
    try {
      estadistica = await controladorestadistica.obtenerEstadisticaPorId(widget.usuario.idempleado);

      if (estadistica != null) {
        setState(() {
          estadistica!.SolucionesPendientes += 1;
          estadistica!.numeroSolicitudes += 1;
        });
        await controladorestadistica.actualizarEstadistica(estadistica!);
      } else {
        print("No se encontró la estadística para el usuario ${widget.usuario.idempleado}.");
      }
    } catch (e) {
      print("Error al actualizar la estadística: $e");
    }
  }

  void _crearReporteSolicitud() {
    if (selectedCliente == null) return;

    final reporte = ReporteSolicitud(
      idSolicitud: Random().nextInt(100000).toString(),
      usuarioId: widget.usuario.idempleado,
      usuarioNombre: widget.empleado.nombreEmpleado,
      tipoSolicitud: "Inversion",
      clienteId: selectedCliente!.numeroCuenta,
      clienteNombre: selectedCliente!.nombreCompleto,
      idsolicitado: widget.inversion.numeroInversion,
      estado: "Pendiente",
      fechaSolicitud: DateTime.now(),
    );
     agregarEstadistica();
    ControladorReporte.subirReporte(reporte);

    print("Reporte de Solicitud:\n${reporte.toString()}");
  }

  void _enviarNotificacionSolicitud() {
    if (selectedCliente == null) return;

    final DateFormat formato = DateFormat('yyyy-MM-dd hh:mm a');
    final String fechaFormateada = formato.format(DateTime.now());

    final mensaje = "Solicitud de Inversión de: ${widget.usuario.nombreUsuario} "
        "tipo: Inversión a ${selectedCliente!.nombreCompleto}\n"
        "$fechaFormateada";

    ControladorNotificacion.enviarNotificacion(
      '2d0c779e-b9f0-4cc5-9316-d74ea14a43cb',
      '28dc2001-518f-4cc0-9190-0ecd3f1c0ead',
      mensaje,
    );

    print("Notificación enviada: $mensaje");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Solicitud de Inversión",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: clientes.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contenedor izquierdo: Información de la inversión
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "📈 Información de la Inversión",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Text(
                            "📌 Número de Inversión: ${widget.inversion.numeroInversion}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "💰 Monto Invertido: \$${widget.inversion.monto.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "📊 Ganancia Esperada: \$${widget.inversion.gananciaEsperada.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "⏳ Plazo: ${widget.inversion.tiempoMeses} meses",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "📉 Tasa de Interés: ${widget.inversion.tasaInteres}%",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "📅 Fecha de Inicio: ${widget.inversion.fechaInicio.day}/${widget.inversion.fechaInicio.month}/${widget.inversion.fechaInicio.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "🏁 Fecha de Vencimiento: ${widget.inversion.fechaVencimiento.day}/${widget.inversion.fechaVencimiento.month}/${widget.inversion.fechaVencimiento.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "📍 Estado: ${widget.inversion.estado}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "📜 Detalles sobre su inversión",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Text(
                            "📝 Una inversión de \$${widget.inversion.monto.toStringAsFixed(2)} con una tasa de interés del ${widget.inversion.tasaInteres}% anual. Esto significa que su dinero estará generando ganancias a lo largo de un período de ${widget.inversion.tiempoMeses} meses, permitiéndole obtener un rendimiento adicional al finalizar el plazo.",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "💡 ¿Cómo funciona su inversión?",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "💹 Su capital crecerá gracias al interés generado. En este caso, el interés anual es del ${widget.inversion.tasaInteres}%, lo que significa que al final del período su ganancia estimada será de 💵 \$${widget.inversion.gananciaEsperada.toStringAsFixed(2)}, sumando un total de 💰 \$${(widget.inversion.monto + widget.inversion.gananciaEsperada).toStringAsFixed(2)}.",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "⏳ ¿Cuándo podrá retirar su dinero?",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "📆 Fecha de inicio: ${widget.inversion.fechaInicio.day}/${widget.inversion.fechaInicio.month}/${widget.inversion.fechaInicio.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "🏁 Fecha de vencimiento: ${widget.inversion.fechaVencimiento.day}/${widget.inversion.fechaVencimiento.month}/${widget.inversion.fechaVencimiento.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "📍 Estado actual: ${widget.inversion.estado}",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "💼 Una vez que su inversión llegue a la fecha de vencimiento, podrá retirar el total de su dinero inicial más las ganancias generadas.",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Contenedor derecho: Búsqueda y selección de cliente
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Buscar Cliente",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Buscar por nombre o número de cuenta",
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                            onChanged: _filterClientes,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredClientes.length,
                              itemBuilder: (context, index) {
                                final cliente = filteredClientes[index];
                                return ListTile(
                                  title: Text(cliente.nombreCompleto),
                                  subtitle: Text("Cuenta: ${cliente.numeroCuenta}"),
                                  onTap: () {
                                    setState(() {
                                      selectedCliente = cliente;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          if (selectedCliente != null) ...[
                            const Divider(),
                            Text(
                              "Cliente Seleccionado",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text("Nombre: ${selectedCliente!.nombreCompleto}"),
                            Text("Cuenta: ${selectedCliente!.numeroCuenta}"),
                            Text("Teléfono: ${selectedCliente!.telefono}"),
                            Text("Correo: ${selectedCliente!.correoElectronico}"),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _crearReporteSolicitud();
                                _enviarNotificacionSolicitud();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Solicitud de inversión procesada."),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorCircle,
                              ),
                              child: Text("Procesar Solicitud"),
                            ),
                          ],
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
