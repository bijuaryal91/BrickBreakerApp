import 'package:flutter/material.dart';

class CoverScreen extends StatelessWidget {
  final bool hasGameStarted;
  const CoverScreen({super.key, required this.hasGameStarted});

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container()
        : Container(
            alignment: const Alignment(0, -0.3),
            child: const Text(
              "Tap to play",
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  fontFamily: "CabinSketch"),
            ),
          );
  }
}
