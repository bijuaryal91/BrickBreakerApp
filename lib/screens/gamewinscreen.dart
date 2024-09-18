import 'package:brick_breaker_app/screens/index.dart';
import 'package:flutter/material.dart';

class GameWinScreen extends StatelessWidget {
  final bool isGameWon;
  final function;
  const GameWinScreen({super.key, required this.isGameWon, this.function});

  @override
  Widget build(BuildContext context) {
    return isGameWon
        ? Stack(
            children: [
              Container(
                alignment: const Alignment(0, -0.2),
                child: const Text(
                  "You Won!",
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
              Container(
                alignment: const Alignment(0, 0.15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(_fadePageRoute(const BrickBreaker()));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      color: Colors.deepOrange,
                      child: const Text(
                        "Exit",
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

  PageRouteBuilder _fadePageRoute(Widget page) {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          var fadeAnimation =
              CurvedAnimation(parent: animation, curve: Curves.easeInOut);

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: offsetAnimation,
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(seconds: 1));
  }
}
