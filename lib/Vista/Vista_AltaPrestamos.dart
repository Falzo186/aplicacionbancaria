import 'package:aplicacionbancaria/Controlador/Controlador_Prestamos.dart';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Prestamo.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class VistaAltaprestamos extends StatefulWidget {
  VistaAltaprestamos({super.key, required this.titulo});
  final String titulo;

  @override
  _VistaAltaprestamosState createState() => _VistaAltaprestamosState();
}

class _VistaAltaprestamosState extends State<VistaAltaprestamos> {
  final ScrollController _scrollController = ScrollController();
  VentanaModelo colorsv = VentanaModelo();
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

  List<Prestamo> prestamos = [];
  final controlador = ControladorPrestamos();
  late Future<void> _prestamosFuture;

  @override
  void initState() {
    super.initState();
    _prestamosFuture = _initializePrestamos();
  }

  Future<void> _initializePrestamos() async {
    prestamos = await controlador.obtenerPrestamos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(
          widget.titulo,
          style: TextStyle(
            color: colorsv.colorTexto2,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: colorsv.colorAppbar, // Color marrón oscuro
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorsv.colorTexto2),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        color: colorsv.colorBackground,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/Recursos/logo.png'),
                    fit: BoxFit.scaleDown,
                    opacity: 0.2,
                  ),
                  color: colorsv.colorTexto2,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: campoTexto(
                              "INGRESE LA CLAVE DEL PRÉSTAMO:",
                              claveController,
                            ),
                          ),
                          SizedBox(width: 10),
                          campoTextoSoloLectura("NUMERACIÓN:", numeracion),
                          SizedBox(width: 10),
                          dropdownCantidadPrestamos(),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: campoTexto(
                              "INGRESE EL MONTO DEL PRÉSTAMO:",
                              montoController,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: campoTexto(
                              "INGRESAR TASA DE INTERÉS:",
                              interesController,
                            ),
                          ),
                          SizedBox(width: 10),
                          dropdownMeses(),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          campoTextoSoloLectura(
                            "PAGO MÍNIMO:",
                            pagoMinimo.toStringAsFixed(2),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: calcularPagoMinimo,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(
                                0xFF5C3B3B,
                              ), // Marrón intermedio
                            ),
                            child: Text(
                              "CALCULAR",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: campoFecha(
                          "FECHA DE INICIO:",
                          fechaInicio,
                          () => seleccionarFechaInicio(context),
                        ),
                      ),
                      SizedBox(height: 10),
                      campoTexto("DÍAS DE PAGO:", diasPagoController),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          for (int i = 1; i <= cantidadPrestamos; i++) {
                            String numeroPrestamo =
                                '${claveController.text}${i.toString().padLeft(3, '0')}';
                            Prestamo nuevoPrestamo = Prestamo(
                              numeroCuenta: "1",
                              numeroPrestamo: numeroPrestamo,
                              monto:
                                  double.tryParse(montoController.text) ?? 0.0,
                              meses: meses,
                              tasaInteres:
                                  double.tryParse(interesController.text) ??
                                  0.0,
                              fechaInicio: fechaInicio,
                              fechapago: fechaPago,
                              diasPago:
                                  int.tryParse(diasPagoController.text) ?? 15,
                              pagosRealizados: 0,
                            );
                            controlador.agregarPrestamo(nuevoPrestamo);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Préstamos agregados exitosamente'),
                            ),
                          );
                        },
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
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Carta de Préstamos",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: colorsv.colorTextoLogin,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: FutureBuilder<void>(
                        future: _prestamosFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error al cargar"));
                          } else {
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: prestamos.length,
                              itemBuilder: (context, index) {
                                return _buildPrestamoCard(prestamos[index]);
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: colorsv.colorShadowSplogin,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSideLogo() {
    return Expanded(
      flex: 2,
      child: Center(
        child: Image.asset(
          'lib/Recursos/logo.png',
          width: 300,
          opacity: AlwaysStoppedAnimation(0.8),
        ).animate().scale(duration: 500.ms),
      ),
    );
  }

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

  // Optimización de la creación de tarjetas de préstamo
  Widget _buildPrestamoCard(Prestamo prestamo) {
    return Card(
      color: colorsv.colorCard,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("Detalles del Préstamo"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Número de Préstamo: ${prestamo.numeroPrestamo}"),
                    Text("Monto: ${prestamo.monto}"),
                    Text("Meses: ${prestamo.meses}"),
                    Text("Tasa de Interés: ${prestamo.tasaInteres} %"),
                    Text("Fecha de Inicio: ${prestamo.fechaInicio}"),
                    Text("Fecha de Pago: ${prestamo.fechapago}"),
                    Text("Días de Pago: ${prestamo.diasPago}"),
                    Text("Pago Mínimo: ${prestamo.pagoMinimo}"),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cerrar"),
                  ),
                ],
              );
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPrestamoHeader(prestamo),
              SizedBox(height: 5),
              _buildPrestamoDetails(prestamo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrestamoHeader(Prestamo prestamo) {
    return Row(
      children: [
        CircleAvatar(radius: 10, backgroundColor: colorsv.colorCircle),
        SizedBox(width: 10),
        Text(
          "Préstamo: ${prestamo.numeroPrestamo}",
          style: TextStyle(
            color: colorsv.colorTexto,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPrestamoDetails(Prestamo prestamo) {
    return Row(
      children: [
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.attach_money, color: colorsv.colorTexto, size: 16),
                  SizedBox(width: 5),
                  Text(
                    "Monto: ${prestamo.monto}",
                    style: TextStyle(
                      color: colorsv.colorTexto,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: colorsv.colorTexto,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Meses: ${prestamo.meses}",
                    style: TextStyle(color: colorsv.colorTexto, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: colorsv.colorTexto,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Tasa de Interés: ${prestamo.tasaInteres} %",
                    style: TextStyle(color: colorsv.colorTexto),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
            (index) =>
                DropdownMenuItem(value: index, child: Text(index.toString())),
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
            (index) => DropdownMenuItem(
              value: index + 1,
              child: Text((index + 1).toString()),
            ),
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
