import 'dart:io';

import 'package:flutter/material.dart';

class MainController {
  void mostrarOpcionesPago(BuildContext context, String nombre) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Opciones de pago para $nombre"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Depósito a cuenta"),
              onTap: () {
                Navigator.pop(context);
                ingresarMonto(context, nombre, "Depósito a cuenta", true);
              },
            ),
            ListTile(
              title: Text("Pago de préstamo"),
              onTap: () {
                Navigator.pop(context);
                ingresarMonto(context, nombre, "Pago de préstamo", false);
              },
            ),
            ListTile(
              title: Text("Pago de inversión"),
              onTap: () {
                Navigator.pop(context);
                ingresarMonto(context, nombre, "Pago de inversión", false);
              },
            ),
            ListTile(
              title: Text("Pago de seguro"),
              onTap: () {
                Navigator.pop(context);
                ingresarMonto(context, nombre, "Pago de seguro", false);
              },
            ),
          ],
        ),
      ),
    );
  }

  void ingresarMonto(BuildContext context, String nombre, String tipo, bool editable) {
    TextEditingController montoController = TextEditingController();

    if (!editable) {
      // Si no es editable, asignamos un monto predefinido (ejemplo)
      montoController.text = tipo == "Pago de préstamo"
          ? "3200"
          : tipo == "Pago de inversión"
              ? "10000"
              : "800"; // Pago de seguro
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ingrese el monto"),
        content: TextField(
          controller: montoController,
          keyboardType: TextInputType.number,
          enabled: editable, // Solo editable si es depósito
          decoration: InputDecoration(labelText: "Monto en \$"),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Confirmar"),
            onPressed: () {
              // Aquí puedes enviar el monto ingresado a la base de datos o procesarlo
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Cerrar Sesión"),
        content: Text("¿Estás seguro de que deseas cerrar sesión?"),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text("Salir", style: TextStyle(color: Colors.red)),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      ),
    );
  }
}
