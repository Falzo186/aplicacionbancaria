import 'package:supabase_flutter/supabase_flutter.dart';

class ControladorNotificaciones {
final supabase = Supabase.instance.client;

Future<void> enviarNotificacion(String usuarioId, String adminId, String mensaje) async {
  final response = await supabase.from('notificaciones').insert({
    'usuario_id': usuarioId,
    'admin_id': adminId,
    'mensaje': mensaje,
  });

  if (response.error != null) {
    print('Error al enviar la notificación: ${response.error!.message}');
  }
}
}