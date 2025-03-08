class Transferencia {
  String numeroCuenta;
  String numeroTransferencia;
  String numeroCuentaOrigen;
  String numeroCuentaDestino;
  double monto;
  DateTime fechaTransferencia;
  String tipoTransferencia; // Cuenta a cuenta, Ventanilla, etc.
  String estado; // Exitosa, Fallida, Pendiente, etc.
  String? referencia; // Descripción de la transferencia
  String? nombreDestinatario;

  Transferencia({
    required this.numeroCuenta,
    required this.numeroTransferencia,
    required this.numeroCuentaOrigen,
    required this.numeroCuentaDestino,
    required this.monto,
    required this.fechaTransferencia,
    required this.tipoTransferencia,
    this.estado = "Exitosa",
    this.referencia,
    this.nombreDestinatario,
  });
}