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
  // cambiooo
  Future<void> realizarInversion(String numeroCuenta, String numeroInversion) async {
    final supabase = Supabase.instance.client;

    try {
      // Obtener la inversión por su número
      final inversionData = await supabase
          .from('inversiones')
          .select()
          .eq('numeroinversion', numeroInversion)
          .single();

      if (inversionData == null) {
        throw Exception('No se encontró la inversión con el número $numeroInversion');
      }

      final montoInversion = inversionData['monto'] as double;

      // Obtener la cuenta del cliente
      final cuentaData = await supabase
          .from('cuentasclientes')
          .select()
          .eq('numerocuenta', numeroCuenta)
          .single();

      if (cuentaData == null) {
        throw Exception('No se encontró la cuenta con el número $numeroCuenta');
      }

      final saldoActual = cuentaData['saldo'] as double;

      // Verificar si el saldo es suficiente
      if (saldoActual >= montoInversion) {
        // Descontar el monto de la cuenta del cliente
        await supabase.from('cuentasclientes').update({
          'saldo': saldoActual - montoInversion,
        }).eq('numerocuenta', numeroCuenta);

        // Actualizar el estado de la inversión y la fecha de inicio
        await supabase.from('inversiones').update({
          'estado': 'Activo',
          'numerocuenta': numeroCuenta,
          'fechainicio': DateTime.now().toIso8601String(),
        }).eq('numeroinversion', numeroInversion);

        print('Inversión realizada con éxito.');
      } else {
        throw Exception('Saldo insuficiente para realizar la inversión.');
      }
    } catch (e) {
      print('Error al realizar la inversión: $e');
    }
  }





  Future<void> realizarPrestamo(String numeroCuenta, String numeroPrestamo) async {
    final supabase = Supabase.instance.client;

    try {
      // Obtener el préstamo por su número
      final prestamoData = await supabase
          .from('prestamos')
          .select()
          .eq('numeroprestamo', numeroPrestamo)
          .single();

      if (prestamoData == null) {
        throw Exception('No se encontró el préstamo con el número $numeroPrestamo');
      }

      final montoPrestamo = prestamoData['monto'] as double;

      try {
        // Obtener la cuenta del cliente
        final cuentaData = await supabase
            .from('cuentasclientes')
            .select()
            .eq('numerocuenta', numeroCuenta)
            .single();

        if (cuentaData == null) {
          throw Exception('No se encontró la cuenta con el número $numeroCuenta');
        }

        final saldoActual = cuentaData['saldo'] as double;

        try {
          // Actualizar la cuenta del cliente
          await supabase.from('cuentasclientes').update({
            'saldo': saldoActual + montoPrestamo,
          }).eq('numerocuenta', numeroCuenta);

          await supabase.from('clientes').update({
            'tieneprestamo': true,
          }).eq('numerocuenta', numeroCuenta);

          try {
            // Calcular la fecha de inicio y la próxima fecha de pago
            DateTime fechaInicio = DateTime.now();
            DateTime proximaFechaPago = DateTime(
              fechaInicio.year,
              fechaInicio.month + 1,
              fechaInicio.day,
            );

            // Ajustar si la próxima fecha de pago cae en sábado o domingo
            if (proximaFechaPago.weekday == DateTime.saturday) {
              proximaFechaPago = proximaFechaPago.subtract(Duration(days: 1)); // Mover al viernes
            } else if (proximaFechaPago.weekday == DateTime.sunday) {
              proximaFechaPago = proximaFechaPago.subtract(Duration(days: 2)); // Mover al viernes
            }

            // Actualizar el estado del préstamo
            await supabase.from('prestamos').update({
              'estado': 'Activo',
              'numerocuenta': numeroCuenta,
              'fechainicio': fechaInicio.toIso8601String(),
              'fechapago': proximaFechaPago.toIso8601String(),
            }).eq('numeroprestamo', numeroPrestamo);

            print('Préstamo realizado con éxito.');
          } catch (e) {
            print('Error al actualizar el estado del préstamo: $e');
          }
        } catch (e) {
          print('Error al actualizar la cuenta del cliente: $e');
        }
      } catch (e) {
        print('Error al obtener la cuenta del cliente: $e');
      }
    } catch (e) {
      print('Error al obtener el préstamo: $e');
    }
  }

  
  Future<void> realizarSeguro(String numeroSeguro, String numeroCuenta) async {
    final supabase = Supabase.instance.client;

    try {
      // Calcular fechas
      DateTime fechaInicio = DateTime.now();
      DateTime fechaVencimiento = DateTime(fechaInicio.year + 1, fechaInicio.month, fechaInicio.day);
      DateTime fechaPago = DateTime(fechaInicio.year, fechaInicio.month + 1, fechaInicio.day);

      // Ajustar fecha de pago si cae en sábado o domingo
      if (fechaPago.weekday == DateTime.saturday) {
        fechaPago = fechaPago.subtract(Duration(days: 1)); // Mover al viernes
      } else if (fechaPago.weekday == DateTime.sunday) {
        fechaPago = fechaPago.subtract(Duration(days: 2)); // Mover al viernes
      }

      // Actualizar el seguro
      final response = await supabase.from('seguros').update({
        'estado': 'Activo',
        'numerocuenta': numeroCuenta,
        'fechainicio': fechaInicio.toIso8601String(),
        'fechavencimiento': fechaVencimiento.toIso8601String(),
        'fechapago': fechaPago.toIso8601String(),
      }).eq('numeropoliza', numeroSeguro);

      if (response == null || response.isEmpty) {
        throw Exception('No se encontró el seguro con el número $numeroSeguro.');
      }

      // Actualizar el cliente
      await supabase.from('clientes').update({
        'tieneseguro': true,
      }).eq('numerocuenta', numeroCuenta);

      print('Seguro actualizado con éxito.');
    } catch (e) {
      print('Error al actualizar el seguro: $e');
    }
  }














  Future<void> actualizarEstadoReporte(String numeroReporte, String nuevoEstado) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('reportessolicitudes')
          .update({'estado': nuevoEstado})
          .eq('idsolicitud', numeroReporte);

      if (response == null || response.isEmpty) {
        throw Exception('No se encontró el reporte con el número $numeroReporte.');
      }

      print('Estado del reporte actualizado con éxito.');
    } catch (e) {
      print('Error al actualizar el estado del reporte: $e');
    }
  }
  
}