import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor;
  final List<Widget>? actions;
  final double height;
  final Widget? title;

  const CustomAppBar({
    Key? key,
    this.backgroundColor = Colors.blue,
    this.actions,
    this.height = kToolbarHeight,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      actions: actions,
      title: title,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
