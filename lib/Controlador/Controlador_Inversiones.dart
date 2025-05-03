import 'package:supabase_flutter/supabase_flutter.dart';
import '../Modelo/Inversion.dart';

class ControladorInversiones {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Inversion>> obtenerInversiones() async {
    final List<dynamic> data = await supabase
        .from('inversiones')
        .select()
        .eq('numerocuenta', 1);

    if (data.isEmpty) {
      print("No hay inversiones");
      return [];
    } else {
      print("Inversiones obtenidas: ${data.length}");
    }

    return data.map((inversion) => Inversion.fromMap(inversion)).toList();
  }
  Future<List<Inversion>> obtenerInversionesDisponibles() async {
    final List<dynamic> data = await supabase
        .from('inversiones')
        .select()
        .eq('estado', 'disponible');

    if (data.isEmpty) {
      print("No hay inversiones disponibles");
      return [];
    } else {
      print("Inversiones disponibles obtenidas: ${data.length}");
    }

    return data.map((inversion) => Inversion.fromMap(inversion)).toList();
  }

  Future<Inversion?> obtenerInversion(String numeroInversion) async {
    final Map<String, dynamic>? data = await supabase
        .from('inversiones')
        .select()
        .eq('numeroinversion', numeroInversion)
        .single();

    if (data == null) {
      print("No se encontró la inversión con número: $numeroInversion");
      return null;
    }

    return Inversion.fromMap(data);
  }
  Future<void> agregarInversion(Inversion inversion) async {
    final Map<String, dynamic> inversionData = inversion.toMap();

    final response = await supabase.from('inversiones').insert(inversionData);

    if (response.error != null) {
      print("Error al agregar la inversión: ${response.error!.message}");
    } else {
      print("Inversión agregada exitosamente");
    }
  }

  Future<void> pausarInversion(String idInversion) async {
    try {
      await supabase
          .from('inversiones')
          .update({'estado': 'pausado'})
          .eq('numeroinversion', idInversion);
      print("Inversión con ID $idInversion pausada exitosamente");
    } catch (e) {
      print("Error al pausar la inversión con ID $idInversion: $e");
    }
  }

  Future<void> activarInversion(String idInversion) async {
    try {
      await supabase
          .from('inversiones')
          .update({'estado': 'disponible'})
          .eq('numeroinversion', idInversion);
      print("Inversión con ID $idInversion activada exitosamente");
    } catch (e) {
      print("Error al activar la inversión con ID $idInversion: $e");
    }
  }
  Future<void> borrarInversion(String idInversion) async {
    try {
      await supabase
          .from('inversiones')
          .delete()
          .eq('numeroinversion', idInversion);
      print("Inversión con ID $idInversion borrada exitosamente");
    } catch (e) {
      print("Error al borrar la inversión con ID $idInversion: $e");
    }
  }

}