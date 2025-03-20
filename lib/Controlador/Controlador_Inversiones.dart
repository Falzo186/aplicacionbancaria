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
}