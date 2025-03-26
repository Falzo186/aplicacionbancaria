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

  factory CuentaCredito.fromMap(Map<String, dynamic> map) {
    return CuentaCredito(
      numeroCuenta: map['numerocuenta'],
      limiteCredito: map['limitecredito'],
      saldoDeuda: map['saldodeuda'],
      fechaAprobacion: DateTime.parse(map['fechaaprobacion']),
      estadoCredito: map['estadocredito'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'numerocuenta': numeroCuenta,
      'limitecredito': limiteCredito,
      'saldodeuda': saldoDeuda,
      'fechaaprobacion': fechaAprobacion.toIso8601String(),
      'estadocredito': estadoCredito,
    };
  }


}
