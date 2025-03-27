import 'package:aplicacionbancaria/Controlador/Controlador_DatosCliente.dart';
import 'package:aplicacionbancaria/Modelo/Usuario.dart';
import 'package:flutter/material.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Seguro.dart';

final Color colorAppbar = Color(0xFF472F2F);
final Color colorBackground = Color(0xFFB1ACAC);
final Color colorFondo = Color(0xFF676464);
final Color colorCard = Color(0xFFEDECEC);
final Color colorTexto = Color(0xFF140A0A);
final Color colorBoton = Color(0xFFA08181);
final Color colorCircle = Color(0xFF138A43);

class VistaSolicitudSeguro extends StatefulWidget {
  final Seguro seguro;

  const VistaSolicitudSeguro({
    super.key,
    required this.seguro, required Usuario usuario,
  });

  @override
  _VistaSolicitudSeguroState createState() => _VistaSolicitudSeguroState();
}

class _VistaSolicitudSeguroState extends State<VistaSolicitudSeguro> {
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
          "Solicitud de Seguro",
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
                  // Contenedor izquierdo: Información del seguro
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
                            "Información del Seguro",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Text(
                            "Número de Póliza: ${widget.seguro.numeroPoliza}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Tipo de Seguro: ${widget.seguro.tipoSeguro}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Monto de Cobertura: \$${widget.seguro.montoCobertura.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Costo Total: \$${widget.seguro.costoTotal.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Pago Mensual: \$${widget.seguro.pagoMensual.toStringAsFixed(2)}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Tasa de Interés: ${widget.seguro.tasaInteres}%",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Fecha de Inicio: ${widget.seguro.fechaInicio.day}/${widget.seguro.fechaInicio.month}/${widget.seguro.fechaInicio.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Fecha de Vencimiento: ${widget.seguro.fechaVencimiento.day}/${widget.seguro.fechaVencimiento.month}/${widget.seguro.fechaVencimiento.year}",
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "Estado: ${widget.seguro.estado}",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Detalles de su Seguro",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Divider(),
                          Text(
                            "Usted cuenta con un Seguro de ${widget.seguro.tipoSeguro} con una cobertura de \$${widget.seguro.montoCobertura.toStringAsFixed(2)}. A continuación, le presentamos los detalles de su póliza:",
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text("✔ Protección financiera en caso de accidentes."),
                          Text("✔ Cobertura de hasta \$${widget.seguro.montoCobertura.toStringAsFixed(2)} en daños."),
                          Text("✔ Pagos flexibles y accesibles."),
                          const SizedBox(height: 16),
                          
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
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  child: Text("Salir"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Acción para hacer la solicitud del seguro
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Solicitud de Seguro"),
                                          content: Text(
                                            "¿Desea realizar la solicitud del seguro para el cliente ${selectedCliente!.nombreCompleto}?",
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
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Solicitud de seguro realizada exitosamente."),
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