import 'package:aplicacionbancaria/Controlador/Controlador_Login.dart';
import 'package:aplicacionbancaria/Modelo/Ventanas.dart';
import 'package:aplicacionbancaria/Modelo/WarningModel.dart';
import 'package:flutter/material.dart';

class VistaLogin extends StatefulWidget {
  @override
  _VistaLoginState createState() => _VistaLoginState();
}

class _VistaLoginState extends State<VistaLogin> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final controlador = ControladorLogin();
  final VentanaModelo colorsv = VentanaModelo();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorsv.colorFondo2Login,
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipPath(
                    clipper: CurvedBackgroundClipper(),
                    child: Container(color: colorsv.colorFondo1Login),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorsv.colorFondo3Login,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(900),
                        topRight: Radius.circular(900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorsv.colorFondo3Login,
                      border: Border.all(
                        color: colorsv.colorFondo2Login,
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
                      color: colorsv.colorSpaceLogin,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colorsv.colorShadowSplogin,
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
                          onSubmitted: (_) => validUser(context),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person,
                              color: colorsv.colorIcons,
                            ),
                            labelText: 'Username',
                            filled: true,
                            fillColor: colorsv.colorTexto2,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.0),

                        // Campo de contraseña con icono de visibilidad
                        TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onSubmitted: (_) => validUser(context),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.lock,
                              color: colorsv.colorIcons,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: colorsv.colorIcons,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            labelText: 'Password',
                            filled: true,
                            fillColor: colorsv.colorTexto2,
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
                            backgroundColor: colorsv.colorBotonLogin,
                            padding: EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => validUser(context),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              color: colorsv.colorTexto2,
                              fontSize: 18,
                            ),
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

  void validUser(BuildContext context) async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ErrorDialog(
        context: context,
        mensaje: 'Por favor, llene todos los campos',
      ).mostrar();
    } else {
      await controlador.login(
        _usernameController.text,
        _passwordController.text,
        context,
      );
    }
  }
}

// Clipper para el fondo curvo superior
class CurvedBackgroundClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 300,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
