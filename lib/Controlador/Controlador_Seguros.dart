import 'package:supabase_flutter/supabase_flutter.dart';
import '../Modelo/Seguro.dart';

class ControladorSeguros {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Seguro>> obtenerSeguros() async {
    final List<dynamic> data = await supabase
        .from('seguros')
        .select()
        .eq('numerocuenta', 1);

    if (data.isEmpty) {
      print("No hay seguros");
      return [];
    } else {
      print("Seguros obtenidos: ${data.length}");
    }

    return data.map((seguro) => Seguro.fromMap(seguro)).toList();
  }

  Future<List<Seguro>> obtenerSegurosDisponibles() async {
    final List<dynamic> data = await supabase
        .from('seguros')
        .select()
        .eq('estado', 'disponible');

    if (data.isEmpty) {
      print("No hay seguros disponibles");
      return [];
    } else {
      print("Seguros disponibles obtenidos: ${data.length}");
    }

    return data.map((seguro) => Seguro.fromMap(seguro)).toList();
  }

  Future<Seguro?> obtenerSeguro(String numeroPoliza) async {
    final Map<String, dynamic>? data =
        await supabase
            .from('seguros')
            .select()
            .eq('numeropoliza', numeroPoliza)
            .single();

    if (data == null) {
      print("No se encontró un seguro con el número de póliza: $numeroPoliza");
      return null;
    }

    return Seguro.fromMap(data);
  }

  Future<void> agregarSeguro(Seguro seguro) async {
    final Map<String, dynamic> seguroMap = seguro.toMap();

    try {
      await supabase.from('seguros').insert(seguroMap);
      print("Seguro agregado exitosamente");
    } catch (e) {
      print("Error al agregar el seguro: $e");
    }
  }
  Future<void> pausarSeguro(String idSeguro) async {
    try {
      await supabase
          .from('seguros')
          .update({'estado': 'pausado'})
          .eq('id', idSeguro);
      print("Seguro con ID $idSeguro pausado exitosamente");
    } catch (e) {
      print("Error al pausar el seguro con ID $idSeguro: $e");
    }
  }

  Future<void> activarSeguro(String idSeguro) async {
    try {
      await supabase
          .from('seguros')
          .update({'estado': 'disponible'})
          .eq('numeropoliza', idSeguro);
      print("Seguro con ID $idSeguro activado exitosamente");
    } catch (e) {
      print("Error al activar el seguro con ID $idSeguro: $e");
    }
  }



  Future<void> borrarSeguro(String idSeguro) async {
    try {
      await supabase.from('seguros').delete().eq('numeropoliza', idSeguro);
      print("Seguro con ID $idSeguro borrado exitosamente");
    } catch (e) {
      print("Error al borrar el seguro con ID $idSeguro: $e");
    }
  }
}
