class Usuario {
  String idUsuario;
  String nombreUsuario;
  String contrasena;
  String departamento;
  String idempleado;

  Usuario({
    required this.idUsuario,
    required this.nombreUsuario,
    required this.contrasena,
    required this.departamento,
    required this.idempleado,
  });
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idusuario'],
      nombreUsuario: json['nombreusuario'],
      contrasena: json['contrasena'],
      idempleado: json['idempleado'],
      departamento: json['departamento'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idusuario': idUsuario, 
      'nombreusuario': nombreUsuario,
      'contrasena': contrasena,
      'idempleado': idempleado,
      'departamento': departamento,
    };
  }

}
