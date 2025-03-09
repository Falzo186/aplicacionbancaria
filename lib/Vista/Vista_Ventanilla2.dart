import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    double monto = double.tryParse(_montoController.text) ?? 0.0;
    if (monto > 0 && cuentaCliente != null) {
      setState(() {
        cuentaCliente!.saldo += monto;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Depósito de \$${monto.toStringAsFixed(2)} realizado.')),
      );
    }
  }

  void _realizarPagoCredito() {
    if (prestamo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El cliente no tiene préstamo.')),
      );
      return;
    }
    double pagoMinimo = prestamo!.pagoMinimo ?? 0.0;
    double monto = double.tryParse(_montoController.text) ?? 0.0;
    if (monto < pagoMinimo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('El pago mínimo es de \$${pagoMinimo.toStringAsFixed(2)}.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pago de \$${monto.toStringAsFixed(2)} realizado.')),
    );
  }

  final TextEditingController _montoController = TextEditingController();

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = _formatDate(widget.cliente.fechaNacimiento);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ventanilla - ${widget.cliente.nombreCompleto}'),
        backgroundColor: const Color.fromARGB(255, 124, 85, 34),
      ),
      body: Container(
        color: const Color.fromARGB(255, 185, 166, 141),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente: ${widget.cliente.nombreCompleto}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('Número de Cuenta: ${widget.cliente.numeroCuenta}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Teléfono: ${widget.cliente.telefono}',
                style: const TextStyle(fontSize: 16)),
            Text('Correo: ${widget.cliente.correoElectronico}',
                style: const TextStyle(fontSize: 16)),
            Text('Dirección: ${widget.cliente.direccionCompleta}',
                style: const TextStyle(fontSize: 16)),
            Text('Fecha de Nacimiento: $formattedDate',
                style: const TextStyle(fontSize: 16)),
            Text('Género: ${widget.cliente.genero}',
                style: const TextStyle(fontSize: 16)),
            Text('Tipo de Cuenta: ${cuentaCliente?.tipoCuenta ?? 'N/A'}',
                style: const TextStyle(fontSize: 16)),
            Text('Saldo: \$${cuentaCliente?.saldo.toStringAsFixed(2) ?? 'N/A'}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            if (cuentaCliente != null)
              Text('Número de Cuenta: ${cuentaCliente!.numeroCuenta}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (cuentaCredito != null) ...[
              Text('Límite de Crédito: \$${cuentaCredito!.limiteCredito.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16)),
              Text('Crédito Disponible: \$${cuentaCredito!.limiteCredito - cuentaCredito!.saldoDeuda}',
                  style: const TextStyle(fontSize: 16)),
              Text('Saldo Deuda: \$${cuentaCredito!.saldoDeuda.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, color: Colors.red)),
              Text('Tasa de Interés: ${cuentaCredito!.tasaInteres}%',
                  style: const TextStyle(fontSize: 16,)),
            ],
            if (prestamo != null) ...[
              Text('Deuda Pendiente: \$${prestamo!.monto.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, color: Colors.red)),
              Text('Meses Restantes: ${prestamo!.meses - prestamo!.pagosRealizados}',
                  style: const TextStyle(fontSize: 16,)),
              Text('Tasa de Interés a meses: ${prestamo!.tasaInteres}%',
                  style: const TextStyle(fontSize: 16,)),
              Text('Pago Mínimo: \$${prestamo!.pagoMinimo?.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16,)),
              Text('Fecha de Corte: ${_formatDate(prestamo!.fechaCorte)}',
                  style: const TextStyle(fontSize: 16,)),
              Text('Fecha de Pago: ${_formatDate(prestamo!.fechapago)}',
                  style: const TextStyle(fontSize: 16,)),
            ],
            TextField(
              controller: _montoController,
              decoration: const InputDecoration(labelText: 'Monto'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _realizarDeposito,
                  child: const Text('Depositar'),
                ),
                if (prestamo != null)
                  ElevatedButton(
                    onPressed: _realizarPagoCredito,
                    child: const Text('Pagar Crédito'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
    fechaCorte: DateTime(2024, 6, 1),
    fechapago: DateTime(2024, 6, 10),
    pagoMinimo: 500.0,
    diasPago: "10 de cada mes",
  );
}