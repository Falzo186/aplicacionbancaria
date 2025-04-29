

import 'package:supabase_flutter/supabase_flutter.dart';

import '../Modelo/Estadistica.dart';

class ControladorEstadistica {
  final supabase = Supabase.instance.client;

Future<Estadistica?> obtenerEstadisticaPorId(String usuarioId) async {
  print("Obteniendo estadística para el usuario: $usuarioId");
  try {
    final data = await supabase
        .from('estadisticas')
        .select()
        .eq('id', usuarioId)
        .maybeSingle();

    if (data != null) {
      print('Estadística encontrada para el usuario $usuarioId: $data');
      return Estadistica.fromMap(data);
    } else {
      print('No se encontró estadística para el usuario $usuarioId.');
      return null;
    }
  } catch (e) {
    print('Error al obtener estadística para el usuario $usuarioId: $e');
    return null;
  }
}


  Future<bool> actualizarEstadistica(Estadistica estadistica) async {
    try {
      final response = await supabase
          .from('estadisticas')
          .update(estadistica.toMap())
          .eq('id', estadistica.id);

      return response != null && response.isNotEmpty;
    } catch (e) {
      print('Error al actualizar la estadística: $e');
      return false;
    }
  }


Future<List<Estadistica>> obtenerTodasLasEstadisticas() async {
 print("HOLAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
  try {
    final response = await supabase.from('estadisticas').select();
    print("HOLAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    print(response); // <--- aquí

    if (response != null && response is List) {
      return response.map((e) => Estadistica.fromMap(e)).toList();
    }
    return [];
  } catch (e) {
    print('Error al obtener todas las estadísticas: $e');
    return [];
  }
}

  
}