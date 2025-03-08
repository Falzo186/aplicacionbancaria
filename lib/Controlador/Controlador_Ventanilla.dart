import 'package:flutter/material.dart';

import '../Modelo/Cliente.dart';

class ControladorVentanilla {
  // Constructor
  ControladorVentanilla();
List<Cliente> clientes = [
    Cliente(
      numeroCuenta: '12345678901',
      nombreCompleto: 'Ana García',
      genero: 'Femenino',
      fechaNacimiento: DateTime(1990, 5, 15),
      identificacionOficial: 'INE123456789',
      rfc: 'GAGM900515XXX',
      estadoCivil: 'Soltera',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle A #123, Ciudad de México',
      telefono: '5512345678',
      correoElectronico: 'ana.garcia@email.com',
      ocupacion: 'Ingeniera de Software',
      empresa: 'Tech Solutions',
      direccionEmpresa: 'Av. B #456, Ciudad de México',
      telefonoEmpresa: '5587654321',
      ingresosMensuales: 35000.00,
      fuenteIngresos: 'Salario',
    ),
    Cliente(
      numeroCuenta: '98765432109',
      nombreCompleto: 'Juan Pérez',
      genero: 'Masculino',
      fechaNacimiento: DateTime(1985, 8, 22),
      identificacionOficial: 'INE987654321',
      rfc: 'PEPJ850822XXX',
      estadoCivil: 'Casado',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle C #789, Guadalajara',
      telefono: '3398765432',
      correoElectronico: 'juan.perez@email.com',
      ocupacion: 'Contador',
      empresa: 'Accounting Firm',
      direccionEmpresa: 'Av. D #101, Guadalajara',
      telefonoEmpresa: '3321436587',
      ingresosMensuales: 30000.00,
      fuenteIngresos: 'Salario',
    ),
    Cliente(
      numeroCuenta: '11223344556',
      nombreCompleto: 'María López',
      genero: 'Femenino',
      fechaNacimiento: DateTime(1992, 3, 10),
      identificacionOficial: 'INE112233445',
      rfc: 'LOMM920310XXX',
      estadoCivil: 'Soltera',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle E #111, Monterrey',
      telefono: '8155667788',
      correoElectronico: 'maria.lopez@email.com',
      ocupacion: 'Médico',
      empresa: 'Hospital ABC',
      direccionEmpresa: 'Av. F #222, Monterrey',
      telefonoEmpresa: '8199887766',
      ingresosMensuales: 45000.00,
      fuenteIngresos: 'Salario',
    ),
    Cliente(
      numeroCuenta: '66554433221',
      nombreCompleto: 'Carlos Ramírez',
      genero: 'Masculino',
      fechaNacimiento: DateTime(1988, 11, 30),
      identificacionOficial: 'INE665544332',
      rfc: 'RACJ881130XXX',
      estadoCivil: 'Casado',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle G #333, Puebla',
      telefono: '2221122334',
      correoElectronico: 'carlos.ramirez@email.com',
      ocupacion: 'Abogado',
      empresa: 'Law Firm XYZ',
      direccionEmpresa: 'Av. H #444, Puebla',
      telefonoEmpresa: '2224433221',
      ingresosMensuales: 40000.00,
      fuenteIngresos: 'Honorarios',
    ),
    Cliente(
      numeroCuenta: '10293847563',
      nombreCompleto: 'Laura Torres',
      genero: 'Femenino',
      fechaNacimiento: DateTime(1995, 7, 5),
      identificacionOficial: 'INE102938475',
      rfc: 'TOLR950705XXX',
      estadoCivil: 'Soltera',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle I #555, Querétaro',
      telefono: '4425566778',
      correoElectronico: 'laura.torres@email.com',
      ocupacion: 'Diseñadora Gráfica',
      empresa: 'Creative Studio',
      direccionEmpresa: 'Av. J #666, Querétaro',
      telefonoEmpresa: '4428877665',
      ingresosMensuales: 28000.00,
      fuenteIngresos: 'Freelance',
    ),
    Cliente(
      numeroCuenta: '36521487901',
      nombreCompleto: 'Pedro Sánchez',
      genero: 'Masculino',
      fechaNacimiento: DateTime(1983, 12, 12),
      identificacionOficial: 'INE365214879',
      rfc: 'SAPJ831212XXX',
      estadoCivil: 'Casado',
      nacionalidad: 'Mexicana',
      direccionCompleta: 'Calle K #777, León',
      telefono: '4771122334',
      correoElectronico: 'pedro.sanchez@email.com',
      ocupacion: 'Arquitecto',
      empresa: 'Construction Group',
      direccionEmpresa: 'Av. L #888, León',
      telefonoEmpresa: '4774433221',
      ingresosMensuales: 50000.00,
      fuenteIngresos: 'Salario',
    )
  ];
  // Métodos
  List<Cliente> obtenerClientes() {
    return clientes;
  }
  


  void mostrarOpcionesDialog(Cliente cliente, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Opciones de cuenta"),
          content: Text("Seleccione una acción para la cuenta ${cliente.numeroCuenta}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                mostrarDepositoDialog(cliente, context);
              },
              child: Text("Depósito"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                mostrarPagoCreditoDialog(cliente, context);
              },
              child: Text("Pago a Crédito"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void mostrarDepositoDialog(Cliente cliente, BuildContext context) {
    TextEditingController montoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Depósito"),
          content: TextField(
            controller: montoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Ingrese el monto a depositar"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Aquí puedes manejar el depósito con montoController.text
                Navigator.pop(context);
              },
              child: Text("Aceptar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  void mostrarPagoCreditoDialog(Cliente cliente, BuildContext context) {
    TextEditingController montoController = TextEditingController();
    TextEditingController fechaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pago a Crédito"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: montoController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Ingrese el monto a pagar"),
              ),
              TextField(
                controller: fechaController,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(labelText: "Ingrese la fecha de pago"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Aquí puedes manejar el pago con montoController.text y fechaController.text
                Navigator.pop(context);
              },
              child: Text("Aceptar"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

  


}