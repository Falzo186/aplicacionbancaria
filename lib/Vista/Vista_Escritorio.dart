import 'package:flutter/material.dart';


class EscritorioView extends StatefulWidget {
  const EscritorioView({super.key});

  @override
  _EscritorioViewState createState() => _EscritorioViewState();
}

class _EscritorioViewState extends State<EscritorioView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: Container(
          width: 600,
          height: 400,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF5B3B32),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Escritorio",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "Matricula: 102937456",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                    const Text(
                      "Sesion: Mariana Juarez Aguilar",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Image.network(
                          'https://via.placeholder.com/150',
                          width: 150,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildButton("Consultas Clientes"),
                          _buildButton("Inversiones"),
                          _buildButton("Prestaciones"),
                          _buildButton("Seguros"),
                          _buildButton("Alta Clientes"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFC4A454),
          minimumSize: const Size(200, 40),
        ),
        onPressed: () {},
        child: Text(text, style: const TextStyle(color: Colors.black)),
      ),
    );
  }
}
