import 'package:flutter/material.dart';

import '../Modelo/Cliente.dart';

class ControladorVentanilla {
  // Constructor
  ControladorVentanilla();



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