import '../Modelo/Cliente.dart';
import '../Modelo/CuentaCliente.dart';
import '../Modelo/CuentaCredito.dart';
import '../Modelo/Prestamo.dart';
import '../Modelo/Seguro.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class ControladorDatoscliente {
  

  final SupabaseClient supabase = Supabase.instance.client;

Future<Cliente?> buscarCliente(String numeroCuenta) async {
  final response = await supabase
    .from('clientes')
    .select()
    .eq('numerocuenta', numeroCuenta)
    .single();

  if (response == null) {
    return null;
  }

  return Cliente.fromMap(response);
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



  

 CuentaCliente buscarCuentaCliente(String numeroCuenta) {
    return CuentaCliente(
      numeroCuenta: numeroCuenta,
      saldo: 5000.0,
      tipoCuenta: "Ahorro",
      fechaApertura: DateTime(2020, 5, 10),
      estadoCuenta: "Activa",
    );
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
    final response = await supabase
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
    final response = await supabase
        .from('seguros')
        .select()
        .eq('numerocuenta', numeroCuenta)
        .single();

    if (response == null) {
      return null;
    }

    return Seguro.fromMap(response);
  }

  Future<List<Prestamo>> obtenerPrestamos() async {
    final response = await supabase.from('prestamos').select();
    
    if (response.isEmpty) {
      return [];
    }

    return response.map((prestamo) => Prestamo.fromMap(prestamo)).toList();
  }

  Future<List<Seguro>> obtenerSeguros() async {
    final response = await supabase.from('seguros').select();
    
    if (response.isEmpty) {
      return [];
    }

    return response.map((seguro) => Seguro.fromMap(seguro)).toList();
  }

  Future<void> actualizarSeguro(Seguro seguro) async {
    final response = await supabase
        .from('seguros')
        .update(seguro.toMap())
        .eq('numeroCuenta', seguro.numeroCuenta);

    if (response.error != null) {
      throw Exception('Error al actualizar el seguro: ${response.error!.message}');
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


  obtenerTransferencias() {
    
  }


}