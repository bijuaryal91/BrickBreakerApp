import 'dart:async';

import 'package:brick_breaker_app/screens/ball.dart';
import 'package:brick_breaker_app/screens/bricks.dart';
import 'package:brick_breaker_app/screens/coverscreen.dart';
import 'package:brick_breaker_app/screens/gameoverscreen.dart';
import 'package:brick_breaker_app/screens/player.dart';
import 'package:flutter/material.dart';

class MainGame extends StatefulWidget {
  const MainGame({super.key});

  @override
  State<MainGame> createState() => _MainGameState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _MainGameState extends State<MainGame> {
  // ball properties
  double ballX = 0;
  double ballY = 0;
  double ballXIncrements = 0.02;
  double ballYIncrements = 0.01;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  // player properties
  double playerX = -0.2;
  double playerWidth = 0.4;

  // brick properties
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;
  static double brickWidth = 0.4;
  static double brickHeight = 0.05;
  static double brickGap = 0.01;
  static int numberOfBricksInRow = 3;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * brickWidth -
          (numberOfBricksInRow - 1) * brickGap);
  // game settings
  bool hasGameStarted = false;
  bool isGameOver = false;
  // bool brickBroken = false;

  List MyBricks = [
    // {x, y, broken = true/false}
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
  ];

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // Update ball direction
      updateDirection();
      // Move ball
      moveBall();

      if (isPlayerDead()) {
        timer.cancel();
        isGameOver = true;
      }

      // check if brick is hit
      checkForBrokenBrick();
    });
  }

  // Check if brick is broken or not
  void checkForBrokenBrick() {
    for (int i = 0; i < MyBricks.length; i++) {
      if (ballX >= MyBricks[i][0] &&
          ballX <= MyBricks[i][0] + brickWidth &&
          ballY <= MyBricks[i][1] + brickHeight &&
          MyBricks[i][2] == false) {
        setState(() {
          MyBricks[i][2] = true;

          double leftSideDist = (MyBricks[i][0] - ballX).abs();
          double rightSideDist = (MyBricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (MyBricks[i][1] - ballY).abs();
          double bottomSideDist = (MyBricks[i][1] + brickHeight - ballY).abs();

          String min =
              findMin(leftSideDist, rightSideDist, topSideDist, bottomSideDist);

          switch (min) {
            case 'left':
              // if ball hit left side of briY
              ballXDirection = direction.LEFT;
              break;
            case 'right':
              // if ball hit right side of briY
              ballXDirection = direction.RIGHT;
              break;
            case 'up':
              // if ball hit up side of briY
              ballYDirection = direction.UP;
              break;
            case 'down':
              // if ball hit down side of briY
              ballYDirection = direction.DOWN;
              break;
          }
        });
      }
    }
  }

  String findMin(double a, double b, double c, double d) {
    List<double> myList = [
      a,
      b,
      c,
      d,
    ];
    double currentMin = a;
    for (int i = 0; i < myList.length; i++) {
      if (myList[i] < currentMin) {
        currentMin = myList[i];
      }
    }

    if ((currentMin - a).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - b).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - c).abs() < 0.01) {
      return 'top';
    } else if ((currentMin - d).abs() < 0.01) {
      return 'bottom';
    }
    return '';
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void moveBall() {
    setState(() {
      // Horizontal Movement
      if (ballXDirection == direction.LEFT) {
        ballX -= ballXIncrements;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += ballXIncrements;
      }
      // Vertical Movement
      if (ballYDirection == direction.DOWN) {
        ballY += ballYIncrements;
      } else if (ballYDirection == direction.UP) {
        ballY -= ballYIncrements;
      }
    });
  }

  void updateDirection() {
    setState(() {
      // Ball goes up when it hits player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerX + playerWidth) {
        ballYDirection = direction.UP;
      }
      // Ball goes down if it hits top
      else if (ballY <= -1) {
        ballYDirection = direction.DOWN;
      }
      // ball goes left when it hits right
      if (ballX >= 1) {
        ballXDirection = direction.LEFT;
      }
      // ball goes right when it hits left
      else if (ballX <= -1) {
        ballXDirection = direction.RIGHT;
      }
    });
  }

  void onHorizontalSlide(DragUpdateDetails details) {
    setState(() {
      if (hasGameStarted) {
        // Update the position based on the drag delta
        playerX +=
            details.delta.dx / 100; // Normalize the delta based on screen width

        // Ensure the paddle stays within the bounds

        // Left boundary
        if (playerX < -1) {
          playerX = -1; // Adjust to the left boundary
        }
        // Right boundary
        else if (playerX + playerWidth > 1) {
          playerX = 1 - playerWidth; // Adjust to the right boundary
        }
      }
    });
  }

  void resetGame() {
    setState(() {
      playerX = -0.2;
      ballX = 0;
      ballY = 0;
      isGameOver = false;
      hasGameStarted = false;

      MyBricks = [
        // {x, y, broken = true/false}
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startGame,
      onHorizontalDragUpdate: onHorizontalSlide,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              // Tap to play
              CoverScreen(hasGameStarted: hasGameStarted),

              // Game Over
              GameOverScreen(
                isGameOver: isGameOver,
                function: resetGame,
              ),
              // ball
              MyBall(
                ballX: ballX,
                ballY: ballY,
                hasGameStarted: hasGameStarted,
                isGameOver: isGameOver,
              ),
              // Player
              MyPlayer(
                playerX: playerX,
                playerWidth: playerWidth,
              ),

              for (int i = 0; i < MyBricks.length; i++)

                //Bricks
                MyBrick(
                  brickX: MyBricks[i][0],
                  brickY: MyBricks[i][1],
                  brickBroken: MyBricks[i][2],
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                )
            ],
          ),
        ),
      ),
    );
  }
}
