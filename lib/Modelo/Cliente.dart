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
  });

}
