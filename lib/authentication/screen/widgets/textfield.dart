import 'package:flutter/material.dart';

import '../../../theme/main_theme.dart';

class Textfield extends StatefulWidget {
  final Stream<Object> stream;
  final Function(String) onChanged;
  final TextEditingController controller;
  final TextInputType inputType;
  final String label;

  const Textfield(
      {super.key,
      required this.controller,
      required this.stream,
      required this.label,
      required this.onChanged,
      required this.inputType});

  @override
  State<Textfield> createState() => _TextfieldState();
}

class _TextfieldState extends State<Textfield> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<Object>(
          stream: widget.stream,
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  borderRadius: borderRadius16,
                  clipBehavior: Clip.hardEdge,
                  child: Container(
                    // height: 60,
                    color: Colors.grey.shade100,
                    child: TextField(
                      onChanged: widget.onChanged,
                      keyboardType: widget.inputType,
                      controller: widget.controller,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.label,
                        contentPadding: const EdgeInsets.only(
                            left: 15, bottom: 11, top: 11, right: 15),
                      ),
                    ),
                  ),
                ),
                snapshot.hasError
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          snapshot.error.toString(),
                          style:
                              const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      )
                    : Container(),
              ],
            );
          }),
    );
  }
}
