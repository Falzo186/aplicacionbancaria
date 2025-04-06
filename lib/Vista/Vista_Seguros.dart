import 'package:aplicacionbancaria/Controlador/Controlador_Seguros.dart';
import 'package:aplicacionbancaria/Vista/VistaAltaSeguro.dart';
import 'package:flutter/material.dart';
import '../Modelo/Seguro.dart';

final Color colorAppbar = Color(0xFF472F2F);
final Color colorBackground = Color(0xFFB1ACAC);
final Color colorCard = Color(0xFFEDECEC);
final Color colorTexto = Color(0xFF140A0A);
final Color colorBoton = Color(0xFFA08181);

class VistaSeguros extends StatefulWidget {
  @override
  _VistaSegurosState createState() => _VistaSegurosState();
}

class _VistaSegurosState extends State<VistaSeguros> {
  List<Seguro> seguros = []; // Lista de seguros
  final Controlador = ControladorSeguros(); // Instancia del controlador

  @override
  void initState() {
    super.initState();
    _loadSeguros();
  }

  void _loadSeguros() async {
    // Llama al método del controlador para obtener los seguros
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
    // Lógica para agregar un nuevo seguro
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
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorAppbar,
        title: Text("Lista de Seguros", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body:
          seguros.isEmpty
              ? Center(child: Text("No hay seguros disponibles."))
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: seguros.length,
                itemBuilder: (context, index) {
                  final seguro = seguros[index];
                  return Card(
                    color: colorCard,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Póliza: ${seguro.numeroPoliza}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == "Pausar") {
                                    _pausarSeguro(seguro);
                                  } else if (value == "Borrar") {
                                    _borrarSeguro(seguro);
                                  }
                                },
                                itemBuilder:
                                    (context) => [
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
                          const SizedBox(height: 8),
                          Text("Tipo: ${seguro.tipoSeguro}"),
                          Text(
                            "Cobertura: \$${seguro.montoCobertura.toStringAsFixed(2)}",
                          ),
                          Text("Estado: ${seguro.estado}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarSeguro,
        backgroundColor: colorBoton,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
