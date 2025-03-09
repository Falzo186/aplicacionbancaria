class Prestamo {
  String? numeroCuenta;
  String? numeroPrestamo;
  double monto;
  int meses;
  int pagosRealizados;
  double tasaInteres;
  DateTime fechaInicio;
  String tipoPrestamo;
  String estado;  // Pendiente, Pagado, Atrasado
  double? pagoMinimo;
  DateTime fechaCorte;
  DateTime fechapago;
  String diasPago;

  Prestamo({
    required this.numeroCuenta,
    required this.numeroPrestamo,
    required this.monto,
    required this.meses,
    required this.pagosRealizados,
    required this.tasaInteres,
    required this.fechaInicio,
    required this.tipoPrestamo,
    required this.fechaCorte,
    required this.fechapago,
    this.estado = "Pendiente",
    required this.pagoMinimo,
    required this.diasPago
  });

}