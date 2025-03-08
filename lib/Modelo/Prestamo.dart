class Prestamo {
  String? numeroCuenta;
  double monto;
  int meses;
  double tasaInteres;
  DateTime fechaInicio;
  String tipoPrestamo;
  String estado;  // Pendiente, Pagado, Atrasado
  String? numeroPrestamo;
  
  double? pagoMinimo;
  DateTime fechaCorte;
  DateTime fechapago;
  String diasPago;

  Prestamo({
    required this.numeroCuenta,
    required this.monto,
    required this.meses,
    required this.tasaInteres,
    required this.fechaInicio,
    required this.tipoPrestamo,
    required this.fechaCorte,
    required this.fechapago,
    this.estado = "Pendiente",
    required this.numeroPrestamo,
    required this.pagoMinimo,
    required this.diasPago
  });

}