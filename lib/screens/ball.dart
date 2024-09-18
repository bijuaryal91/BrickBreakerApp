import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  final ballX;
  final ballY;
  final bool hasGameStarted;
  final bool isGameOver;
  const MyBall(
      {super.key,
      this.ballX,
      this.ballY,
      required this.hasGameStarted,
      required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    return !hasGameStarted || isGameOver
        ? Container(
            alignment: Alignment(ballX, ballY),
            child: AvatarGlow(
              startDelay: const Duration(milliseconds: 1000),
              glowColor: Colors.white,
              glowShape: BoxShape.circle,
              // animate: _animate,
              curve: Curves.fastOutSlowIn,
              child: const Material(
                elevation: 8.0,
                shape: CircleBorder(),
                color: Colors.transparent,
                child: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  radius: 10.0,
                ),
              ),
            ),
          )
        : Container(
            alignment: Alignment(ballX, ballY),
            child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
            ),
          );
  }
}
