import 'package:aplicacionbancaria/Controlador/Controlador_Seguros.dart';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Prestamo.dart';
import 'package:aplicacionbancaria/Modelo/Seguro.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class VistaAltaSeguro extends StatefulWidget {
  VistaAltaSeguro({super.key, required this.titulo});
  final String titulo;

  @override
  _VistaAltaSeguroState createState() => _VistaAltaSeguroState();
}

class _VistaAltaSeguroState extends State<VistaAltaSeguro> {
  final ScrollController _scrollController = ScrollController();
  VentanaModelo colorsv = VentanaModelo();
  TextEditingController claveController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  TextEditingController interesController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController nombreseguroController = TextEditingController();
  TextEditingController diasPagoController = TextEditingController(text: '15');

  String numeracion = "0001";
  int cantidadPrestamos = 1;
  int meses = 1;
  double pagoMinimo = 0.0;
  DateTime fechaInicio = DateTime.now();
  DateTime fechaPago = DateTime.now().add(Duration(days: 30));

  List<Seguro> seguros = [];
  final controlador = ControladorSeguros();
  late Future<void> _segurosFuture;

  @override
  void initState() {
    super.initState();
    _segurosFuture = _initializeSeguros();
  }

  Future<void> _initializeSeguros() async {
    seguros = await controlador.obtenerSeguros();
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
                              "INGRESE EL NÚMERO DE PÓLIZA:",
                              claveController,
                            ),
                          ),
                          SizedBox(width: 10),
                          campoTextoSoloLectura("NUMERACIÓN:", numeracion),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: campoTexto(
                              "TIPO DE SEGURO",
                              nombreseguroController,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: campoTexto(
                              "DESCRIPCIÓN DEL SEGURO:",
                              descripcionController,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: campoTexto(
                              "INGRESE EL MONTO ASEGURADO:",
                              montoController,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: campoTexto(
                              "INGRESE TASA DE INTERÉS:",
                              interesController,
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
                      campoTexto("DÍAS DE COBERTURA:", diasPagoController),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          String numeroPoliza = claveController.text;
                          double montoAsegurado =
                              double.tryParse(montoController.text) ?? 0.0;
                          double primaMensual =
                              double.tryParse(interesController.text) ?? 0.0;
                          int diasCobertura =
                              int.tryParse(diasPagoController.text) ?? 15;

                          Seguro nuevoSeguro = Seguro(
                            numeroCuenta: "1", // Número de cuenta ficticio
                            numeroPoliza: numeroPoliza,
                            costo: primaMensual,
                            meses: meses,
                            tasaInteres: primaMensual / montoAsegurado,
                            pagosRealizados: 0,
                            tipoSeguro: "General",
                            montoCobertura: primaMensual,
                            fechaInicio: fechaInicio,
                            fechaVencimiento: fechaInicio.add(
                              Duration(days: diasCobertura),
                            ),
                            fechaPago: fechaPago,
                          );

                          final resultado = await controlador.agregarSeguro(
                            nuevoSeguro,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Seguro agregado exitosamente'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                        ),
                        child: Text(
                          "AGREGAR SEGURO",
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
                        "Cartilla de Seguros",
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
                        future: _segurosFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text("Error al cargar"));
                          } else {
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: seguros.length,
                              itemBuilder: (context, index) {
                                return _buildSeguroCard(
                                  seguros[index],
                                ); // Ajustado
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
  Widget _buildSeguroCard(Seguro seguros) {
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
                    Text("Número de Préstamo: ${seguros.numeroPoliza}"),
                    Text("Tipo de Seguro: ${seguros.tipoSeguro}"),
                    Text("Descripción: ${seguros.descripcionCobertura}"),
                    Text("Monto: ${seguros.costoTotal}"),
                    Text("Meses: ${seguros.meses}"),
                    Text("Tasa de Interés: ${seguros.tasaInteres} %"),
                    Text("Fecha de Inicio: ${seguros.fechaInicio}"),
                    Text("Fecha de Pago: ${seguros.fechaPago}"),
                    Text("Pago Mínimo: ${seguros.costo / seguros.meses}"),
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
              _buildPrestamoHeader(seguros),
              SizedBox(height: 5),
              _buildPrestamoDetails(seguros),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrestamoHeader(Seguro seguros) {
    return Row(
      children: [
        CircleAvatar(radius: 10, backgroundColor: colorsv.colorCircle),
        SizedBox(width: 10),
        Text(
          "Seguro: ${seguros.numeroPoliza}",
          style: TextStyle(
            color: colorsv.colorTexto,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPrestamoDetails(Seguro seguros) {
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
                    "Monto: ${seguros.costo}",
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
                    "Meses: ${seguros.meses}",
                    style: TextStyle(color: colorsv.colorTexto, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.check_circle, color: colorsv.colorTexto, size: 16),
                  SizedBox(width: 5),
                  Text(
                    "Tasa de Interés: ${seguros.tasaInteres} %",
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
