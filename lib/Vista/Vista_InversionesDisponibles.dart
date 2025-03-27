import 'package:aplicacionbancaria/Controlador/Controlador_Inversiones.dart';
import 'package:aplicacionbancaria/Vista/Vista_SolicitudInversion.dart';
import 'package:flutter/material.dart';
import '../Modelo/Inversion.dart';
import '../Modelo/Usuario.dart';

final Color colorAppbar = Color(0xFF472F2F);
final Color colorBuscador = Color(0xFFD9D9D9);
final Color colorBackground = Color(0xFFB1ACAC);
final Color colorMenu = Color(0xFF5C3B3B);
final Color colorFondo = Color(0xFF676464);
final Color colorCard = Color(0xFFEDECEC);
final Color colorBoton = Color(0xFFA08181);
final Color colorTexto = Color(0xFF140A0A);
final Color colorTexto2 = Color(0xFFEEEEEE);
final Color colorIcon = Color(0xFF1F1010);
final Color colorCircle = Color(0xFF138A43);

class VistaInversionesDisponibles extends StatefulWidget {
  const VistaInversionesDisponibles({super.key, required this.usuario});
  final Usuario usuario;

  @override
  _VistaInversionesDisponiblesState createState() => _VistaInversionesDisponiblesState();
}

class _VistaInversionesDisponiblesState extends State<VistaInversionesDisponibles> {
  final ScrollController _scrollController = ScrollController();
  final controlador = ControladorInversiones();
  List<Inversion> inversiones = [];

  late Future<void> _inversionesFuture;

  @override
  void initState() {
    super.initState();
    _inversionesFuture = _initializeInversiones();
  }

  Future<void> _initializeInversiones() async {
    try {
      inversiones = await controlador.obtenerInversiones();
      print("Inversiones obtenidas: ${inversiones.length}");
      for (var inversion in inversiones) {
        print("Inversión: ${inversion.numeroInversion}, Monto: ${inversion.monto}, Plazo: ${inversion.tiempoMeses} meses, Tasa de Interés: ${inversion.tasaInteres}%   ${inversion.fechaInicio}      ${inversion.fechaVencimiento}           ${inversion.estado}" );
      }
    } catch (e) {
      inversiones = []; // Fallback to an empty list in case of error
      print("Error al cargar inversiones: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Oferta de Inversiones",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Usuario: ${widget.usuario.nombre} ${widget.usuario.apellido}",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white), // Cambia el color de la flecha back a blanco
      ),
      body: Stack(
        children: [
          // Imagen de fondo translúcida
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'lib/Recursos/logo.png', // Ruta de la imagen del logo
                fit: BoxFit.cover,
              ),
            ),
          ),
          FutureBuilder(
            future: _inversionesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error al cargar datos"));
              } else {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: colorFondo,
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 6,
                            radius: Radius.circular(20),
                            trackVisibility: true,
                            controller: _scrollController,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: inversiones.length,
                              itemBuilder: (context, index) {
                                final inversion = inversiones[index];
                                return _buildInversionCard(inversion);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Aquí se pueden agregar más widgets
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInversionCard(Inversion inversion) {
    return Card(
      color: colorCard,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VistaSolicitudInversion(inversion: inversion),
          ),
        );
        },  
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: colorCircle, // Puedes cambiar el color del círculo
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Inversión: ${inversion.numeroInversion}",
                    style: TextStyle(
                      color: colorTexto,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Monto: ${inversion.monto}",
                          style: TextStyle(
                            color: colorTexto,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Plazo: ${inversion.tiempoMeses} meses",
                          style: TextStyle(color: colorTexto, fontSize: 14),
                        ),
                        Text(
                          "Tasa de Interés: ${inversion.tasaInteres}%",
                          style: TextStyle(color: colorTexto),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}