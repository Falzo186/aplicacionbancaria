import 'package:aplicacionbancaria/Controlador/Controlador_DatosCliente.dart';
import 'package:aplicacionbancaria/Modelo/Seguro.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/CuentaCliente.dart';
import '../Modelo/CuentaCredito.dart';
import '../Modelo/Prestamo.dart';

class VistaVentanilla2 extends StatefulWidget {
  final Cliente cliente;

  const VistaVentanilla2({Key? key, required this.cliente}) : super(key: key);

  @override
  _VistaVentanillaState createState() => _VistaVentanillaState();
}

class _VistaVentanillaState extends State<VistaVentanilla2> {
  CuentaCliente? cuentaCliente;
  CuentaCredito? cuentaCredito;
  Prestamo? prestamo;
  Seguro? seguro;
  final controlador = ControladorDatoscliente();

  @override
  void initState() {
    super.initState();
    _cargarDatosCliente();
  }

  Future<void> _cargarDatosCliente() async {
    // Buscar la cuenta del cliente (esto siempre debe existir)
    cuentaCliente = controlador.buscarCuentaCliente(widget.cliente.numeroCuenta);
    print(widget.cliente.tieneCredito);
    // Si el cliente tiene crédito, buscar la cuenta de crédito
    if (widget.cliente.tieneCredito) {
      cuentaCredito = await controlador.buscarCuentaCredito(widget.cliente.numeroCuenta);
    }
    if (widget.cliente.tienePrestamo) {
      prestamo = await controlador.buscarPrestamo(widget.cliente.numeroCuenta);
    }
    if(widget.cliente.tieneSeguro){
      seguro = await controlador.buscarSeguro(widget.cliente.numeroCuenta);
    }

    setState(() {});
  }

  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _montoDeposito = TextEditingController();

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = _formatDate(widget.cliente.fechaNacimiento);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Información bancaria',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF472F2F),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/Recursos/logo.png'), // Ruta de la imagen del logo
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.10), // Ajusta la opacidad según sea necesario
                BlendMode.dstATop,
              ),
              scale: 2.0, // Reduce el tamaño del logo en un 25%
            ),
          ),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cliente: ${widget.cliente.nombreCompleto}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Número de Cuenta: ${widget.cliente.numeroCuenta}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Teléfono: ${widget.cliente.telefono}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Correo: ${widget.cliente.correoElectronico}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Dirección: ${widget.cliente.direccionCompleta}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Fecha de Nacimiento: $formattedDate',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Género: ${widget.cliente.genero}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Tipo de Cuenta: ${cuentaCliente?.tipoCuenta ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Saldo: \$${cuentaCliente?.saldo.toStringAsFixed(2) ?? 'N/A'}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: _realizarDeposito,
                            child: const Text('Realizar Depósito'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  if (cuentaCredito != null)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Información de Crédito',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(),
                            Text(
                              'Límite de Crédito: \$${cuentaCredito!.limiteCredito.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Crédito Disponible: \$${(cuentaCredito!.limiteCredito - cuentaCredito!.saldoDeuda).toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Fecha de Aprobación: ${_formatDate(cuentaCredito!.fechaAprobacion)}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Estado de Crédito: ${cuentaCredito!.estadoCredito}',
                              style: TextStyle(
                              fontSize: 16,
                              color: cuentaCredito!.estadoCredito == 'Activo' ? Colors.green : Colors.red,
                              ),
                            ),
                            Text(
                              'Saldo Deuda: \$${cuentaCredito!.saldoDeuda.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              if (prestamo != null || seguro != null) ...[
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (prestamo != null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Información de Préstamo',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Número de Préstamo: ${prestamo!.numeroPrestamo}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Deuda Pendiente: \$${prestamo!.monto.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              Text(
                                'Meses Restantes: ${prestamo!.meses - prestamo!.pagosRealizados}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Tasa de Interés: ${prestamo!.tasaInteres}%',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Pago Mínimo: \$${prestamo!.pagoMinimo?.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Fecha de Pago: ${_formatDate(prestamo!.fechapago)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => _mostrarPagoPrestamoDialog(context),
                                child: const Text('Pagar Crédito/Préstamo'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(width: 15),
                    if (seguro != null)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Información de Seguro',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Text(
                                'Número de Póliza: ${seguro!.numeroPoliza}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Tipo de Seguro: ${seguro!.tipoSeguro}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Fecha de Vencimiento: ${_formatDate(seguro!.fechaVencimiento)},Estado: ${seguro!.estado}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Meses Totales: ${seguro!.meses} ,Pagos Realizados: ${seguro!.pagosRealizados}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Monto de Cobertura: \$${seguro!.montoCobertura.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Monto Faltante: \$${seguro!.montoFaltante.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Fecha de Pago: ${_formatDate(seguro!.fechaPago)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Costo Mensual: \$${seguro!.pagoMensual.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => _pagarSeguro(context),
                                child: const Text('Pagar Seguro'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }



  Future _mostrarPagoPrestamoDialog(BuildContext context) async {
  _montoController.text = prestamo?.pagoMinimo?.toStringAsFixed(2) ?? '';

  DateTime hoy = DateTime.now();
  int diasDiferencia = hoy.difference(prestamo!.fechapago).inDays;
  double interesAtraso = 0.25; // 25% de interés por mes de atraso
  double interesTotal = 0;

  // Si el pago se ha retrasado más de x días, aplicar interés
  if (diasDiferencia > 2) {
    int mesesAtraso = (diasDiferencia  / 30).ceil();
    interesTotal = prestamo!.pagoMinimo! * interesAtraso * mesesAtraso;
  }

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Pago de Crédito/Préstamo"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Ingrese el monto a pagar"),
            if (interesTotal > 0)
              Text(
                "Pago atrasado. Se aplicará un interés de \$${interesTotal.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            if (diasDiferencia <= 0)
              Text(
                "Pago al día. Faltan ${-diasDiferencia} días para el vencimiento.",
                style: TextStyle(color: Colors.green),
              ),
            TextField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              decoration: InputDecoration(
                hintText: prestamo?.pagoMinimo?.toStringAsFixed(2),
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              double monto = double.tryParse(_montoController.text) ?? 0.0;

              if (monto >= (prestamo?.pagoMinimo ?? 0.0)) {
                double totalPagar = monto + interesTotal;

                if (prestamo != null && totalPagar <= prestamo!.monto) {
                  setState(() {
                    prestamo!.montoRestante -= totalPagar;
                    prestamo!.pagosRealizados += 1;
                    prestamo!.fechapago = DateTime(
                      DateTime.now().year,
                      DateTime.now().month + 1,
                      prestamo!.fechapago.day,
                    );
                    controlador.actualizarPrestamo(prestamo!);
                    cuentaCredito!.saldoDeuda -= prestamo!.montoRestante;
                    if (cuentaCredito!.saldoDeuda <= 0) {
                      cuentaCredito!.saldoDeuda = 0;
                      cuentaCredito!.estadoCredito = 'Activo';
                    }
                  });

                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Pago realizado"),
                        content: Text(
                          "Pago de \$${monto.toStringAsFixed(2)} realizado."
                          "${interesTotal > 0 ? "\nInterés por atraso aplicado: \$${interesTotal.toStringAsFixed(2)}" : ""}",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Aceptar"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Error"),
                        content: Text("El monto a pagar excede la deuda pendiente."),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Aceptar"),
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ingrese un monto válido.')),
                );
              }
            },
            child: Text("Aceptar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
        ],
      );
    },
  );
}


  void _realizarDeposito() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Depósito"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Ingrese el monto a depositar"),
              TextField(
                controller: _montoDeposito,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                double monto = double.tryParse(_montoDeposito.text) ?? 0.0;
                if (monto > 0 && cuentaCliente != null) {
                  setState(() {
                    cuentaCliente!.saldo += monto;
                  });
                  Navigator.pop(context); // Close the deposit dialog
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Depósito realizado"),
                        content: Text(
                          'Depósito de \$${monto.toStringAsFixed(2)} realizado.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the confirmation dialog
                            },
                            child: Text("Aceptar"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Ingrese un monto válido.')),
                  );
                }
              },
              child: Text("Aceptar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void _pagarSeguro(BuildContext context) {
  int diasDiferencia = DateTime.now().difference(seguro!.fechaPago).inDays;
  double interesAtraso = 0.25; // 25% de interés por atraso
  double interesTotal = 0;

  if (diasDiferencia > 0) { 
    int mesesAtraso = (diasDiferencia / 30).ceil();
    interesTotal = seguro!.pagoMensual * interesAtraso * mesesAtraso;
  }
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Pago de Seguro"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("El monto a pagar es de \$${seguro!.pagoMensual.toStringAsFixed(2)}"),
            if (interesTotal > 0) // Mostrar si hay interés por mora
              Text(
                "Pago atrasado. Se aplicará un interés de \$${interesTotal.toStringAsFixed(2)}",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                seguro!.pagosRealizados += 1;
                seguro!.montoFaltante -= (seguro!.pagoMensual + interesTotal);
                seguro!.fechaPago = DateTime(
                  seguro!.fechaPago.year,
                  seguro!.fechaPago.month + 1,
                  seguro!.fechaPago.day,
                );
                controlador.actualizarSeguro(seguro!);
              });

              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Pago realizado"),
                    content: Text(
                      "Pago de seguro de \$${seguro!.pagoMensual.toStringAsFixed(2)} realizado."
                      "${interesTotal > 0 ? "\nInterés por atraso aplicado: \$${interesTotal.toStringAsFixed(2)}" : ""}",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Aceptar"),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text("Aceptar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
        ],
      );
    },
  );
}

  

}
