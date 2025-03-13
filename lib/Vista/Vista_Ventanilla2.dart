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

  @override
  void initState() {
    super.initState();
    _cargarDatosCliente();
  }

  void _cargarDatosCliente() {
    // Buscar la cuenta del cliente (esto siempre debe existir)
    cuentaCliente = buscarCuentaCliente(widget.cliente.numeroCuenta);
    print(widget.cliente.tieneCredito);
    // Si el cliente tiene crédito, buscar la cuenta de crédito
    if (widget.cliente.tieneCredito) {
      cuentaCredito = buscarCuentaCredito(widget.cliente.numeroCuenta);
      prestamo = buscarPrestamo(widget.cliente.numeroCuenta);
    }
    setState(() {});
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
                            onPressed: () => Navigator.pop(context),
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
          color: const Color(0xFFB1ACAC),
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Column(
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
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (prestamo != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (cuentaCredito != null) ...[
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
                          const SizedBox(height: 8),
                          Text(
                            'Crédito Disponible: \$${(cuentaCredito!.limiteCredito - cuentaCredito!.saldoDeuda).toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Saldo Deuda: \$${cuentaCredito!.saldoDeuda.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tasa de Interés: ${cuentaCredito!.tasaInteres}%',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                        const SizedBox(height: 20),
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
                        const SizedBox(height: 8),
                        Text(
                          'Deuda Pendiente: \$${prestamo!.monto.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Meses Restantes: ${prestamo!.meses - prestamo!.pagosRealizados}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tasa de Interés: ${prestamo!.tasaInteres}%',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pago Mínimo: \$${prestamo!.pagoMinimo?.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Fecha de Pago: ${_formatDate(prestamo!.fechapago)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _realizarDeposito,
                      icon: Icon(Icons.attach_money, color: Colors.white),
                      label: Text(
                        'Depositar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 124, 99, 86),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    if (prestamo != null)
                      ElevatedButton.icon(
                        label: Text(
                          'Pagar Crédito',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 71, 53, 26),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => _mostrarPagoCreditoDialog(context),
                        icon: Icon(Icons.credit_card, color: Colors.white),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Métodos de ejemplo para buscar cuentas (debes implementarlos con tu lógica real)
  CuentaCliente buscarCuentaCliente(String numeroCuenta) {
    return CuentaCliente(
      numeroCuenta: numeroCuenta,
      saldo: 5000.0,
      tipoCuenta: "Ahorro",
      fechaApertura: DateTime(2020, 5, 10),
      estadoCuenta: "Activa",
    );
  }

  CuentaCredito? buscarCuentaCredito(String numeroCuenta) {
    return CuentaCredito(
      numeroCuenta: numeroCuenta,
      limiteCredito: 20000.0,
      saldoDeuda: 5000.0,
      tasaInteres: 3.5,
      fechaAprobacion: DateTime(2022, 3, 15),
      estadoCredito: "Activo",
    );
  }

  Prestamo? buscarPrestamo(String numeroCuenta) {
    return Prestamo(
      numeroCuenta: numeroCuenta,
      numeroPrestamo: "P12345",
      monto: 5000.0,
      meses: 24,
      pagosRealizados: 12,
      tasaInteres: 5.0,
      fechaInicio: DateTime(2023, 6, 1),
      tipoPrestamo: "Personal",
      fechapago: DateTime(2024, 6, 10),
      pagoMinimo: 500.0,
      diasPago: "10 de cada mes",
    );
  }

  Future _mostrarPagoCreditoDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pago de Crédito/Préstamo"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Ingrese el monto a pagar"),
              TextField(
                controller: _montoController,
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
                double monto = double.tryParse(_montoController.text) ?? 0.0;
                if (monto > 0) {
                  if (cuentaCredito != null &&
                      monto <= cuentaCredito!.saldoDeuda) {
                    setState(() {
                      cuentaCredito!.saldoDeuda -= monto;
                    });
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Pago realizado"),
                          content: Text(
                            "Pago de \$${monto.toStringAsFixed(2)} realizado.",
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
                  } else if (prestamo != null && monto <= prestamo!.monto) {
                    setState(() {
                      prestamo!.monto -= monto;
                    });
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Pago realizado"),
                          content: Text(
                            "Pago de \$${monto.toStringAsFixed(2)} realizado.",
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
                          content: Text(
                            "El monto a pagar excede la deuda pendiente.",
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
}
