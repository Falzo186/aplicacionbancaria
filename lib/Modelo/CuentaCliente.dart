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

factory CuentaCliente.fromMap(Map<String, dynamic> map) {
  return CuentaCliente(
    numeroCuenta: map['numerocuenta'] as String,
    saldo: map['saldo'] as double,
    tipoCuenta: map['tipocuenta'] as String,
    fechaApertura: DateTime.parse(map['fechaapertura'] as String),
    estadoCuenta: map['estadocuenta'] as String,
  );
}

Map<String, dynamic> toMap() {
  return {
    'numerocuenta': numeroCuenta,
    'saldo': saldo,
    'tipocuenta': tipoCuenta,
    'fechaapertura': fechaApertura.toIso8601String(),
    'estadocuenta': estadoCuenta,
  };
}




}