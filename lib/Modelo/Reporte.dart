class Reporte {
  String numeroReporte;
  String tipoReporte; // deposito, inversion,pago de credito
  String descripcion;
  DateTime fechaReporte;
  String numeroCuenta;
  String monto;

Reporte ({
  required this.numeroReporte,
  required this.tipoReporte,
  required this.descripcion,
  required this.fechaReporte,
  required this.numeroCuenta,
  required this.monto,
});

}