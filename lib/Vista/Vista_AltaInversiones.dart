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
  TextEditingController plazoController = TextEditingController();

  String numeracion = "0001";
  int cantidadInversiones = 1;
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
                          campoTextoSoloLectura("NUMERACIÓN:", numeracion),
                          SizedBox(width: 10),
                          dropdownCantidadInversiones(),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: campoTexto(
                              "INGRESE EL MONTO DE LA INVERSIÓN:",
                              montoController,
                            ),
                          ),
                          SizedBox(width: 10),
                          campoTexto("PLAZO (DÍAS):", plazoController),
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
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          for (int i = 1; i <= cantidadInversiones; i++) {
                            String numeroInversion =
                                '${claveController.text}${i.toString().padLeft(3, '0')}';
                            Inversion nuevaInversion = Inversion(
                              numeroCuenta: "1",
                              numeroInversion: numeroInversion,
                              monto:
                                  double.tryParse(montoController.text) ?? 0.0,
                              gananciaEsperada:
                                  0.0, // Asignar un valor inicial o calcularlo
                              tiempoMeses:
                                  (int.tryParse(plazoController.text) ?? 30) ~/
                                  30,
                              tasaInteres:
                                  0.0, // Asignar un valor inicial o calcularlo
                              fechaInicio: fechaInicio,
                              fechaVencimiento: fechaVencimiento,
                            );
                            controlador.agregarInversion(nuevaInversion);
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Inversiones agregadas exitosamente',
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
            SizedBox(width: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Lista de Inversiones",
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
                            return Center(child: Text("Error al cargar"));
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

  Widget _buildInversionCard(Inversion inversion) {
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
                    Text("Número de Inversión: ${inversion.numeroInversion}"),
                    Text("Monto: ${inversion.monto}"),
                    Text("Fecha de Inicio: ${inversion.fechaInicio}"),
                    Text("Fecha de Vencimiento: ${inversion.fechaVencimiento}"),
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
              Text(
                "Inversión: ${inversion.numeroInversion}",
                style: TextStyle(
                  color: colorsv.colorTexto,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Monto: ${inversion.monto}",
                style: TextStyle(
                  color: colorsv.colorTexto,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
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

  Widget dropdownCantidadInversiones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CANTIDAD DE INVERSIONES:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 5),
        DropdownButton<int>(
          value: cantidadInversiones,
          items: List.generate(
            11,
            (index) =>
                DropdownMenuItem(value: index, child: Text(index.toString())),
          ),
          onChanged: (value) => setState(() => cantidadInversiones = value!),
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
        fechaVencimiento = fechaInicio.add(Duration(days: 30));
      });
    }
  }
}
