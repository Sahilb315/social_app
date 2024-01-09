import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
 final void Function()? onTap;
  const CustomButton({Key? key,required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(left: 10),
        child: Icon(
          Icons.done,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
