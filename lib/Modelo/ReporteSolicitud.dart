class ReporteSolicitud {
  String idSolicitud;      // ID único de la solicitud
  String usuarioId;        // ID del usuario que hizo la solicitud
  String usuarioNombre;    // Nombre del usuario que hizo la solicitud
  String tipoSolicitud;    // Tipo de solicitud: Préstamo, Seguro, Inversión
  String clienteId;        // ID del cliente afectado
  String clienteNombre;    // Nombre del cliente afectado
  String idsolicitado;    // ID del tipo de trasaccion solicitada
  String estado;         // Estado de la solicitud: Pendiente, Aprobada, Rechazada
  DateTime fechaSolicitud; // Fecha y hora de la solicitud


  ReporteSolicitud({
    required this.idSolicitud,
    required this.usuarioId,
    required this.usuarioNombre,
    required this.tipoSolicitud,
    required this.clienteId,
    required this.clienteNombre,
    required this.idsolicitado,
    required this.estado,
    required this.fechaSolicitud,
  });

  // Convertir a Map para almacenar en base de datos
  Map<String, dynamic> toMap() {
    return {
      'idsolicitud': idSolicitud,
      'usuarioid': usuarioId,
      'usuarionombre': usuarioNombre,
      'tiposolicitud': tipoSolicitud,
      'clienteid': clienteId,
      'clientenombre': clienteNombre,
      'idsolicitado': idsolicitado,
      'estado': estado,
      'fechasolicitud': fechaSolicitud.toIso8601String(),
    };
  }

  // Crear un objeto desde un Map (cuando se lee de la base de datos)
  factory ReporteSolicitud.fromMap(Map<String, dynamic> map) {
    return ReporteSolicitud(
      idSolicitud: map['idsolicitud'],
      usuarioId: map['usuarioid'],
      usuarioNombre: map['usuarionombre'],
      tipoSolicitud: map['tiposolicitud'],
      clienteId: map['clienteid'],
      clienteNombre: map['clientenombre'],
      idsolicitado: map['idsolicitado'],
      estado: map['estado'] ?? 'Pendiente', // Valor por defecto
      fechaSolicitud: DateTime.parse(map['fechasolicitud']),
    );
  }
}
