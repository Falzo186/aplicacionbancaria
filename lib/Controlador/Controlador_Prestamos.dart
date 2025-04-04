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
    } else {
      print("Prestamos obtenidos: ${data.length}");
    }

    return data.map((prestamo) => Prestamo.fromMap(prestamo)).toList();
  }

  Future<Prestamo?> obtenerPrestamo(String numeroPrestamo) async {
    final Map<String, dynamic>? data =
        await supabase
            .from('prestamos')
            .select()
            .eq('numeroprestamo', numeroPrestamo)
            .single();

    if (data == null) {
      print("No se encontró el préstamo con número: $numeroPrestamo");
      return null;
    }
    return Prestamo.fromMap(data);
  }

  Future<void> agregarPrestamo(Prestamo prestamo) async {
    final Map<String, dynamic> prestamoData = prestamo.toMap();

    try {
      await supabase.from('prestamos').insert(prestamoData);
      print("Préstamo agregado exitosamente");
    } catch (e) {
      print("Error al agregar el préstamo: $e");
    }
  }
}
