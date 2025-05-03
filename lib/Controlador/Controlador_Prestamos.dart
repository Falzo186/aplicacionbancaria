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

  Future<List<Prestamo>> obtenerPrestamosDisponibles() async {
    final List<dynamic> data = await supabase
        .from('prestamos')
        .select()
        .eq('estado', 'disponible');

    if (data.isEmpty) {
      print("No hay préstamos disponibles");
      return [];
    } else {
      print("Préstamos disponibles obtenidos: ${data.length}");
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
  Future<void> pausarPrestamo(String idPrestamo) async {
    try {
      await supabase
          .from('prestamos')
          .update({'estado': 'pausado'})
          .eq('numeroprestamo', idPrestamo);
      print("Préstamo con ID $idPrestamo pausado exitosamente");
    } catch (e) {
      print("Error al pausar el préstamo con ID $idPrestamo: $e");
    }
  }
  Future<void> activarPrestamo(String idPrestamo) async {
    try {
      await supabase
          .from('prestamos')
          .update({'estado': 'disponible'})
          .eq('numeroprestamo', idPrestamo);
      print("Préstamo con ID $idPrestamo activado exitosamente");
    } catch (e) {
      print("Error al activar el préstamo con ID $idPrestamo: $e");
    }
  }
  Future<void> borrarPrestamo(String idPrestamo) async {
    try {
      await supabase.from('prestamos').delete().eq('numeroprestamo', idPrestamo);
      print("Préstamo con ID $idPrestamo borrado exitosamente");
    } catch (e) {
      print("Error al borrar el préstamo con ID $idPrestamo: $e");
    }
}

  Future<void> modificarPrestamo(Prestamo prestamo) async {
    final Map<String, dynamic> prestamoData = prestamo.toMap();

    try {
      await supabase
          .from('prestamos')
          .update(prestamoData)
          .eq('numeroprestamo', prestamo.numeroPrestamo);
      print("Préstamo modificado exitosamente");
    } catch (e) {
      print("Error al modificar el préstamo: $e");
    }
  }
}