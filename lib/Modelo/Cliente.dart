
import 'package:postgrest/src/types.dart';

class Cliente {
  // Información Personal
  String numeroCuenta;
  String nombreCompleto;
  String genero;
  DateTime fechaNacimiento;
  String identificacionOficial;
  String? rfc;
  String estadoCivil;
  String nacionalidad;
  String direccionCompleta;
  String telefono;
  String correoElectronico;

  // Información Laboral y Económica
  String ocupacion;
  String empresa;
  String direccionEmpresa;
  String telefonoEmpresa;
  double ingresosMensuales;
  String fuenteIngresos;

  // Información Financiera
  bool tieneCredito; // Indica si el cliente tiene crédito o no
  bool tieneSeguro; // Indica si el cliente tiene seguro o no
  bool tienePrestamo; // Indica si el cliente tiene prestamo o no

  Cliente({
    required this.numeroCuenta,
    required this.nombreCompleto,
    required this.genero,
    required this.fechaNacimiento,
    required this.identificacionOficial,
    this.rfc,
    required this.estadoCivil,
    required this.nacionalidad,
    required this.direccionCompleta,
    required this.telefono,
    required this.correoElectronico,
    required this.ocupacion,
    required this.empresa,
    required this.direccionEmpresa,
    required this.telefonoEmpresa,
    required this.ingresosMensuales,
    required this.fuenteIngresos,
    required this.tieneCredito,
    required this.tieneSeguro,
    required this.tienePrestamo,
  });

static Cliente fromMap(Map<String, dynamic> map) {
  return Cliente(
    numeroCuenta: map['numerocuenta'] ?? '',
    nombreCompleto: map['nombrecompleto'] ?? '',
    genero: map['genero'] ?? '',
    fechaNacimiento: map['fechanacimiento'] != null
        ? DateTime.tryParse(map['fechanacimiento']) ?? DateTime(2000, 1, 1)
        : DateTime(2000, 1, 1),
    identificacionOficial: map['identificacionoficial'] ?? '',
    rfc: map['rfc'] ?? '',
    estadoCivil: map['estadocivil'] ?? '',
    nacionalidad: map['nacionalidad'] ?? '',
    direccionCompleta: map['direccioncompleta'] ?? '',
    telefono: map['telefono'] ?? '',
    correoElectronico: map['correoelectronico'] ?? '',
    ocupacion: map['ocupacion'] ?? '',
    empresa: map['empresa'] ?? '',
    direccionEmpresa: map['direccionempresa'] ?? '',
    telefonoEmpresa: map['telefonoempresa'] ?? '',
    ingresosMensuales: (map['ingresosmensuales'] as num?)?.toDouble() ?? 0.0,
    fuenteIngresos: map['fuenteingresos'] ?? '',
    tieneCredito: (map['tienecredito'] as bool?) ?? false,
    tieneSeguro: (map['tieneseguro'] as bool?) ?? false,
    tienePrestamo: (map['tieneprestamo'] as bool?) ?? false,
  );
}

  
  @override
  String toString() {
    return 'Cliente{numeroCuenta: $numeroCuenta, nombreCompleto: $nombreCompleto, genero: $genero, fechaNacimiento: $fechaNacimiento, identificacionOficial: $identificacionOficial, rfc: $rfc, estadoCivil: $estadoCivil, nacionalidad: $nacionalidad, direccionCompleta: $direccionCompleta, telefono: $telefono, correoElectronico: $correoElectronico, ocupacion: $ocupacion, empresa: $empresa, direccionEmpresa: $direccionEmpresa, telefonoEmpresa: $telefonoEmpresa, ingresosMensuales: $ingresosMensuales, fuenteIngresos: $fuenteIngresos, tieneCredito: $tieneCredito, tieneSeguro: $tieneSeguro, tienePrestamo: $tienePrestamo}';
  }



}
