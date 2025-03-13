import 'package:aplicacionbancaria/Controlador/Controlador_Login.dart';
import 'package:flutter/material.dart';

class VistaLogin extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final controlador = ControladorLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D1E1E), // Marrón oscuro
      body: Stack(
        children: [
          // Fondo marrón oscuro con forma curva
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: ClipPath(
                    clipper: CurvedBackgroundClipper(),
                    child: Container(
                      color: Colors.white, // Fondo blanco
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Color(0xFF5C3B3B), // Marrón más claro
                  ),
                ),
              ],
            ),
          ),

          // Contenido de Login
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF472F2F),
                      border: Border.all(
                        color: const Color(0xFF472F2F),
                        width: 4,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'lib/Recursos/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Caja de Login
                  Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: <Widget>[
                        // Campo de usuario
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black54,
                            ),
                            labelText: 'Username',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),

                        // Campo de contraseña
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.black54),
                            labelText: 'Password',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),

                        // Botón de login
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[700],
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            if (_usernameController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.grey[800],
                                    title: Text(
                                      'Error',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    content: Text(
                                      'Debe llenar las credenciales.',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          'OK',
                                          style: TextStyle(
                                            color: Colors.brown[400],
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                                await controlador.login(
                                  _usernameController.text,
                                  _passwordController.text,
                                  context,
                                );
                            }
                          },
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Clipper para el fondo curvo superior
class CurvedBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width / 2,
      size.height -
          250, // Ajusta este valor para que la curva se hunda hacia adentro
      size.width,
      size.height - 80,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
