import 'package:aplicacionbancaria/Controlador/Controlador_DatosCliente.dart';
import 'package:aplicacionbancaria/Modelo/Usuario.dart';
import 'package:flutter/material.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Prestamo.dart';
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

  const VistaSolicitudPrestamo({
    super.key,
    required this.prestamo, required Usuario usuario,
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
                  // Contenedor izquierdo: Información del préstamo
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
                          const SizedBox(height: 16),
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
                            "Al adquirir este préstamo, recibirás un monto de \$${widget.prestamo.monto.toStringAsFixed(2)}, que podrás pagar en ${widget.prestamo.meses} meses. La tasa de interés es del ${widget.prestamo.tasaInteres * 100}% mensual, y los pagos se realizan cada día ${widget.prestamo.diasPago} de mes.",
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
                                                Text("Género: ${selectedCliente!.genero}"),
                                                Text("Fecha de Nacimiento: ${selectedCliente!.fechaNacimiento.day}/${selectedCliente!.fechaNacimiento.month}/${selectedCliente!.fechaNacimiento.year}"),
                                                Text("Identificación Oficial: ${selectedCliente!.identificacionOficial}"),
                                                if (selectedCliente!.rfc != null) Text("RFC: ${selectedCliente!.rfc}"),
                                                Text("Estado Civil: ${selectedCliente!.estadoCivil}"),
                                                Text("Nacionalidad: ${selectedCliente!.nacionalidad}"),
                                                Text("Dirección: ${selectedCliente!.direccionCompleta}"),
                                                Text("Teléfono: ${selectedCliente!.telefono}"),
                                                Text("Correo Electrónico: ${selectedCliente!.correoElectronico}"),
                                                Text("Ocupación: ${selectedCliente!.ocupacion}"),
                                                Text("Empresa: ${selectedCliente!.empresa}"),
                                                Text("Dirección de la Empresa: ${selectedCliente!.direccionEmpresa}"),
                                                Text("Teléfono de la Empresa: ${selectedCliente!.telefonoEmpresa}"),
                                                Text("Ingresos Mensuales: \$${selectedCliente!.ingresosMensuales.toStringAsFixed(2)}"),
                                                Text("Fuente de Ingresos: ${selectedCliente!.fuenteIngresos}"),
                                                Text("¿Tiene Crédito?: ${selectedCliente!.tieneCredito ? 'Sí' : 'No'}"),
                                                Text("¿Tiene Seguro?: ${selectedCliente!.tieneSeguro ? 'Sí' : 'No'}"),
                                                Text("¿Tiene Préstamo?: ${selectedCliente!.tienePrestamo ? 'Sí' : 'No'}"),
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
                                  child: Text("Mas Detalles"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Acción para hacer la solicitud del préstamo
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Solicitud de Préstamo"),
                                          content: Text(
                                            "¿Desea realizar la solicitud del préstamo para el cliente ${selectedCliente!.nombreCompleto}?",
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
                                                // Aquí puedes manejar la lógica para guardar la solicitud
                                                ControladorNotificacion.enviarNotificacion('2d0c779e-b9f0-4cc5-9316-d74ea14a43cb', '28dc2001-518f-4cc0-9190-0ecd3f1c0ead', 'Nuevo mensaje recibido');
                                                 
                                                 

                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Solicitud de préstamo realizada exitosamente."),
                                                  ),
                                                );
                                              },
                                              child: Text("Aceptar"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
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