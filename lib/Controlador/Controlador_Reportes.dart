import 'package:supabase_flutter/supabase_flutter.dart';

import '../Modelo/ReporteSolicitud.dart';

class ControladorReportes {


  Future<void> subirReporte(ReporteSolicitud reporte) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase.from('reportessolicitudes').insert(reporte.toMap());

      if (response.error != null) {
        throw Exception('Error al subir el reporte: ${response.error!.message}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  

  Future<List<ReporteSolicitud>> obtenerReportesSegurosPendientes() async {
    final supabase = Supabase.instance.client;

    try {
      final data = await supabase
          .from('reportessolicitudes')
          .select()
          .eq('tiposolicitud', 'Seguro')
          .eq('estado', 'Pendiente');

      return (data as List<dynamic>)
          .map((json) => ReporteSolicitud.fromMap(json))
          .toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }



  Future<List<ReporteSolicitud>> obtenerReportesInversionesPendientes() async {
    final supabase = Supabase.instance.client;

    try {
      final data = await supabase
          .from('reportessolicitudes')
          .select()
          .eq('tiposolicitud', 'Inversion')
          .eq('estado', 'Pendiente');

      return (data as List<dynamic>)
          .map((json) => ReporteSolicitud.fromMap(json))
          .toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<ReporteSolicitud>> obtenerReportesPrestamoPendientes() async {
    final supabase = Supabase.instance.client;

    try {
      final data = await supabase
          .from('reportessolicitudes')
          .select()
          .eq('tiposolicitud', 'Prestamo')
          .eq('estado', 'Pendiente');

      return (data as List<dynamic>)
          .map((json) => ReporteSolicitud.fromMap(json))
          .toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
  
  Future<List<ReporteSolicitud>> obtenerReportesPorUsuario(String usuarioId) async {
    final supabase = Supabase.instance.client;

    try {
      final data = await supabase
          .from('reportessolicitudes')
          .select()
          .eq('usuarioid', usuarioId);

      if (data != null && data.isNotEmpty) {
        print('Reportes encontrados para el usuario $usuarioId: $data');
        return (data as List<dynamic>)
            .map((json) => ReporteSolicitud.fromMap(json))
            .toList();
      } else {
        print('No se encontraron reportes para el usuario $usuarioId.');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  
}