class CuentaCredito {
  String numeroCuenta;
  double limiteCredito;
  double saldoDeuda;
  DateTime fechaAprobacion;
  String estadoCredito; // Activo, Moroso, Cancelado

  CuentaCredito({
    required this.numeroCuenta,
    required this.limiteCredito,
    required this.saldoDeuda,
    required this.fechaAprobacion,
    required this.estadoCredito,
  });


}
