class Inversion {
  String numeroCuenta;
  String numeroInversion;
  double monto;
  double gananciaEsperada;
  int tiempoMeses;
  double tasaInteres;
  DateTime fechaInicio;
  DateTime fechaVencimiento;
  String estado;

  Inversion({
    required this.numeroCuenta,
    required this.numeroInversion,
    required this.monto,
    required this.gananciaEsperada,
    required this.tiempoMeses,
    required this.tasaInteres,
    required this.fechaInicio,
    required this.fechaVencimiento,
    this.estado = 'Activa',
  });

  /// Convertir la inversión a un mapa (para guardar en base de datos)
  Map<String, dynamic> toMap() {
    return {
      'numeroCuenta': numeroCuenta,
      'numeroInversion': numeroInversion,
      'monto': monto,
      'gananciaEsperada': gananciaEsperada,
      'tiempoMeses': tiempoMeses,
      'tasaInteres': tasaInteres,
      'fechaInicio': fechaInicio.toIso8601String(),
      'fechaVencimiento': fechaVencimiento.toIso8601String(),
      'estado': estado,
    };
  }

  /// Crear una inversión desde un mapa (para leer de la base de datos)
  // factory Inversion.fromMap(Map<String, dynamic> map) {
  //   return Inversion(
  //     numeroCuenta: map['numeroCuenta'],
  //     numeroInversion: map['numeroInversion'],
  //     monto: map['monto'],
  //     gananciaEsperada: map['gananciaEsperada'],
  //     tiempoMeses: map['tiempoMeses'],
  //     tasaInteres: map['tasaInteres'],
  //     fechaInicio: DateTime.parse(map['fechaInicio']),
  //     fechaVencimiento: DateTime.parse(map['fechaVencimiento']),
  //     estado: map['estado'],
  //   );
  // }

  factory Inversion.fromMap(Map<String, dynamic> map) {
    return Inversion(
      numeroCuenta: map['numerocuenta'] ?? '',
      numeroInversion: map['numeroinversion'] ?? '',
      monto: (map['monto'] ?? 0).toDouble(),
      gananciaEsperada: (map['gananciaesperada'] ?? 0).toDouble(),
      tiempoMeses: map['tiempomeses'] ?? 0,
      tasaInteres: (map['tasainteres'] ?? 0).toDouble(),
      fechaInicio: map['fechainicio'] != null ? DateTime.parse(map['fechainicio']) : DateTime.now(),
      fechaVencimiento: map['fechavencimiento'] != null ? DateTime.parse(map['fechavencimiento']) : DateTime.now(),
      estado: map['estado'] ?? 'Activa',
    );
  }




}
