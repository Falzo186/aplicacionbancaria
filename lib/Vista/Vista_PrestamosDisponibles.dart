import 'package:aplicacionbancaria/Controlador/Controlador_Prestamos.dart';
import 'package:flutter/material.dart';
import '../Modelo/Prestamo.dart';
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

class VistaPrestamosDisponibles extends StatefulWidget {
  const VistaPrestamosDisponibles({super.key, required this.usuario});
  final Usuario usuario;

  @override
  _VistaPrestamosDisponiblesState createState() => _VistaPrestamosDisponiblesState();
}

class _VistaPrestamosDisponiblesState extends State<VistaPrestamosDisponibles> {
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
              "Oferta de Préstamos",
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
          // Positioned.fill(
          //   child: Opacity(
          //     opacity: 0.1,
          //     child: Image.asset(
          //       'lib/Recursos/logo.png',
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),
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

  Widget _buildPrestamoCard(Prestamo prestamo) {
    return Card(
      color: colorCard,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
          title: Text(
            "Detalles del Préstamo",
            style: TextStyle(color: colorTexto, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Número de Préstamo: ${prestamo.numeroPrestamo}",
                style: TextStyle(color: colorTexto, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Monto: ${prestamo.monto}",
                style: TextStyle(color: colorTexto, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Meses: ${prestamo.meses}",
                style: TextStyle(color: colorTexto, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Tasa de Interés: ${prestamo.tasaInteres}",
                style: TextStyle(color: colorTexto, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                "Cuota Mensual: ${(prestamo.monto * (1 + (prestamo.tasaInteres / 100)) / prestamo.meses).toStringAsFixed(2)}",
                style: TextStyle(color: colorTexto, fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cerrar",
                style: TextStyle(color: colorTexto),
              ),
            ),
            TextButton(
              onPressed: () {
                // Acción para aceptar el préstamo
                Navigator.of(context).pop();
              },
              child: Text(
                "Aceptar",
                style: TextStyle(color: colorCircle),
              ),
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 10,
                    backgroundColor: colorCircle, // Puedes cambiar el color del círculo
                  ),
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
      ),
    );
  }
}
