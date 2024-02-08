import 'package:flutter/material.dart';

class IconsContainer extends StatelessWidget {
  final bool value;
  final IconData iconFalse;
  final IconData iconTrue;
  final String? text;
  final Color? color;
  final Color? colorTrue;
  final void Function()? onPressed;
  const IconsContainer({
    super.key,
    required this.value,
    required this.iconFalse,
    required this.iconTrue,
    this.text,
    this.color,
    this.colorTrue,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: value
              ? Icon(
                  iconTrue,
                  color: colorTrue,
                  size: 22,
                )
              : Icon(
                  iconFalse,
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 22,
                ),
        ),
        Text(
          text ?? "",
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ],
    );
  }
}
