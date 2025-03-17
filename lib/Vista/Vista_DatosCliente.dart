import 'package:flutter/material.dart';

import '../Controlador/Controlador_DatosCliente.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Prestamo.dart';
import '../Modelo/Seguro.dart';
import '../Modelo/Transferencia.dart';

class VistaDatosCliente extends StatefulWidget {
  final Cliente cliente;  // Cliente recibido para mostrar sus datos

  const VistaDatosCliente({required this.cliente, Key? key}) : super(key: key);

  @override
  _VistaDatosClienteState createState() => _VistaDatosClienteState();
}

class _VistaDatosClienteState extends State<VistaDatosCliente> {
  String selectedFilter = 'Préstamos'; // Filtro inicial
  final controlador = ControladorDatoscliente();
  List<Prestamo> prestamos = [];
  List<Seguro> seguros = [];
  // Controlador de búsqueda
  TextEditingController _searchController = TextEditingController();

  List<dynamic> filteredOperaciones = [];

  @override
  Future<void> initState() async {
    super.initState();
    prestamos = await controlador.obtenerPrestamos();
    seguros = await controlador.obtenerSeguros();
    _filterOperaciones();
  }


  List<Transferencia> transferencias = [
    Transferencia(
      numeroCuenta: "12345678901",
      numeroTransferencia: "TR001",
      numeroCuentaOrigen: "12345678901",
      numeroCuentaDestino: "98765432109",
      monto: 500.00,
      fechaTransferencia: DateTime(2023, 11, 15, 10, 30),
      tipoTransferencia: "Cuenta a cuenta",
      referencia: "Pago de servicios",
      nombreDestinatario: "Juan Pérez",
    ),
    Transferencia(
      numeroCuenta: "12345678901",
      numeroTransferencia: "TR002",
      numeroCuentaOrigen: "98765432109",
      numeroCuentaDestino: "11223344556",
      monto: 1000.00,
      fechaTransferencia: DateTime(2023, 11, 16, 14, 15),
      tipoTransferencia: "Ventanilla",
      referencia: "Retiro de efectivo",
      nombreDestinatario: "María López",
    ),
    Transferencia(
      numeroCuenta: "12345678901",
      numeroTransferencia: "TR003",
      numeroCuentaOrigen: "11223344556",
      numeroCuentaDestino: "66554433221",
      monto: 250.00,
      fechaTransferencia: DateTime(2023, 11, 17, 9, 0),
      tipoTransferencia: "Cuenta a cuenta",
      referencia: "Pago de colegiatura",
      nombreDestinatario: "Carlos Ramírez",
    ),
    Transferencia(
      numeroCuenta: "12345678901",
      numeroTransferencia: "TR004",
      numeroCuentaOrigen: "66554433221",
      numeroCuentaDestino: "10293847563",
      monto: 750.00,
      fechaTransferencia: DateTime(2023, 11, 18, 16, 45),
      tipoTransferencia: "Cuenta a cuenta",
      referencia: "Pago de renta",
      nombreDestinatario: "Laura Torres",
    ),
  ];

  // Filtrar las operaciones según el tipo seleccionado y el número de cuenta
  void _filterOperaciones() {
    setState(() {
      if (selectedFilter == 'Préstamos') {
        filteredOperaciones = prestamos
            .where((prestamo) => prestamo.numeroCuenta == widget.cliente.numeroCuenta)
            .toList();
      } else if (selectedFilter == 'Seguros') {
        filteredOperaciones = seguros
            .where((seguro) => seguro.numeroCuenta == widget.cliente.numeroCuenta)
            .toList();
      } else if (selectedFilter == 'Transferencias') {
        filteredOperaciones = transferencias
            .where((transferencia) => transferencia.numeroCuentaOrigen == widget.cliente.numeroCuenta)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("Datos de Cliente: ${widget.cliente.nombreCompleto}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown para seleccionar el tipo de operación
            DropdownButton<String>(
              value: selectedFilter,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFilter = newValue!;
                  _filterOperaciones();
                });
              },
              items: <String>['Préstamos', 'Seguros', 'Transferencias']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            // Campo de búsqueda (por número de cuenta, si es necesario)
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Buscar operación por monto o fecha",
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (text) {
                _filterOperaciones(); // Llamamos al filtro cada vez que cambia el texto
              },
            ),
            SizedBox(height: 10),
            // Lista de operaciones filtradas
            Expanded(
              child: ListView.builder(
                itemCount: filteredOperaciones.length,
                itemBuilder: (context, index) {
                  final operacion = filteredOperaciones[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: Colors.green[900],
                    child: ListTile(
                      title: Text(
                        '${operacion.runtimeType == Prestamo ? 'Préstamo' : operacion.runtimeType == Seguro ? 'Seguros' : 'Transferencias'} - ',
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Mas detalles',
                        style: TextStyle(color: Colors.white70),
                      ),
                      onTap: () {
                        // Acción al hacer clic en una operación
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Detalle de Operación'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Tipo: ${operacion.runtimeType}'),
                                    if (operacion is Prestamo) ...[
                                      Text('Monto: ${operacion.monto}'),
                                      Text('Meses: ${operacion.meses}'),
                                      Text('Tasa de Interés: ${operacion.tasaInteres}'),
                                      Text('Fecha de Inicio: ${operacion.fechaInicio}'),
                                      Text('Fecha de Pago: ${operacion.fechapago}'),
                                      Text('Estado: ${operacion.estado}'),
                                      Text('Número de Préstamo: ${operacion.numeroPrestamo}'),
                                      Text('Número de Cliente: ${operacion.numeroCuenta}'),
                                      Text('Pago Mínimo: ${operacion.pagoMinimo}'),
                                      Text('Días de Pago: ${operacion.diasPago}'),
                                    ]else if (operacion is Seguro) ...[
                                          Text(
                                            'Póliza: ${operacion.numeroPoliza} (${operacion.tipoSeguro})',
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          Divider(),
                                          Text('Cliente: ${operacion.numeroCuenta}'),
                                          Text('Monto de Cobertura: \$${operacion.montoCobertura.toStringAsFixed(2)}'),
                                          Text('Costo Total: \$${operacion.costoTotal.toStringAsFixed(2)}'),
                                          Text('Pago Mensual: \$${operacion.pagoMensual.toStringAsFixed(2)}'),
                                          Text('Pagos Realizados: ${operacion.pagosRealizados}/${operacion.meses}'),
                                          Text('Tasa de Interés: ${(operacion.tasaInteres * 100).toStringAsFixed(2)}%'),
                                          Text('Estado: ${operacion.estado}', style: TextStyle(color: Colors.blue)),
                                          Divider(),
                                          Text('Vigencia: ${operacion.fechaInicio.day}/${operacion.fechaInicio.month}/${operacion.fechaInicio.year} - '
                                              '${operacion.fechaVencimiento.day}/${operacion.fechaVencimiento.month}/${operacion.fechaVencimiento.year}'),
                                          if (operacion.descripcionCobertura != null) 
                                            Text('Cobertura: ${operacion.descripcionCobertura}'),
                                    ] else if (operacion is Transferencia) ...[
                                      Text('Número de Cuenta: ${operacion.numeroCuenta}'),
                                      Text('Número de Transferencia: ${operacion.numeroTransferencia}'),
                                      Text('Número de Cuenta Origen: ${operacion.numeroCuentaOrigen}'),
                                      Text('Número de Cuenta Destino: ${operacion.numeroCuentaDestino}'),
                                      Text('Monto: ${operacion.monto}'),
                                      Text('Fecha de Transferencia: ${operacion.fechaTransferencia}'),
                                      Text('Tipo de Transferencia: ${operacion.tipoTransferencia}'),
                                      Text('Referencia: ${operacion.referencia}'),
                                      Text('Nombre del Destinatario: ${operacion.nombreDestinatario}'),
                                    ],
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Cerrar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        print('Detalle de operación: ${operacion.runtimeType}');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}