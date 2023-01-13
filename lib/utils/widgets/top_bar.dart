import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String left;
  const TopBar({super.key, required this.left});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_rounded)),
          const SizedBox(
            width: 8,
          ),
          Text(
            left,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
