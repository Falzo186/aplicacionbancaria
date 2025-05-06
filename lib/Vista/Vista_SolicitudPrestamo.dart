import 'dart:math';
import 'package:aplicacionbancaria/Controlador/Controlador_Estadistica.dart';
import 'package:flutter/material.dart';
import 'package:aplicacionbancaria/Modelo/Cliente.dart';
import 'package:aplicacionbancaria/Modelo/Prestamo.dart';
import 'package:aplicacionbancaria/Modelo/ReporteSolicitud.dart';
import 'package:intl/intl.dart';
import '../Controlador/Controlador_DatosCliente.dart';
import '../Controlador/Controlador_Reportes.dart';
import '../Modelo/Empleado.dart';
import '../Modelo/Estadistica.dart';
import '../Modelo/Usuario.dart';
import '../SistemaNotificaciones/Controlado_Notificaciones.dart';

final Color colorAppbar = Color(0xFF472F2F);
final Color colorBackground = Color(0xFFB1ACAC);
final Color colorFondo = Color(0xFF676464);
final Color colorCard = Color(0xFFEDECEC);
final Color colorTexto = Color(0xFF140A0A);
final Color colorBoton = Color(0xFFA08181);
final Color colorCircle = Color(0xFF138A43);


class VistaSolicitudPrestamo extends StatefulWidget {
  final Prestamo prestamo;
  final Usuario usuario;
  final Empleado empleado;

  const VistaSolicitudPrestamo({
    super.key,
    required this.prestamo,
    required this.usuario,
    required this.empleado,
  });

  @override
  _VistaSolicitudPrestamoState createState() => _VistaSolicitudPrestamoState();
}

class _VistaSolicitudPrestamoState extends State<VistaSolicitudPrestamo> {
  final TextEditingController _searchController = TextEditingController();
  List<Cliente> clientes = [];
  List<Cliente> filteredClientes = [];
  Cliente? selectedCliente;
   
  final controlador = ControladorDatoscliente();
  final ControladorNotificacion = ControladorNotificaciones();
  final ControladorReporte = ControladorReportes();
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
      tipoSolicitud: "Prestamo",
      clienteId: selectedCliente!.numeroCuenta,
      clienteNombre: selectedCliente!.nombreCompleto,
      idsolicitado: widget.prestamo.numeroPrestamo,
      estado: "Pendiente",
      fechaSolicitud: DateTime.now(),
    );

    ControladorReporte.subirReporte(reporte);
    print("Reporte de Solicitud de Crédito:\n${reporte.toString()}");
  }

  void _enviarNotificacionSolicitud() {
    if (selectedCliente == null) return;

    final DateFormat formato = DateFormat('yyyy-MM-dd hh:mm a');
    final String fechaFormateada = formato.format(DateTime.now());

    final mensaje = "Solicitud de Crédito de: ${widget.empleado.nombreEmpleado} "
        "para el cliente ${selectedCliente!.nombreCompleto}\n"
        "$fechaFormateada";

    ControladorNotificacion.enviarNotificacion(
      '2d0c779e-b9f0-4cc5-9316-d74ea14a43cb',
      '28dc2001-518f-4cc0-9190-0ecd3f1c0ead',
      mensaje,
    );

    print("Notificación enviada: $mensaje");
  }

  void _verificarCuentaCredito() {
    if (selectedCliente == null) return;

    final tieneCuentaCredito = selectedCliente!.tieneCredito;

    if (!tieneCuentaCredito) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Solicitud de Crédito"),
            content: Text(
              "El cliente ${selectedCliente!.nombreCompleto} no tiene una cuenta de crédito. ¿Desea realizar una solicitud de crédito?",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  _crearReporteSolicitud();
                  _enviarNotificacionSolicitud();

                  Navigator.of(context).pop(); // Regreso automático
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Solicitud de crédito realizada exitosamente."),
                    ),
                  );
                },
                child: Text("Aceptar"),
              ),
            ],
          );
        },
      );
    } else {
      _crearReporteSolicitud();
      _enviarNotificacionSolicitud();
      agregarEstadistica(); // Agregar estadística

      Navigator.of(context).pop(); // Regreso automático
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Solicitud de préstamo realizada exitosamente."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text(
          "Solicitud de Préstamo",
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
                            "Información del Préstamo",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Text(
                            "Número de Préstamo: ${widget.prestamo.numeroPrestamo}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Monto: \$${widget.prestamo.monto.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Meses: ${widget.prestamo.meses}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Tasa de Interés: ${widget.prestamo.tasaInteres}%",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Fecha de Inicio: ${widget.prestamo.fechaInicio.day}/${widget.prestamo.fechaInicio.month}/${widget.prestamo.fechaInicio.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Fecha de Pago: ${widget.prestamo.fechapago.day}/${widget.prestamo.fechapago.month}/${widget.prestamo.fechapago.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Estado: ${widget.prestamo.estado}",
                            style: TextStyle(fontSize: 16),
                          ),
                            Text(
                            "🏦 Informacion Detallada",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Text(
                            "📌 Número de Préstamo: ${widget.prestamo.numeroPrestamo}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "💰 Monto Disponible: Hasta \$${widget.prestamo.monto.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "📅 Plazo Flexible: Hasta ${widget.prestamo.meses} meses",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "📊 Tasa de Interés Competitiva: Solo ${widget.prestamo.tasaInteres * 100}% mensual",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "📅 Fechas Clave",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Text(
                            "📆 Fecha de Inicio: ${widget.prestamo.fechaInicio.day}/${widget.prestamo.fechaInicio.month}/${widget.prestamo.fechaInicio.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "📆 Primer Pago: ${widget.prestamo.fechapago.day}/${widget.prestamo.fechapago.month}/${widget.prestamo.fechapago.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "💳 Día de Pago Mensual: Cada día ${widget.prestamo.diasPago} de mes",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "📌 ¿Cómo funciona este préstamo?",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Text(
                            "Al adquirir este préstamo, recibirás un monto de \$${widget.prestamo.monto.toStringAsFixed(2)}, que podrás pagar en ${widget.prestamo.meses} meses. La tasa de interés es del ${widget.prestamo.tasaInteres}% mensual, y los pagos se realizan cada día ${widget.prestamo.diasPago} de mes.",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Si realizas tus pagos puntuales, no tendrás cargos adicionales, pero en caso de atraso, se aplicará un interés del 25% mensual sobre el saldo vencido.",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Detalles del Cliente"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text("Nombre Completo: ${selectedCliente!.nombreCompleto}"),
                                                Text("Número de Cuenta: ${selectedCliente!.numeroCuenta}"),
                                                Text("Teléfono: ${selectedCliente!.telefono}"),
                                                Text("Correo Electrónico: ${selectedCliente!.correoElectronico}"),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cerrar"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(141, 255, 174, 0),
                                  ),
                                  child: Text("Más Detalles"),
                                ),
                                ElevatedButton(
                                  onPressed: _verificarCuentaCredito,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: colorCircle,
                                  ),
                                  child: Text("Hacer Solicitud"),
                                ),
                              ],
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
