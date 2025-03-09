class CuentaCredito {
  String numeroCuenta;
  double limiteCredito;
  double saldoDeuda;
  double tasaInteres;
  DateTime fechaAprobacion;
  String estadoCredito; // Activo, Moroso, Cancelado

  CuentaCredito({
    required this.numeroCuenta,
    required this.limiteCredito,
    required this.saldoDeuda,
    required this.tasaInteres,
    required this.fechaAprobacion,
    required this.estadoCredito,
  });

  // Método para calcular la deuda total con intereses
  double calcularDeudaTotal() {
    return saldoDeuda + (saldoDeuda * tasaInteres / 100);
  }

  // Método para realizar un pago
  void realizarPago(double monto) {
    if (monto <= saldoDeuda) {
      saldoDeuda -= monto;
    } else {
      saldoDeuda = 0;
    }
  }
}
