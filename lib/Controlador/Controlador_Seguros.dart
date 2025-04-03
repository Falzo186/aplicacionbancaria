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

  Future<Seguro?> obtenerSeguro(String numeroPoliza) async {
    final Map<String, dynamic>? data =
        await supabase
            .from('seguros')
            .select()
            .eq('numeropoliza', numeroPoliza)
            .single();

    if (data == null) {
      print("No se encontró el seguro con número de póliza: $numeroPoliza");
      return null;
    }

    return Seguro.fromMap(data);
  }

  Future<void> agregarSeguro(Seguro seguro) async {
    final Map<String, dynamic> seguroData = seguro.toMap();

    final response = await supabase.from('seguros').insert(seguroData);

    if (response.error != null) {
      print("Error al agregar el seguro: ${response.error!.message}");
    } else {
      print("Seguro agregado exitosamente");
    }
  }
}
