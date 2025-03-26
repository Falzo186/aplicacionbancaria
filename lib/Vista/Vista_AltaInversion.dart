import 'package:flutter/material.dart';
import '../Modelo/Inversion.dart';
import 'dart:math';


class VistaAltaInversion extends StatefulWidget {
  final String numeroCuenta;

  const VistaAltaInversion({super.key, required this.numeroCuenta});

  @override
  _VistaAltaInversionState createState() => _VistaAltaInversionState();
}

class _VistaAltaInversionState extends State<VistaAltaInversion> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _primerosDigitosController = TextEditingController();
  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _tiempoController = TextEditingController();
  final TextEditingController _tasaInteresController = TextEditingController();
  
  String numeroInversion = '';
  double gananciaEsperada = 0.0;
  DateTime fechaInicio = DateTime.now();
  DateTime fechaVencimiento = DateTime.now();
  String estado = 'En Espera';
  int inversionesRegistradas = 0;

  void _generarNumeroInversion() {
    String primerosDigitos = _primerosDigitosController.text.toUpperCase();
    final random = Random();
    while (primerosDigitos.length < 4) {
      primerosDigitos += String.fromCharCode(random.nextInt(26) + 65);
    }
    inversionesRegistradas++;
    final ultimosDigitos = inversionesRegistradas.toString().padLeft(4, '0');
    setState(() {
      numeroInversion = '$primerosDigitos$ultimosDigitos';
    });
  }

  void _calcularGananciaEsperada() {
    if (_formKey.currentState!.validate()) {
      final monto = double.parse(_montoController.text);
      final tiempo = int.parse(_tiempoController.text);
      final tasaInteres = double.parse(_tasaInteresController.text) / 100;
      setState(() {
        gananciaEsperada = monto * tasaInteres * tiempo / 12;
        fechaVencimiento = DateTime(
          fechaInicio.year,
          fechaInicio.month + tiempo + 2,
          fechaInicio.day,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 175, 161, 156),
        title: const Text('Alta de Inversión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _primerosDigitosController,
                maxLength: 4,
                decoration: const InputDecoration(
                  labelText: 'Primeros 4 dígitos',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _generarNumeroInversion,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text('Generar Número de Inversión'),
              ),
              const SizedBox(height: 10),
              Text('Número de Inversión: $numeroInversion',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _montoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tiempoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tiempo (meses)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tasaInteresController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Tasa de Interés (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calcularGananciaEsperada,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                child: const Text('Calcular Ganancia Esperada'),
              ),
              if (gananciaEsperada > 0) ...[
                const SizedBox(height: 10),
                Text('Ganancia Esperada: \$${gananciaEsperada.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Fecha de Vencimiento: ${fechaVencimiento.day}/${fechaVencimiento.month}/${fechaVencimiento.year}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 165, 146, 139),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Guardar Inversión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
