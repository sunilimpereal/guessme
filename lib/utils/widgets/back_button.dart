import 'package:flutter/material.dart';

class AppBackButton extends StatelessWidget {
  final Function onPressed;
  const AppBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.hardEdge,
      color: Colors.grey.shade200,
      child: Ink(
          child: InkWell(
        onTap: () {
          onPressed();
        },
        child: const Padding(
          padding: const EdgeInsets.all(4.0),
          child: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
      )),
    );
  }
}
