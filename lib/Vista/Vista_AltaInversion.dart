import 'package:aplicacionbancaria/Controlador/Controlador_Inversiones.dart';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Inversion.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VistaAltaInversiones extends StatefulWidget {
  VistaAltaInversiones({super.key, required this.titulo});
  final String titulo;

  @override
  _VistaAltaInversionesState createState() => _VistaAltaInversionesState();
}

class _VistaAltaInversionesState extends State<VistaAltaInversiones> {
  final ScrollController _scrollController = ScrollController();
  VentanaModelo colorsv = VentanaModelo();
  TextEditingController claveController = TextEditingController();
  TextEditingController montoController = TextEditingController();
  TextEditingController tasaInteresController = TextEditingController();

  String numeracion = '001'; // o el valor que uses dinámicamente
  double gananciaEsperada = 0.0;
  int tiempoMeses = 12;
  DateTime fechaInicio = DateTime.now();
  DateTime fechaVencimiento = DateTime.now().add(Duration(days: 365));

  List<Inversion> inversiones = [];
  final controlador = ControladorInversiones();
  late Future<void> _inversionesFuture;

  @override
  void initState() {
    super.initState();
    _inversionesFuture = _initializeInversiones();
  }

  Future<void> _initializeInversiones() async {
    inversiones = await controlador.obtenerInversiones();
  }

  void calcularGanancia() {
    double monto = double.tryParse(montoController.text) ?? 0.0;
    double tasaInteres = double.tryParse(tasaInteresController.text) ?? 0.0;
    setState(() {
      gananciaEsperada = (monto * (1 + tasaInteres) * tiempoMeses) / 12;
    });
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
        backgroundColor: colorsv.colorAppbar,
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
                              "INGRESE LA CLAVE DE LA INVERSIÓN:",
                              claveController,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: campoTextoSoloLectura(
                              "NUMERACIÓN:",
                              numeracion,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: campoTexto(
                              "INGRESE EL MONTO DE LA INVERSIÓN:",
                              montoController,
                              onChanged: calcularGanancia,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: campoTexto(
                              "INGRESAR TASA DE INTERÉS:",
                              tasaInteresController,
                              onChanged: calcularGanancia,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(children: [Expanded(child: dropdownMeses())]),
                      SizedBox(height: 10),
                      campoTextoSoloLectura(
                        "GANANCIA ESPERADA:",
                        gananciaEsperada.toStringAsFixed(2),
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: campoFecha(
                          "FECHA DE VENCIMIENTO:",
                          fechaVencimiento,
                          () => seleccionarFechaVencimiento(context),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          String numeroInversion =
                              '${claveController.text}${numeracion}';
                          double monto =
                              double.tryParse(montoController.text) ?? 0.0;
                          double tasaInteres =
                              double.tryParse(tasaInteresController.text) ?? 0.0;

                          Inversion nuevaInversion = Inversion(
                            numeroCuenta: "1", // Cambiar según sea necesario
                            numeroInversion: numeroInversion,
                            monto: monto,
                            gananciaEsperada: gananciaEsperada,
                            tiempoMeses: tiempoMeses,
                            tasaInteres: tasaInteres,
                            fechaInicio: fechaInicio,
                            fechaVencimiento: fechaVencimiento,
                          );

                          controlador.agregarInversion(nuevaInversion);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Inversión agregada exitosamente'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
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
            // Parte derecha: Lista de inversiones disponibles
            Expanded(
              child: Container(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Inversiones Disponibles",
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
                        future: _inversionesFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error al cargar inversiones"),
                            );
                          } else {
                            return ListView.builder(
                              controller: _scrollController,
                              itemCount: inversiones.length,
                              itemBuilder: (context, index) {
                                return _buildInversionCard(inversiones[index]);
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

  Widget _buildInversionCard(Inversion inv) {
    return Card(
      color: colorsv.colorCard,
      margin: EdgeInsets.all(10),
      child: InkWell(
      onTap: () {
        showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
          title: Text("Detalles de la Inversión"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("Número de Inversión: ${inv.numeroInversion}"),
            Text("Monto: ${inv.monto}"),
            Text("Meses: ${inv.tiempoMeses}"),
            Text("Tasa de Interés: ${inv.tasaInteres}%"),
            if (inv.gananciaEsperada != null)
              Text("Ganancia Estimada: ${inv.gananciaEsperada}"),
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
      child: Stack(
        children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInversionHeader(inv),
            SizedBox(height: 5),
            _buildInversionDetails(inv),
          ],
          ),
        ),
        Positioned(
          top: 5,
          right: 5, // Mover el botón al lado derecho superior
          child: IconButton(
          icon: Icon(Icons.copy, color: const Color.fromARGB(255, 0, 0, 0)),
          onPressed: () {
            setState(() {
            montoController.text = inv.monto.toString();
            tasaInteresController.text = inv.tasaInteres.toString();
            tiempoMeses = inv.tiempoMeses;
            calcularGanancia();
            });
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Información copiada a los campos'),
            ),
            );
          },
          ),
        ),
        ],
      ),
      ),
    );
  }

  Widget _buildInversionHeader(Inversion inv) {
    return Row(
      children: [
        CircleAvatar(radius: 10, backgroundColor: colorsv.colorCircle),
        SizedBox(width: 10),
        Text(
          "Inversión: ${inv.numeroInversion}",
          style: TextStyle(
            color: colorsv.colorTexto,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInversionDetails(Inversion inv) {
    return Row(
      children: [
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.monetization_on,
                    color: colorsv.colorTexto,
                    size: 16,
                  ),
                  SizedBox(width: 5),
                  Text(
                    "Monto: ${inv.monto}",
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
                    "Meses: ${inv.tiempoMeses}",
                    style: TextStyle(color: colorsv.colorTexto, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.percent, color: colorsv.colorTexto, size: 16),
                  SizedBox(width: 5),
                  Text(
                    "Tasa de Interés: ${inv.tasaInteres}%",
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

  Widget campoTexto(
    String label,
    TextEditingController controller, {
    VoidCallback? onChanged,
  }) {
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
          onChanged: (value) => onChanged?.call(),
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
        SizedBox(
          width: double.infinity, // Asegurar un ancho definido
          child: Container(
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
        ),
      ],
    );
  }

  Widget dropdownMeses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TIEMPO EN MESES:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 5),
        DropdownButton<int>(
          value: tiempoMeses,
          items: List.generate(
            12,
            (index) => DropdownMenuItem(
              value: index + 1,
              child: Text((index + 1).toString()),
            ),
          ),
          onChanged: (value) => setState(() => tiempoMeses = value!),
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
        fechaVencimiento = fechaInicio.add(Duration(days: tiempoMeses * 30));
      });
    }
  }

  Future<void> seleccionarFechaVencimiento(BuildContext context) async {
    DateTime? nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fechaVencimiento,
      firstDate: fechaInicio,
      lastDate: DateTime(2101),
    );
    if (nuevaFecha != null) {
      setState(() {
        fechaVencimiento = nuevaFecha;
      });
    }
  }
}
