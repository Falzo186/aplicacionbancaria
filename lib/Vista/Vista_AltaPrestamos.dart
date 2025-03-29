import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VistaAltaprestamos extends StatefulWidget {
  @override
  _VistaAltaprestamosState createState() => _VistaAltaprestamosState();
}

class _VistaAltaprestamosState extends State<VistaAltaprestamos> {
  TextEditingController claveController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  TextEditingController interesController = TextEditingController();
  TextEditingController diasPagoController = TextEditingController(text: '15');
  String numeracion = "0001";
  int cantidadPrestamos = 1;
  int meses = 1;
  double pagoMinimo = 0.0;
  DateTime fechaInicio = DateTime.now();
  DateTime fechaPago = DateTime.now().add(Duration(days: 30));

  void calcularPagoMinimo() {
    double monto = double.tryParse(montoController.text) ?? 0.0;
    double interes = (double.tryParse(interesController.text) ?? 0.0) / 100;
    if (meses > 0) {
      setState(() {
        pagoMinimo = (monto * (1 + interes)) / meses;
      });
    }
  }

  Future<void> seleccionarFechaInicio(BuildContext context) async {
    DateTime? nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fechaInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (nuevaFecha != null) {
      setState(() {
        fechaInicio = nuevaFecha;
        fechaPago = fechaInicio.add(Duration(days: 30));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB1ACAC), // Fondo gris claro
      appBar: AppBar(
        title: Text("Registro de Préstamos"),
        backgroundColor: Color(0xFF472F2F), // Color marrón oscuro
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: campoTexto("INGRESE LA CLAVE DEL PRÉSTAMO:", claveController)),
                SizedBox(width: 10),
                campoTextoSoloLectura("NUMERACIÓN:", numeracion),
                SizedBox(width: 10),
                dropdownCantidadPrestamos(),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: campoTexto("INGRESE EL MONTO DEL PRÉSTAMO:", montoController)),
                SizedBox(width: 10),
                Expanded(child: campoTexto("INGRESAR TASA DE INTERÉS:", interesController)),
                SizedBox(width: 10),
                dropdownMeses(),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                campoTextoSoloLectura("PAGO MÍNIMO:", pagoMinimo.toStringAsFixed(2)),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: calcularPagoMinimo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5C3B3B), // Marrón intermedio
                  ),
                  child: Text(
                    "CALCULAR",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                campoFecha("FECHA DE INICIO:", fechaInicio, () => seleccionarFechaInicio(context)),
                SizedBox(width: 10),
                campoFecha("FECHA DE PAGO:", fechaPago, () {}),
              ],
            ),
            SizedBox(height: 10),
            campoTexto("DÍAS DE PAGO:", diasPagoController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300], // Botón gris claro
              ),
              child: Text(
                "AGREGAR",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget campoTexto(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget campoTextoSoloLectura(String label, String valor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 5),
        Container(
          width: 80,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
          ),
          child: Text(
            valor,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget dropdownCantidadPrestamos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CANTIDAD DE PRÉSTAMOS:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 5),
        DropdownButton<int>(
          value: cantidadPrestamos,
          items: List.generate(
            11,
            (index) => DropdownMenuItem(value: index, child: Text(index.toString())),
          ),
          onChanged: (value) => setState(() => cantidadPrestamos = value!),
        ),
      ],
    );
  }

  Widget dropdownMeses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "INGRESAR MESES:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 5),
        DropdownButton<int>(
          value: meses,
          items: List.generate(
            12,
            (index) => DropdownMenuItem(value: index + 1, child: Text((index + 1).toString())),
          ),
          onChanged: (value) => setState(() => meses = value!),
        ),
      ],
    );
  }

  Widget campoFecha(String label, DateTime fecha, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 5),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Text(
              DateFormat('yyyy/MM/dd').format(fecha),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
