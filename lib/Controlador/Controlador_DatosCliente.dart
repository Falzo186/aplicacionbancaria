import 'package:aplicacionbancaria/Modelo/Inversion.dart';
import '../Modelo/Cliente.dart';
import '../Modelo/CuentaCliente.dart';
import '../Modelo/CuentaCredito.dart';
import '../Modelo/Prestamo.dart';
import '../Modelo/Seguro.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Modelo/Transferencia.dart';

class ControladorDatoscliente {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Cliente?> buscarCliente(String numeroCuenta) async {
    final response =
        await supabase
            .from('clientes')
            .select()
            .eq('numerocuenta', numeroCuenta)
            .single();

    if (response == null) {
      return null;
    }

    return Cliente.fromMap(response);
  }

  Future<Inversion?> buscarInversion(String numeroCuenta) async {
    final response = await supabase
        .from('inversiones')
        .select()
        .eq('numerocuenta', numeroCuenta)
        .maybeSingle();

    if (response == null) {
      print("Inversión no encontrada para la cuenta: $numeroCuenta");
      return null;
    }

    print("Inversión encontrada para la cuenta: $numeroCuenta");
    return Inversion.fromMap(response);
  }

  Future<void> actualizarCuentaCliente(CuentaCliente cuentaCliente) async {
    try {
      await supabase
          .from('cuentasclientes')
          .update(cuentaCliente.toMap())
          .eq('numerocuenta', cuentaCliente.numeroCuenta);
    } catch (e) {
      throw Exception('Error al actualizar la cuenta del cliente: $e');
    }
  }

Future<void> guardarTransferencia(Transferencia transferencia) async {
  try {
    await supabase.from('transferencias').insert({
      'numerocuenta': transferencia.numeroCuenta,
      'numerotransferencia': transferencia.numeroTransferencia,
      'numerocuentaorigen': transferencia.numeroCuentaOrigen,
      'numerocuentadestino': transferencia.numeroCuentaDestino,
      'monto': transferencia.monto,
      'fechatransferencia': transferencia.fechaTransferencia.toIso8601String(),
      'tipotransferencia': transferencia.tipoTransferencia,
      'estado': transferencia.estado,
      'referencia': transferencia.referencia,
      'nombredestinatario': transferencia.nombreDestinatario,
    });
  } catch (e) {
    throw Exception('Error al guardar la transferencia: $e');
  }
}


Future<List<Transferencia>> obtenerTransferenciasPorCuenta(String numeroCuenta) async {
  final response = await supabase
      .from('transferencias')
      .select()
      .eq('numerocuenta', numeroCuenta);

  if (response.isEmpty) {
    return [];
  }

  return response.map((transferencia) {
    return Transferencia(
      numeroCuenta: transferencia['numerocuenta'],
      numeroTransferencia: transferencia['numerotransferencia'],
      numeroCuentaOrigen: transferencia['numerocuentaorigen'],
      numeroCuentaDestino: transferencia['numerocuentadestino'],
      monto: (transferencia['monto'] as num).toDouble(),
      fechaTransferencia: DateTime.parse(transferencia['fechatransferencia']),
      tipoTransferencia: transferencia['tipotransferencia'],
      estado: transferencia['estado'],
      referencia: transferencia['referencia'],
      nombreDestinatario: transferencia['nombredestinatario'],
    );
  }).toList();
}



  Future<void> CrearCliente(Cliente cliente) async {
    try {
      await supabase.from('clientes').upsert(cliente.toMap());
    } catch (e) {
      throw Exception('Error al crear el cliente: $e');
    }
  }

  Future<void> CrearCuenta(CuentaCliente cuentaCliente) async {
    try {
      await supabase.from('cuentasclientes').upsert(cuentaCliente.toMap());
    } catch (e) {
      throw Exception('Error al crear la cuenta del cliente: $e');
    }
  }

  Future<DateTime?> obtenerFechaApertura(String numeroCuenta) async {
    print("Buscando fecha de apertura para la cuenta: $numeroCuenta");
    final response =
        await supabase
            .from('cuentasclientes')
            .select('fechaapertura')
            .eq('numerocuenta', numeroCuenta)
            .single();

    if (response == null || response['fechaapertura'] == null) {
      return null;
    }

    return DateTime.parse(response['fechaapertura']);
  }

  Future<List<Cliente>> obtenerClientes() async {
    final response = await supabase.from('clientes').select();

    if (response.isEmpty) {
      print("No hay clientes");
      return [];
    }

    List<Cliente> clientes = [];

    for (var clienteData in response) {
      try {
        // Verificar si los datos tienen la estructura correcta
        print("Datos recibidos: $clienteData");

        Cliente cliente = Cliente.fromMap(clienteData);
        clientes.add(cliente);
      } catch (e) {
        print("Error al convertir cliente: $e");
      }
    }

    print("Clientes obtenidos: ${clientes.length}");
    return clientes;
  }

  Future<CuentaCliente?> buscarCuentaCliente(String numeroCuenta) async {
    final response =
        await supabase
            .from('cuentasclientes')
            .select()
            .eq('numerocuenta', numeroCuenta)
            .limit(1)
            .maybeSingle();

    if (response == null) {
      return null;
    }

    try {
      return CuentaCliente.fromMap(response);
    } catch (e) {
      rethrow;
    }
  }

  CuentaCredito? buscarCuentaCredito(String numeroCuenta) {
    return CuentaCredito(
      numeroCuenta: numeroCuenta,
      limiteCredito: 20000.0,
      saldoDeuda: 5000.0,
      fechaAprobacion: DateTime(2022, 3, 15),
      estadoCredito: "Activo",
    );
  }

  Future<Prestamo?> buscarPrestamo(String numeroCuenta) async {
    final response =
        await supabase
            .from('prestamos')
            .select()
            .eq('numerocuenta', numeroCuenta)
            .single();

    if (response == null) {
      return null;
    }

    return Prestamo.fromMap(response);
  }

  Future<Seguro?> buscarSeguro(String numeroCuenta) async {
    final response =
        await supabase
            .from('seguros')
            .select()
            .eq('numerocuenta', numeroCuenta)
            .single();

    if (response == null) {
      return null;
    }

    return Seguro.fromMap(response);
  }

  Future<void> actualizarSeguro(Seguro seguro) async {
    final response =
        await supabase
            .from('seguros')
            .update(seguro.toMap())
            .eq('numerocuenta', seguro.numeroCuenta)
            .select(); // <- opcional si quieres devolver los datos actualizados

    if (response.isEmpty) {
      throw Exception(
        'Error al actualizar el seguro: respuesta vacía del servidor',
      );
    }
  }

  Future<void> actualizarPrestamo(Prestamo prestamo) async {
    try {
      await supabase
          .from('prestamos')
          .update(prestamo.toMap())
          .eq('numerocuenta', prestamo.numeroCuenta);
    } catch (e) {
      throw Exception('Error al actualizar el préstamo: $e');
    }
  }


  Future<List<Prestamo>> buscarPrestamosPorCuenta(String numeroCuenta) async {
    final response = await supabase
        .from('prestamos')
        .select()
        .eq('numerocuenta', numeroCuenta);

    if (response.isEmpty) {
      return [];
    }

    return response.map((prestamo) => Prestamo.fromMap(prestamo)).toList();
  }

  Future<List<Seguro>> buscarSegurosPorCuenta(String numeroCuenta) async {
    final response = await supabase
        .from('seguros')
        .select()
        .eq('numerocuenta', numeroCuenta);

    if (response.isEmpty) {
      return [];
    }

    return response.map((seguro) => Seguro.fromMap(seguro)).toList();
  }

  Future<List<Inversion>> buscarInversionesPorCuenta(
    String numeroCuenta,
  ) async {
    final response = await supabase
        .from('inversiones')
        .select()
        .eq('numerocuenta', numeroCuenta);

    if (response.isEmpty) {
      return [];
    }

    return response.map((inversion) => Inversion.fromMap(inversion)).toList();
  }
}
