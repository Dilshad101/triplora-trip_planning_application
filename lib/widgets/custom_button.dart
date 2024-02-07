import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.onPressed, required this.label});
  final VoidCallback onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(Theme.of(context).primaryColor),
          fixedSize:
              MaterialStateProperty.all(const Size(double.maxFinite, 48))),
      onPressed: onPressed,
      child: Text(label,
          style: const TextStyle(fontSize: 16, color: Colors.white)),
    );
  }
}
