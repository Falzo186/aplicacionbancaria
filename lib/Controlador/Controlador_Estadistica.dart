

import 'package:supabase_flutter/supabase_flutter.dart';

import '../Modelo/Estadistica.dart';

class ControladorEstadistica {
  final supabase = Supabase.instance.client;

  Future<Estadistica?> obtenerEstadisticaPorId(String id) async {
    try {
      final response = await supabase
          .from('estadisticas')
          .select()
          .eq('id', id)
          .single();

      if (response != null) {
        return Estadistica.fromMap(response);
      }
      return null;
    } catch (e) {
      print('Error al obtener la estadística: $e');
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
    try {
      final response = await supabase.from('estadisticas').select();

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