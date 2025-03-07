class Usuario {
  String nombre;
  String apellido;
  String correoElectronico;
  String numeroTelefono;
  String direccion;
  String nombreUsuario;
  String contrasena;
  DateTime fechaNacimiento; 
  String numeroIdentificacion; 
  String puestoTrabajo; 

  Usuario({
    required this.nombre,
    required this.apellido,
    required this.correoElectronico,
    required this.numeroTelefono,
    required this.direccion,
    required this.nombreUsuario,
    required this.contrasena,
    required this.fechaNacimiento, 
    required this.numeroIdentificacion, 
    required this.puestoTrabajo, 
  });

  
  void mostrarInformacion() {
    print('Nombre: $nombre $apellido');
    print('Correo Electrónico: $correoElectronico');
    print('Número de Teléfono: $numeroTelefono');
    print('Dirección: $direccion');
    print('Nombre de Usuario: $nombreUsuario');
    print('Fecha de Nacimiento: ${fechaNacimiento.toLocal()}'.split(' ')[0]); 
    print('Número de Identificación: $numeroIdentificacion'); 
    print('Puesto de Trabajo: $puestoTrabajo'); 
  }
}
