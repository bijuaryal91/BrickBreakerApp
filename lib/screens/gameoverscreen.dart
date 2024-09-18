import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  final bool isGameOver;
  final function;
  const GameOverScreen({super.key, required this.isGameOver, this.function});

  @override
  Widget build(BuildContext context) {
    return isGameOver
        ? Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.2),
                child: const Text(
                  "G A M E  O V E R",
                  style: TextStyle(
                      fontFamily: "CabinSketch",
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                      fontSize: 50),
                ),
              ),
              Container(
                alignment: const Alignment(0, 0),
                child: GestureDetector(
                  onTap: function,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.deepPurple,
                      child: const Text(
                        "Play Again",
                        style: TextStyle(
                            fontFamily: "CabinSketch",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }
}
