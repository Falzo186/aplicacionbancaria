class Prestamo {
  String numeroPrestamo;
  String numeroCuenta;
  double monto;
  int meses;
  int pagosRealizados;
  double tasaInteres; // Interés mensual (Ejemplo: 0.05 para 5%)
  DateTime fechaInicio;
  DateTime fechapago; // Fecha del próximo pago
  int diasPago; // Día del mes en que se debe pagar
  String estado; // Pendiente, Pagado, Atrasado
  double pagoMinimo;
  double interesAtraso = 0.25; // 25% de interés por mes de atraso
  double montoRestante;

 

  Prestamo({
    required this.numeroCuenta,
    required this.numeroPrestamo,
    required this.monto,
    required this.meses,
    required this.pagosRealizados,
    required this.tasaInteres,
    required this.fechaInicio,
    required this.fechapago,
    required this.diasPago,
    this.estado = "Activo",
  })  : pagoMinimo = (monto * (1 + tasaInteres)) / meses,
        montoRestante = monto * (1 + tasaInteres);


        // Método para verificar si hay atraso y aplicar intereses
  void verificarEstadoPago() {
    DateTime hoy = DateTime.now();
    int diasDiferencia = hoy.difference(fechapago).inDays;
    if (diasDiferencia > 0) {
      int mesesAtraso = (diasDiferencia / 30).ceil();
      double interesTotal = pagoMinimo * interesAtraso * mesesAtraso;
      print("¡Pago atrasado por $mesesAtraso mes(es)! Se aplicará un interés de: \$${interesTotal.toStringAsFixed(2)}");
      estado = "Atrasado";
    } else {
      print("Pago al día. Faltan ${-diasDiferencia} días para el próximo pago.");
      estado = "Pendiente";
    }
  }
  factory Prestamo.fromMap(Map<String, dynamic> map) {
    return Prestamo(
      numeroCuenta: map['numerocuenta'],
      numeroPrestamo: map['numeroprestamo'],
      monto: map['monto'],
      meses: map['meses'],
      pagosRealizados: map['pagosrealizados'],
      tasaInteres: map['tasainteres'],
      fechaInicio: DateTime.parse(map['fechainicio']),
      fechapago: DateTime.parse(map['fechapago']),
      diasPago: map['diaspago'],
      estado: map['estado'] ?? "En Pausa",
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'numerocuenta': numeroCuenta,
      'numeroprestamo': numeroPrestamo,
      'monto': monto,
      'meses': meses,
      'pagosrealizados': pagosRealizados,
      'tasainteres': tasaInteres,
      'fechainicio': fechaInicio.toIso8601String(),
      'fechapago': fechapago.toIso8601String(),
      'diaspago': diasPago,
      'estado': estado,
    };
  }


  // Método para realizar un pago
  void realizarPago(double montoPago) {
    verificarEstadoPago(); // Verifica si está atrasado

    double totalPagar = montoPago;
    DateTime hoy = DateTime.now();
    int diasDiferencia = hoy.difference(fechapago).inDays;

    if (diasDiferencia > 0) {
      int mesesAtraso = (diasDiferencia / 30).ceil();
      double interesTotal = pagoMinimo * interesAtraso * mesesAtraso;
      totalPagar += interesTotal;
    }

    montoRestante -= totalPagar;
    pagosRealizados++;
    fechapago = DateTime(fechapago.year, fechapago.month + 1, diasPago);

    print("Pago realizado de: \$${totalPagar.toStringAsFixed(2)}");
    print("Monto restante: \$${montoRestante.toStringAsFixed(2)}");

    if (montoRestante <= 0) {
      estado = "Pagado";
      print("¡Préstamo completado!");
    }
  }
}
