import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AsyncButton extends StatefulWidget {
  final Function onPressed;
  final Widget child;
  const AsyncButton({super.key, required this.child, required this.onPressed});

  @override
  State<AsyncButton> createState() => Asyc_ButtonState();
}

class Asyc_ButtonState extends State<AsyncButton> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(),
        onPressed: () async {
          setState(() {
            loading = true;
          });
          await widget.onPressed();
          setState(() {
            loading = false;
          });
        },
        child: loading
            ? const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : widget.child);
  }
}
