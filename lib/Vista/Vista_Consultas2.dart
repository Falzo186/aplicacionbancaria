import 'package:flutter/material.dart';

import '../Controlador/Controlador_main.dart';
import '../Modelo/Etiqueta.dart';

final mainController = MainController();


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showMenu = false;
  double _menuWidth = 0;

  String seleccion = 'Seleccione';


  List<Etiqueta> etiquetas = [
    Etiqueta(nombre: 'Etiqueta 1', tipo: 'Tipo 1'),
    Etiqueta(nombre: 'Etiqueta 2', tipo: 'Tipo 2'),
    Etiqueta(nombre: 'Etiqueta 3', tipo: 'Tipo 3'),
    Etiqueta(nombre: 'Etiqueta 4', tipo: 'Tipo 4'),
  ];

  void toggleMenu() {
    setState(() {
      _showMenu = !_showMenu;
      _menuWidth = _showMenu ? 200 : 0;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF4E332E),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ventanilla no. 4",
                                    style: TextStyle(color: Colors.white, fontSize: 18),
                                  ),
                                  Text(
                                    "Matrícula: 102346501",
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                ],
                              ),
                              Text(
                                "Sesión: Fulanito Detal",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Ingrese el nombre o código de identificación",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Filtrado:",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 150,
                                child: DropdownButtonFormField<String>(
                                  hint: Text(seleccion),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  items: [
                                    DropdownMenuItem(value: 'Préstamos', child: Text('Préstamos')),
                                    DropdownMenuItem(value: 'Inversión', child: Text('Inversión')),
                                    DropdownMenuItem(value: 'Seguros', child: Text('Seguros')),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      seleccion = value.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              IconButton(
                                icon: Icon(Icons.menu, color: Colors.white),
                                onPressed: toggleMenu,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // ----------------- CONTENIDO (Etiquetas) -----------------
                    Expanded(
                      child: Center(
                        child: Container(
                          margin: EdgeInsets.all(20),
                          color: const Color(0xFFB1ACAC),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: ListView.builder(
                              itemCount: etiquetas.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    title: Text(
                                      etiquetas[index].nombre,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(etiquetas[index].tipo),
                                    onTap: () => mainController.mostrarOpcionesPago(context, etiquetas[index].nombre),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ----------------- MENÚ DESLIZANTE (DERECHA) -----------------
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: _menuWidth,
                height: double.infinity,
                color: Color.fromARGB(255, 82, 59, 59),
                child: _showMenu
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Menú",
                              style: TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            Divider(),
                            TextButton(
                             onPressed: () => mainController.confirmLogout(context),
                              child: Text(
                                "Cerrar Sesión 1",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}