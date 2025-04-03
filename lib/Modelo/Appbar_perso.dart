import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final List<Widget>? actions;
  final double height;
  final Widget? title;
  final Widget? leading; // Hacemos que leading sea opcional

  const CustomAppBar({
    Key? key,
    this.backgroundColor = Colors.blue,
    this.actions,
    this.height = kToolbarHeight,
    this.title,
    this.leading, // Lo agregamos como parámetro opcional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      actions: actions,
      title: title,
      leading: leading, // Asignamos el valor de leading
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
