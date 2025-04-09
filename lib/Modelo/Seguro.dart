class Seguro {
  String numeroCuenta; //1
  String numeroPoliza; //ingresa
  int meses; //ingresa
  double costo; //ingresa
  double tasaInteres; //ingresa
  double costoTotal;
  double montoFaltante;
  double pagoMensual;
  int pagosRealizados;
  String tipoSeguro; //ingresa
  double montoCobertura; //ingresa
  DateTime fechaInicio; //ingresa
  DateTime fechaVencimiento;

  String estado; //disponible
  String? numeroSiniestro;
  String? descripcionCobertura; //ingresa

  DateTime fechaPago; // Fecha del próximo pago
  double interesAtraso = 0.25; // 25% de interés por cada mes de atraso

  Seguro({
    required this.numeroCuenta,
    required this.numeroPoliza,
    required this.costo,
    required this.meses,
    required this.tasaInteres,
    required this.pagosRealizados,
    required this.tipoSeguro,
    required this.montoCobertura,
    required this.fechaInicio,
    required this.fechaVencimiento,
    required this.fechaPago,
    this.estado = "Activo",
    this.numeroSiniestro,
    this.descripcionCobertura,
  }) : costoTotal = costo * (1 + tasaInteres),
       pagoMensual = ((costo * (1 + tasaInteres)) / meses),
       montoFaltante = costo * (1 + tasaInteres);

  factory Seguro.fromMap(Map<String, dynamic> map) {
    return Seguro(
      numeroCuenta: map['numerocuenta'],
      numeroPoliza: map['numeropoliza'],
      costo: map['costo'],
      meses: map['meses'],
      tasaInteres: map['tasainteres'],
      pagosRealizados: map['pagosrealizados'],
      tipoSeguro: map['tiposeguro'],
      montoCobertura: map['montocobertura'],
      fechaInicio: DateTime.parse(map['fechainicio']),
      fechaVencimiento: DateTime.parse(map['fechavencimiento']),
      fechaPago: DateTime.parse(map['fechapago']),
      estado: map['estado'] ?? "Activo",
      numeroSiniestro: map['numerosiniestro'],
      descripcionCobertura: map['descripcioncobertura'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'numerocuenta': numeroCuenta,
      'numeropoliza': numeroPoliza,
      'costo': costo,
      'meses': meses,
      'tasainteres': tasaInteres,
      'pagosrealizados': pagosRealizados,
      'tiposeguro': tipoSeguro,
      'montocobertura': montoCobertura,
      'fechainicio': fechaInicio.toIso8601String(),
      'fechavencimiento': fechaVencimiento.toIso8601String(),
      'fechapago': fechaPago.toIso8601String(),
      'estado': estado,
      'numerosiniestro': numeroSiniestro,
      'descripcioncobertura': descripcionCobertura,
    };
  }

  // Método para verificar el estado del pago y calcular intereses si está atrasado
  void verificarEstadoPago() {
    DateTime hoy = DateTime.now();
    int diasDiferencia = hoy.difference(fechaPago).inDays;

    if (diasDiferencia > 0) {
      // Cálculo de meses de atraso
      int mesesAtraso = (diasDiferencia / 30).ceil();
      double interesTotal = pagoMensual * interesAtraso * mesesAtraso;
      print(
        "¡Pago atrasado por $mesesAtraso mes(es)! Se aplicará un interés de: \$${interesTotal.toStringAsFixed(2)}",
      );
    } else {
      print(
        "Pago al día. Faltan ${-diasDiferencia} días para el próximo pago.",
      );
    }
  }

  // Método para realizar un pago
  void realizarPago(double monto) {
    verificarEstadoPago(); // Verifica si hay atraso antes de procesar el pago
    double totalPagar = monto;

    DateTime hoy = DateTime.now();
    int diasDiferencia = hoy.difference(fechaPago).inDays;

    if (diasDiferencia > 0) {
      int mesesAtraso = (diasDiferencia / 30).ceil();
      double interesTotal = pagoMensual * interesAtraso * mesesAtraso;
      totalPagar += interesTotal;
    }

    montoFaltante -= totalPagar;
    pagosRealizados++;
    fechaPago = DateTime(fechaPago.year, fechaPago.month + 1, fechaPago.day);

    print("Pago realizado de: \$${totalPagar.toStringAsFixed(2)}");
    print("Monto restante: \$${montoFaltante.toStringAsFixed(2)}");
  }
}
