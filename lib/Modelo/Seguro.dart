class Seguro {
  String numeroCuenta;
  String numeroPoliza;
  String tipoSeguro; // Vida, Automóvil, Casa, Negocio, etc.
  double montoCobertura;
  DateTime fechaInicio;
  DateTime fechaVencimiento;
  double prima; // Costo del seguro
  String estado; // Activo, Vencido, Cancelado, etc.
  String? numeroSiniestro; // Si aplica
  String? descripcionCobertura;

  Seguro({
    required this.numeroCuenta,
    required this.numeroPoliza,
    required this.tipoSeguro,
    required this.montoCobertura,
    required this.fechaInicio,
    required this.fechaVencimiento,
    required this.prima,
    this.estado = "Activo",
    this.numeroSiniestro,
    this.descripcionCobertura,
  });
}