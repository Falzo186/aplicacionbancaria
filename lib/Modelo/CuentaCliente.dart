class CuentaCliente {
  String numeroCuenta;
  double saldo;
  String tipoCuenta;
  DateTime fechaApertura;
  String estadoCuenta; // Activa, Suspendida, Bloqueada

  CuentaCliente({
    required this.numeroCuenta,
    required this.saldo,
    required this.tipoCuenta,
    required this.fechaApertura,
    required this.estadoCuenta,
});
}