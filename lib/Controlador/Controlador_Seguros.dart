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
  final Map<String, dynamic>? data = await supabase
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

}