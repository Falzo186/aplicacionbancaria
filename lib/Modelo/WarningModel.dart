import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ErrorDialog {
  final BuildContext context;
  final String mensaje;

  ErrorDialog({required this.context, required this.mensaje});
  VentanaModelo colorsv = VentanaModelo();
  void mostrar() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: colorsv.denegado,
          title: Row(
            children: [
              Icon(Icons.warning, color: colorsv.colorTexto2),
              SizedBox(width: 8),
              Text('Error', style: TextStyle(color: colorsv.colorTexto2)),
            ],
          ),
          content: Text(mensaje, style: TextStyle(color: colorsv.colorTexto2)),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: colorsv.colorTexto2)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
