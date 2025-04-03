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

  String numeracion = "0001";
  int tiempoMeses = 1;
  double gananciaEsperada = 0.0;
  DateTime fechaInicio = DateTime.now();
  DateTime fechaVencimiento = DateTime.now().add(Duration(days: 30));

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
      gananciaEsperada = (monto * (1+ tasaInteres) * tiempoMeses) / 12;
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(20.0),
          color: colorsv.colorBackground,
          child: Row(
            children: [
              // Parte izquierda: Formulario para agregar inversiones
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/Recursos/logo.png'),
                      fit: BoxFit.scaleDown,
                      opacity: 0.9,
                    ),
                    color: colorsv.colorTexto2,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: SingleChildScrollView(
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
                                  double.tryParse(tasaInteresController.text) ??
                                  0.0;

                              Inversion nuevaInversion = Inversion(
                                numeroCuenta:
                                    "1", // Cambiar según sea necesario
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
                                  content: Text(
                                    'Inversión agregada exitosamente',
                                  ),
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
              ),
              SizedBox(width: 20),
              // Parte derecha: Lista de inversiones disponibles
              Expanded(
                flex: 3,
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
                                  return _buildInversionCard(
                                    inversiones[index],
                                  );
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
      ),
    );
  }

  Widget _buildInversionCard(Inversion inversion) {
    return Card(
      color: colorsv.colorCard,
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text("Inversión: ${inversion.numeroInversion}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Monto: ${inversion.monto}"),
            Text("Plazo: ${inversion.tiempoMeses} meses"),
            Text("Tasa de Interés: ${inversion.tasaInteres}%"),
          ],
        ),
      ),
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
