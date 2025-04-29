class Empleado {
  String id;
  String nombreEmpleado;
  String sexo;
  DateTime fechaCumpleanos;
  String rfc;
  String direccion;
  String numeroTelefono;
  String estadoCivil;
  String puestoTrabajo;
  String correoElectronico;
  String numeroIdentificacionOficial;

  Empleado({
    required this.id,
    required this.nombreEmpleado,
    required this.sexo,
    required this.fechaCumpleanos,
    required this.rfc,
    required this.direccion,
    required this.numeroTelefono,
    required this.estadoCivil,
    required this.puestoTrabajo,
    required this.correoElectronico,
    required this.numeroIdentificacionOficial,
  });
  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['idempleado'],
      nombreEmpleado: json['nombreempleado'],
      sexo: json['sexo'],
      fechaCumpleanos: DateTime.parse(json['fechacumpleanos']),
      rfc: json['rfc'],
      direccion: json['direccion'],
      numeroTelefono: json['numerotelefono'],
      estadoCivil: json['estadocivil'],
      puestoTrabajo: json['puestotrabajo'],
      correoElectronico: json['correoelectronico'],
      numeroIdentificacionOficial: json['numeroidentificacionoficial'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'idempleado': id,
      'nombreempleado': nombreEmpleado,
      'sexo': sexo,
      'fechacumpleanos': fechaCumpleanos.toIso8601String(),
      'rfc': rfc,
      'direccion': direccion,
      'numerotelefono': numeroTelefono,
      'estadocivil': estadoCivil,
      'puestotrabajo': puestoTrabajo,
      'correoelectronico': correoElectronico,
      'numeroidentificacion_oficial': numeroIdentificacionOficial,
    };
  }

}
