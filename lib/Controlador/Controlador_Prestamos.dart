import 'package:supabase_flutter/supabase_flutter.dart';
import '../Modelo/Prestamo.dart';

class ControladorPrestamos {
  final SupabaseClient supabase = Supabase.instance.client;


Future<List<Prestamo>> obtenerPrestamos() async {
  final List<dynamic> data = await supabase
      .from('prestamos')
      .select()
      .eq('numerocuenta', 1);

  if (data.isEmpty) {
    print("No hay prestamos");
    return [];
  }else{
    print("Prestamos obtenidos: ${data.length}");
  }

  return data.map((prestamo) => Prestamo.fromMap(prestamo)).toList();
}

}