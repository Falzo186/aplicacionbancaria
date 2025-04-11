import 'package:aplicacionbancaria/Controlador/Controlador_Seguros.dart';
import 'package:aplicacionbancaria/Modelo/Appbar_perso.dart';
import 'package:aplicacionbancaria/Modelo/Usuario.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:aplicacionbancaria/Vista/VistaAltaSeguro.dart';
import 'package:aplicacionbancaria/Vista/Vista_SolicitudSeguro.dart';
import 'package:flutter/material.dart';
import '../Modelo/Seguro.dart';

VentanaModelo colorsv = VentanaModelo();

class VistaSeguros extends StatefulWidget {
  const VistaSeguros({super.key, required this.usuario});

  final Usuario usuario;

  _VistaSegurosState createState() => _VistaSegurosState();
}

class _VistaSegurosState extends State<VistaSeguros> {
  List<Seguro> seguros = []; // Lista de seguros
  final Controlador = ControladorSeguros(); // Instancia del controlador
  final ScrollController _scrollController = ScrollController();

  late Future<void> _segurosFuture; // Variable para el FutureBuilder

  @override
  void initState() {
    super.initState();
    _loadSeguros();
    _segurosFuture = _initializeSeguros();
  }

  Future<void> _initializeSeguros() async {
    seguros = await Controlador.obtenerSeguros();
  }

  void _loadSeguros() async {
    final segurosCargados = await Controlador.obtenerSeguros();
    setState(() {
      seguros = segurosCargados;
    });
  }

  void _pausarSeguro(Seguro seguro) {
    setState(() {
      seguro.estado = "Pausado";
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("El seguro ${seguro.numeroPoliza} ha sido pausado."),
      ),
    );
  }

  void _borrarSeguro(Seguro seguro) {
    setState(() {
      seguros.remove(seguro);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("El seguro ${seguro.numeroPoliza} ha sido borrado."),
      ),
    );
  }

  void _agregarSeguro() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VistaAltaSeguro(titulo: "Agregar Seguro"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsv.colorBackground,
      appBar: CustomAppBar(
        backgroundColor: colorsv.colorAppbar,
        title: Text("Lista de Seguros", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorsv.colorTexto2),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _segurosFuture,
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
                            color: colorsv.colorFondo,
                          ),
                          child: Scrollbar(
                            thumbVisibility: true,
                            thickness: 6,
                            radius: Radius.circular(20),
                            trackVisibility: true,
                            controller: _scrollController,
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: seguros.length,
                              itemBuilder: (context, index) {
                                final seguro = seguros[index];
                                return _buildSeguroCard(seguro);
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
        onPressed: _agregarSeguro,
        backgroundColor: colorsv.confirmado,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSeguroCard(Seguro seguro) {
    return Card(
      color: colorsv.colorCard,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => VistaSolicitudSeguro(
                    seguro: seguro,
                    usuario: widget.usuario,
                  ),
            ),
          );
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: colorsv.colorCircle,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Seguro: ${seguro.numeroPoliza}",
                        style: TextStyle(
                          color: colorsv.colorTexto,
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
                              "Monto Asegurado: ${seguro.costoTotal}",
                              style: TextStyle(
                                color: colorsv.colorTexto,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Estado: ${seguro.estado}",
                              style: TextStyle(
                                color: colorsv.colorTexto,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Pausar') {
                    _pausarSeguro(seguro);
                  } else if (value == 'Borrar') {
                    _borrarSeguro(seguro);
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(value: 'Pausar', child: Text('Pausar')),
                      PopupMenuItem(value: 'Borrar', child: Text('Borrar')),
                    ],
                icon: Icon(Icons.more_vert, color: colorsv.colorIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
