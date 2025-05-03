import 'package:aplicacionbancaria/Controlador/Controlador_Prestamos.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:aplicacionbancaria/Vista/Vista_AltaPrestamos.dart';
import 'package:flutter/material.dart';
import '../Modelo/Empleado.dart';
import '../Modelo/Prestamo.dart';
import '../Modelo/Usuario.dart';
import 'Vista_SolicitudPrestamo.dart';

VentanaModelo colorsv = VentanaModelo();

class VistaPrestamos extends StatefulWidget {
  const VistaPrestamos({super.key, required this.usuario, required this.empleado});
  final Empleado empleado;
  final Usuario usuario;

  @override
  _VistaPrestamosState createState() => _VistaPrestamosState();
}

class _VistaPrestamosState extends State<VistaPrestamos> {
  final ScrollController _scrollController = ScrollController();
  final controlador = ControladorPrestamos();
  List<Prestamo> prestamos = [];

  late Future<void> _prestamosFuture;

  @override
  void initState() {
    super.initState();
    _prestamosFuture = _initializePrestamos();
  }

  Future<void> _initializePrestamos() async {
    prestamos = await controlador.obtenerPrestamos();
  }

  Future<void> _pausarPrestamo(String numeroPrestamo) async {
    await controlador.pausarPrestamo(numeroPrestamo);
    setState(() {
      _prestamosFuture = _initializePrestamos();
    });
  }

  Future<void> _activarPrestamo(String numeroPrestamo) async {
    await controlador.activarPrestamo(numeroPrestamo);
    setState(() {
      _prestamosFuture = _initializePrestamos();
    });
  }

  Future<void> _borrarPrestamo(String numeroPrestamo) async {
    await controlador.borrarPrestamo(numeroPrestamo);
    setState(() {
      _prestamosFuture = _initializePrestamos();
    });
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
            Text("Oferta de Préstamos", style: TextStyle(color: Colors.white)),
            Text(
              "Usuario: ${widget.empleado.nombreEmpleado}",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          FutureBuilder(
            future: _prestamosFuture,
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
                              itemCount: prestamos.length,
                              itemBuilder: (context, index) {
                                final prestamo = prestamos[index];
                                return _buildPrestamoCard(prestamo);
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
        backgroundColor: colorsv.confirmado,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => VistaAltaprestamos(titulo: "Nuevo Préstamo"),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPrestamoCard(Prestamo prestamo) {
    return Card(
      color: colorCard,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => VistaSolicitudPrestamo(
                    prestamo: prestamo,
                    usuario: widget.usuario,
                    empleado: widget.empleado,
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
                      CircleAvatar(radius: 10, backgroundColor: colorCircle),
                      SizedBox(width: 10),
                      Text(
                        "Préstamo: ${prestamo.numeroPrestamo}",
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
                              "Monto: ${prestamo.monto}",
                              style: TextStyle(
                                color: colorTexto,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "Meses: ${prestamo.meses}",
                              style: TextStyle(color: colorTexto, fontSize: 14),
                            ),
                            Text(
                              "Tasa de Interés: ${prestamo.tasaInteres} %",
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
            Positioned(
              top: 5,
              right: 5,
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'Pausar') {
                    _pausarPrestamo(prestamo.numeroPrestamo);
                  } else if (value == 'Activar') {
                    _activarPrestamo(prestamo.numeroPrestamo);
                  } else if (value == 'Borrar') {
                    _borrarPrestamo(prestamo.numeroPrestamo);
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(value: 'Pausar', child: Text('Pausar')),
                      PopupMenuItem(value: 'Activar', child: Text('Activar')),
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
