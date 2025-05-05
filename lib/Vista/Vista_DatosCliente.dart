import 'package:aplicacionbancaria/Modelo/Inversion.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import the fl_chart package

import '../Controlador/Controlador_DatosCliente.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/Prestamo.dart';
import '../Modelo/Seguro.dart';
import '../Modelo/Transferencia.dart';

class VistaDatosCliente extends StatefulWidget {
  final Cliente cliente; // Cliente recibido para mostrar sus datos

  const VistaDatosCliente({required this.cliente, Key? key}) : super(key: key);

  @override
  _VistaDatosClienteState createState() => _VistaDatosClienteState();
}

class _VistaDatosClienteState extends State<VistaDatosCliente> {
  String selectedFilter = 'Información General'; // Filtro inicial
  final controlador = ControladorDatoscliente();
  List<Prestamo> prestamos = [];
  List<Seguro> seguros = [];
  List<Inversion> inversiones = [];
  List<Transferencia> transferencias = [];
  TextEditingController _searchController = TextEditingController();
  List<dynamic> filteredOperaciones = [];
  int totalPrestamos = 0;
  int totalSeguros = 0;
  int totalInversiones = 0;
  int totalTransferencias = 0;
  double sumaPrestamos = 0;
  double sumaSeguros = 0;
  double sumaInversiones = 0;
  double sumaTransferencias = 0;
  DateTime fechaApertura = DateTime.now();

  bool _isLoading = true;

  Future<void> _initializeData() async {
    try {
      prestamos = await controlador.buscarPrestamosPorCuenta(
        widget.cliente.numeroCuenta,
      );
      seguros = await controlador.buscarSegurosPorCuenta(
        widget.cliente.numeroCuenta,
      );
      inversiones = await controlador.buscarInversionesPorCuenta(
        widget.cliente.numeroCuenta,
      );
      transferencias = await controlador.obtenerTransferencias();

      fechaApertura =
          (await controlador.obtenerFechaApertura(
            widget.cliente.numeroCuenta,
          ))!;
      totalPrestamos = prestamos.length;
      totalSeguros = seguros.length;
      totalInversiones = inversiones.length;
      totalTransferencias = transferencias.length;

      sumaPrestamos = prestamos.fold(0, (sum, item) => sum + item.monto);
      sumaSeguros = seguros.fold(0, (sum, item) => sum + item.costoTotal);
      sumaInversiones = inversiones.fold(0, (sum, item) => sum + item.monto);
      sumaTransferencias = transferencias.fold(
        0,
        (sum, item) => sum + item.monto,
      );

      _filterOperaciones();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _filterOperaciones() {
    setState(() {
      if (selectedFilter == 'Préstamos') {
        filteredOperaciones =
            prestamos
                .where(
                  (prestamo) =>
                      prestamo.numeroCuenta == widget.cliente.numeroCuenta,
                )
                .toList();
      } else if (selectedFilter == 'Seguros') {
        filteredOperaciones =
            seguros
                .where(
                  (seguro) =>
                      seguro.numeroCuenta == widget.cliente.numeroCuenta,
                )
                .toList();
      } else if (selectedFilter == 'Transferencias') {
        filteredOperaciones =
            transferencias
                .where(
                  (transferencia) =>
                      transferencia.numeroCuentaOrigen ==
                      widget.cliente.numeroCuenta,
                )
                .toList();
      } else if (selectedFilter == 'Información General') {
        filteredOperaciones = [];
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
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Fila con el campo de búsqueda y el combo box
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: "Buscar...",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              prefixIcon: Icon(Icons.search),
                              fillColor: Colors.brown[50],
                              filled: true,
                            ),
                            onChanged: (text) {
                              _filterOperaciones();
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        DropdownButton<String>(
                          value: selectedFilter,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedFilter = newValue!;
                              _filterOperaciones();
                            });
                          },
                          items:
                              [
                                'Información General',
                                'Préstamos',
                                'Seguros',
                                'Transferencias',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Información General con Gráficas
                    if (selectedFilter == 'Información General') ...[
                      Card(
                        color: Colors.brown[100],
                        margin: EdgeInsets.only(bottom: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Información General',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.brown[900],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text('Número de Préstamos: $totalPrestamos'),
                              Text('Número de Seguros: $totalSeguros'),
                              Text('Número de Inversiones: $totalInversiones'),
                              Text(
                                'Número de Transferencias: $totalTransferencias',
                              ),
                              Text(
                                'Cliente desde: ${fechaApertura.day}/${fechaApertura.month}/${fechaApertura.year}',
                              ),
                              SizedBox(height: 16),
                              // Gráficas
                              SizedBox(
                                height: 200,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: PieChart(
                                        PieChartData(
                                          sections: [
                                            PieChartSectionData(
                                              value: sumaPrestamos,
                                              title: 'Préstamos',
                                              color: Colors.blue,
                                            ),
                                            PieChartSectionData(
                                              value: sumaSeguros,
                                              title: 'Seguros',
                                              color: Colors.green,
                                            ),
                                            PieChartSectionData(
                                              value: sumaInversiones,
                                              title: 'Inversiones',
                                              color: Colors.orange,
                                            ),
                                            PieChartSectionData(
                                              value: sumaTransferencias,
                                              title: 'Transferencias',
                                              color: Colors.red,
                                            ),
                                          ],
                                          sectionsSpace: 2,
                                          centerSpaceRadius: 40,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: BarChart(
                                        BarChartData(
                                          barGroups: [
                                            BarChartGroupData(
                                              x: 0,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: sumaPrestamos,
                                                  color: Colors.blue,
                                                ),
                                              ],
                                            ),
                                            BarChartGroupData(
                                              x: 1,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: sumaSeguros,
                                                  color: Colors.green,
                                                ),
                                              ],
                                            ),
                                            BarChartGroupData(
                                              x: 2,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: sumaInversiones,
                                                  color: Colors.orange,
                                                ),
                                              ],
                                            ),
                                            BarChartGroupData(
                                              x: 3,
                                              barRods: [
                                                BarChartRodData(
                                                  toY: sumaTransferencias,
                                                  color: Colors.red,
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    // Lista de operaciones filtradas
                    if (selectedFilter != 'Información General')
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredOperaciones.length,
                          itemBuilder: (context, index) {
                            final operacion = filteredOperaciones[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              color: Colors.brown[200],
                              child: ListTile(
                                title: Text(
                                  operacion is Prestamo
                                      ? 'Préstamo'
                                      : operacion is Seguro
                                      ? 'Seguro'
                                      : 'Transferencia',
                                  style: TextStyle(color: Colors.brown[900]),
                                ),
                                subtitle: Text(
                                  'Más detalles',
                                  style: TextStyle(color: Colors.brown[700]),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Detalle de Operación'),
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Text(
                                                'Tipo: ${operacion.runtimeType}',
                                              ),
                                              if (operacion is Prestamo) ...[
                                                Text(
                                                  'Monto: ${operacion.monto}',
                                                ),
                                                Text(
                                                  'Meses: ${operacion.meses}',
                                                ),
                                                Text(
                                                  'Tasa de Interés: ${operacion.tasaInteres}',
                                                ),
                                                Text(
                                                  'Fecha de Inicio: ${operacion.fechaInicio}',
                                                ),
                                                Text(
                                                  'Fecha de Pago: ${operacion.fechapago}',
                                                ),
                                                Text(
                                                  'Estado: ${operacion.estado}',
                                                ),
                                                Text(
                                                  'Número de Préstamo: ${operacion.numeroPrestamo}',
                                                ),
                                                Text(
                                                  'Número de Cliente: ${operacion.numeroCuenta}',
                                                ),
                                                Text(
                                                  'Pago Mínimo: ${operacion.pagoMinimo}',
                                                ),
                                                Text(
                                                  'Días de Pago: ${operacion.diasPago}',
                                                ),
                                              ] else if (operacion
                                                  is Seguro) ...[
                                                Text(
                                                  'Póliza: ${operacion.numeroPoliza} (${operacion.tipoSeguro})',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Divider(),
                                                Text(
                                                  'Cliente: ${operacion.numeroCuenta}',
                                                ),
                                                Text(
                                                  'Monto de Cobertura: \$${operacion.montoCobertura.toStringAsFixed(2)}',
                                                ),
                                                Text(
                                                  'Costo Total: \$${operacion.costoTotal.toStringAsFixed(2)}',
                                                ),
                                                Text(
                                                  'Pago Mensual: \$${operacion.pagoMensual.toStringAsFixed(2)}',
                                                ),
                                                Text(
                                                  'Pagos Realizados: ${operacion.pagosRealizados}/${operacion.meses}',
                                                ),
                                                Text(
                                                  'Tasa de Interés: ${(operacion.tasaInteres * 100).toStringAsFixed(2)}%',
                                                ),
                                                Text(
                                                  'Estado: ${operacion.estado}',
                                                  style: TextStyle(
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                Divider(),
                                                Text(
                                                  'Vigencia: ${operacion.fechaInicio.day}/${operacion.fechaInicio.month}/${operacion.fechaInicio.year} - '
                                                  '${operacion.fechaVencimiento.day}/${operacion.fechaVencimiento.month}/${operacion.fechaVencimiento.year}',
                                                ),
                                                if (operacion
                                                        .descripcionCobertura !=
                                                    null)
                                                  Text(
                                                    'Cobertura: ${operacion.descripcionCobertura}',
                                                  ),
                                              ] else if (operacion
                                                  is Transferencia) ...[
                                                Text(
                                                  'Número de Cuenta: ${operacion.numeroCuenta}',
                                                ),
                                                Text(
                                                  'Número de Transferencia: ${operacion.numeroTransferencia}',
                                                ),
                                                Text(
                                                  'Número de Cuenta Origen: ${operacion.numeroCuentaOrigen}',
                                                ),
                                                Text(
                                                  'Número de Cuenta Destino: ${operacion.numeroCuentaDestino}',
                                                ),
                                                Text(
                                                  'Monto: ${operacion.monto}',
                                                ),
                                                Text(
                                                  'Fecha de Transferencia: ${operacion.fechaTransferencia}',
                                                ),
                                                Text(
                                                  'Tipo de Transferencia: ${operacion.tipoTransferencia}',
                                                ),
                                                Text(
                                                  'Referencia: ${operacion.referencia}',
                                                ),
                                                Text(
                                                  'Nombre del Destinatario: ${operacion.nombreDestinatario}',
                                                ),
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

                                  print(
                                    'Detalle de operación: ${operacion.runtimeType}',
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
    );
  }
}
