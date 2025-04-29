import 'package:aplicacionbancaria/Controlador/Controlador_Seguros.dart';
import 'package:aplicacionbancaria/Vista/Vista_SolicitudSeguro.dart';
import 'package:flutter/material.dart';
import '../Modelo/Empleado.dart';
import '../Modelo/Seguro.dart';
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

class VistaSegurosDisponibles extends StatefulWidget {
  const VistaSegurosDisponibles({super.key, required this.usuario, required this.empleado});
  final Empleado empleado;
  final Usuario usuario;

  @override
  _VistaSegurosDisponiblesState createState() => _VistaSegurosDisponiblesState();
}

class _VistaSegurosDisponiblesState extends State<VistaSegurosDisponibles> {
  final ScrollController _scrollController = ScrollController();
  final controlador = ControladorSeguros();
  List<Seguro> seguros = [];

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
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Seguros Disponibles",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Usuario: ${widget.empleado.nombreEmpleado}",
              style: TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
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

  Widget _buildSeguroCard(Seguro seguro) {
    return Card(
      color: colorCard,
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VistaSolicitudSeguro(
                usuario: widget.usuario,
                seguro: seguro,
                empleado: widget.empleado,
              ),
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
                    "Seguro: ${seguro.numeroPoliza}",
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
                          "Tipo: ${seguro.tipoSeguro}",
                          style: TextStyle(
                            color: colorTexto,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Cobertura: ${seguro.montoCobertura}",
                          style: TextStyle(color: colorTexto, fontSize: 14),
                        ),
                        Text(
                          "Estado: ${seguro.estado}",
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
