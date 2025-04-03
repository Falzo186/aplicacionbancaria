import 'package:aplicacionbancaria/Controlador/Controlador_Inversiones.dart';
import 'package:aplicacionbancaria/Vista/Vista_AltaInversion.dart';
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

class VistaInversiones extends StatefulWidget {
  const VistaInversiones({super.key, required this.usuario});
  final Usuario usuario;

  @override
  _VistaInversionesState createState() => _VistaInversionesState();
}

class _VistaInversionesState extends State<VistaInversiones> {
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
    } catch (e) {
      inversiones = []; // Fallback to an empty list in case of error
      debugPrint("Error al cargar inversiones: $e");
    }
  }

  void _pausarInversion(Inversion inversion) {
    setState(() {
      inversion.estado = "Pausada";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Inversión ${inversion.numeroInversion} pausada")),
    );
  }

  void _borrarInversion(Inversion inversion) {
    setState(() {
      inversiones.remove(inversion);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Inversión ${inversion.numeroInversion} borrada")),
    );
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
              "Gestión de Inversiones",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Usuario: ${widget.usuario.nombre} ${widget.usuario.apellido}",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Imagen de fondo translúcida
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'lib/Recursos/logo.png',
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
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorCircle,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VistaAltaInversiones(titulo: "Alta de Inversiones"),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildInversionCard(Inversion inversion) {
    return Card(
      color: colorCard,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          // Acción al tocar la tarjeta (si es necesario)
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
                    backgroundColor: colorCircle,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Inversión: ${inversion.numeroInversion}",
                      style: TextStyle(
                        color: colorTexto,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "Pausar") {
                        _pausarInversion(inversion);
                      } else if (value == "Borrar") {
                        _borrarInversion(inversion);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "Pausar",
                        child: Text("Pausar"),
                      ),
                      PopupMenuItem(
                        value: "Borrar",
                        child: Text("Borrar"),
                      ),
                    ],
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