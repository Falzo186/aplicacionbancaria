import 'package:flutter/material.dart';

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

  // Controlador de búsqueda
  TextEditingController _searchController = TextEditingController();

  List<dynamic> filteredOperaciones = [];

  @override
  void initState() {
    super.initState();
    _filterOperaciones();
  }

  List<Prestamo> prestamos = [
    Prestamo(
      numeroCuenta: "12345678901",
      monto: 10000.00,
      meses: 12,
      pagosRealizados: 1,
      tasaInteres: 0.10,
      fechaInicio: DateTime(2023, 10, 15),
      tipoPrestamo: "Personal",
      fechaCorte: DateTime(2023, 11, 1),
      fechapago: DateTime(2023, 11, 10),
      estado: "Aprobado",
      numeroPrestamo: "PR001",
      
      pagoMinimo: 100.00,
      diasPago: "10 del mes",
    ),
    Prestamo(
      numeroCuenta: "12345678901",
      monto: 25000.00,
      meses: 24,
      pagosRealizados: 3,
      tasaInteres: 0.08,
      fechaInicio: DateTime(2023, 11, 1),
      tipoPrestamo: "Automóvil",
      fechaCorte: DateTime(2023, 12, 1),
      fechapago: DateTime(2023, 12, 15),
      estado: "Pendiente",
      numeroPrestamo: "PR002",
      pagoMinimo: 250.00,
      diasPago: "15 del mes",
    ),
  ];

  List<Seguro> seguros = [
    Seguro(
      numeroCuenta: "12345678901",
      numeroPoliza: "POL001",
      tipoSeguro: "Automóvil",
      montoCobertura: 500000.00,
      fechaInicio: DateTime(2023, 11, 1),
      fechaVencimiento: DateTime(2024, 11, 1),
      prima: 12000.00,
      estado: "Activo",
      descripcionCobertura: "Cobertura amplia",
    ),
    Seguro(
      numeroCuenta: "12345678901",
      numeroPoliza: "POL002",
      tipoSeguro: "Vida",
      montoCobertura: 1000000.00,
      fechaInicio: DateTime(2023, 10, 15),
      fechaVencimiento: DateTime(2028, 10, 15),
      prima: 8000.00,
      estado: "Activo",
      descripcionCobertura: "Cobertura por fallecimiento",
    ),
    Seguro(
      numeroCuenta: "12345678901",
      numeroPoliza: "POL003",
      tipoSeguro: "Casa",
      montoCobertura: 800000.00,
      fechaInicio: DateTime(2023, 11, 15),
      fechaVencimiento: DateTime(2024, 11, 15),
      prima: 9000.00,
      estado: "Activo",
      descripcionCobertura: "Cobertura contra incendios y robo",
    ),
    Seguro(
      numeroCuenta: "12345678901",
      numeroPoliza: "POL004",
      tipoSeguro: "Negocio",
      montoCobertura: 1500000.00,
      fechaInicio: DateTime(2023, 12, 1),
      fechaVencimiento: DateTime(2024, 12, 1),
      prima: 20000.00,
      estado: "Activo",
      descripcionCobertura: "Cobertura contra daños a terceros",
    ),
  ];

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
                                      Text('Tipo de Préstamo: ${operacion.tipoPrestamo}'),
                                      Text('Fecha de Corte: ${operacion.fechaCorte}'),
                                      Text('Fecha de Pago: ${operacion.fechapago}'),
                                      Text('Estado: ${operacion.estado}'),
                                      Text('Número de Préstamo: ${operacion.numeroPrestamo}'),
                                      Text('Número de Cliente: ${operacion.numeroCuenta}'),
                                      Text('Pago Mínimo: ${operacion.pagoMinimo}'),
                                      Text('Días de Pago: ${operacion.diasPago}'),
                                    ] else if (operacion is Seguro) ...[
                                      Text('Número de Cliente: ${operacion.numeroCuenta}'),
                                      Text('Número de Póliza: ${operacion.numeroPoliza}'),
                                      Text('Tipo de Seguro: ${operacion.tipoSeguro}'),
                                      Text('Monto de Cobertura: ${operacion.montoCobertura}'),
                                      Text('Fecha de Inicio: ${operacion.fechaInicio}'),
                                      Text('Fecha de Vencimiento: ${operacion.fechaVencimiento}'),
                                      Text('Prima: ${operacion.prima}'),
                                      Text('Estado: ${operacion.estado}'),
                                      Text('Descripción de Cobertura: ${operacion.descripcionCobertura}'),
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