class Usuario {
  String nombre;
  String apellido;
  String correoElectronico;
  String numeroTelefono;
  String direccion;
  String nombreUsuario;
  String contrasena;
  String tipoUsuario; // Nuevo campo agregado

  Usuario({
    required this.nombre,
    required this.apellido,
    required this.correoElectronico,
    required this.numeroTelefono,
    required this.direccion,
    required this.nombreUsuario,
    required this.contrasena,
    required this.tipoUsuario, // Nuevo campo agregado
  });

  // Método para mostrar la información del usuario
  void mostrarInformacion() {
    print('Nombre: $nombre $apellido');
    print('Correo Electrónico: $correoElectronico');
    print('Número de Teléfono: $numeroTelefono');
    print('Dirección: $direccion');
    print('Nombre de Usuario: $nombreUsuario');
    print('Tipo de Usuario: $tipoUsuario'); // Mostrar el nuevo campo
  }
}
