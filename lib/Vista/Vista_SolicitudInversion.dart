import 'package:aplicacionbancaria/Controlador/Controlador_DatosCliente.dart';
import 'package:flutter/material.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Inversion.dart';

final Color colorAppbar = Color(0xFF472F2F);
final Color colorBackground = Color(0xFFB1ACAC);
final Color colorFondo = Color(0xFF676464);
final Color colorCard = Color(0xFFEDECEC);
final Color colorTexto = Color(0xFF140A0A);
final Color colorBoton = Color(0xFFA08181);
final Color colorCircle = Color(0xFF138A43);

class VistaSolicitudInversion extends StatefulWidget {
  final Inversion inversion;

  const VistaSolicitudInversion({
    super.key,
    required this.inversion,
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
                          const SizedBox(height: 16),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Acción para ver los detalles bancarios del cliente
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Detalles Bancarios"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Nombre Completo:",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(selectedCliente!.nombreCompleto),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Número de Cuenta:",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(selectedCliente!.numeroCuenta),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Ocupacion:",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(selectedCliente!.ocupacion.toString()),
                                                Text(
                                                  "Ingreso:",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(selectedCliente!.ingresosMensuales.toString()),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Cuenta con credito?:",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(selectedCliente!.tieneCredito ? "Si" : "No"),
                                                SizedBox(height: 10),
                                                Text(
                                                  "Tiene Prestamo Activo?:",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                                Text(selectedCliente!.tienePrestamo ? "Si" : "No"),
                                                SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                "Cerrar",
                                                style: TextStyle(color: Colors.blue),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  child: Text("Detalles Bancarios"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Acción para hacer la solicitud de inversión
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Solicitud de Inversión"),
                                          content: Text(
                                            "¿Desea realizar la solicitud de inversión para el cliente ${selectedCliente!.nombreCompleto}?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        "Detalles del Cliente",
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                      ),
                                                      content: SingleChildScrollView(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              "Nombre Completo:",
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            Text(selectedCliente!.nombreCompleto),
                                                            SizedBox(height: 10),
                                                            Text(
                                                              "Número de Cuenta:",
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            Text(selectedCliente!.numeroCuenta),
                                                            SizedBox(height: 10),
                                                            Text(
                                                              "Teléfono:",
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            Text(selectedCliente!.telefono),
                                                            SizedBox(height: 10),
                                                            Text(
                                                              "Correo Electrónico:",
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            Text(selectedCliente!.correoElectronico),
                                                            SizedBox(height: 10),
                                                            Text(
                                                              "Dirección:",
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                            Text(selectedCliente!.direccionCompleta ?? "No disponible"),
                                                          ],
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(context).pop();
                                                          },
                                                          child: Text(
                                                            "Cerrar",
                                                            style: TextStyle(color: Colors.blue),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: Text("Mas Detalles"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Aquí puedes manejar la lógica para guardar la solicitud
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Solicitud de inversión realizada exitosamente."),
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