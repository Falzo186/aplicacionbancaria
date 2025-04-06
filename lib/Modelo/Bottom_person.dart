import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Asegúrate de tener este paquete en pubspec.yaml

class BottomPerson extends StatelessWidget implements PreferredSizeWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double borderRadius;
  final TextStyle? textStyle;
  final double userHeight;

  BottomPerson({
    required this.text,
    required this.onPressed,
    required this.userHeight,
    this.backgroundColor = Colors.amber,
    this.borderRadius = 15.0,
    this.textStyle,
  });

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: Size(
            double.infinity,
            50,
          ), // Ancho completo y altura de 50
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style:
              textStyle ??
              GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildButton();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
