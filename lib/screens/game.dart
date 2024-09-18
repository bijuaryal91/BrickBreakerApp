import 'dart:async';

import 'package:brick_breaker_app/screens/ball.dart';
import 'package:brick_breaker_app/screens/bricks.dart';
import 'package:brick_breaker_app/screens/coverscreen.dart';
import 'package:brick_breaker_app/screens/gameoverscreen.dart';
import 'package:brick_breaker_app/screens/gamewinscreen.dart';
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
  bool isGameWon = false;
  // bool brickBroken = false;

  List MyBricks = [
    // {x, y, broken = true/false}
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY + 0.07, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY + 0.07, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY + 0.07, false],
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY + 0.14, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY + 0.14, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY + 0.14, false],
    [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY + 0.21, false],
    [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY + 0.21, false],
    [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY + 0.21, false],
  ];

  void startGame() {
    hasGameStarted = true;
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      // Check if the game is won
      if (isGameWon) {
        timer.cancel(); // Stop the timer if the game is won
        return;
      }

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

  void checkForBrokenBrick() {
    for (int i = 0; i < MyBricks.length; i++) {
      if (MyBricks[i][2] == false) {
        // Only check if the brick is not broken
        double brickX = MyBricks[i][0];
        double brickY = MyBricks[i][1];

        // Calculate the ball's position
        double ballLeft = ballX - 0.02; // Assuming ballRadius is defined
        double ballRight = ballX + 0.02;
        double ballTop = ballY + 0.02;
        double ballBottom = ballY - 0.02;

        // Check for collision
        if (ballRight >= brickX &&
            ballLeft <= brickX + brickWidth &&
            ballBottom <= brickY + brickHeight &&
            ballTop >= brickY) {
          setState(() {
            MyBricks[i][2] = true; // Mark the brick as broken

            // Determine the side of the collision
            double ballRadius = 0.02; // Assuming this is the radius of the ball
            double leftSideDist = (brickX - (ballX + ballRadius)).abs();
            double rightSideDist =
                ((ballX - ballRadius) - (brickX + brickWidth)).abs();
            double topSideDist =
                ((brickY + brickHeight) - (ballY - ballRadius)).abs();
            double bottomSideDist = (ballY + ballRadius - brickY).abs();

// Find the minimum distance side
            String min = findMin(
                leftSideDist, rightSideDist, topSideDist, bottomSideDist);

// Adjust ball position and direction based on the collision side
            switch (min) {
              case 'left':
                ballXDirection = direction.LEFT;
                ballX = brickX -
                    (ballRadius + 0.01); // Move the ball out of the brick
                break;
              case 'right':
                ballXDirection = direction.RIGHT;
                ballX = brickX +
                    brickWidth +
                    (ballRadius + 0.01); // Move the ball out of the brick
                break;
              case 'top':
                ballYDirection = direction.UP;
                ballY = brickY +
                    brickHeight +
                    (ballRadius + 0.01); // Move the ball out of the brick
                break;
              case 'bottom':
                ballYDirection = direction.DOWN;
                ballY = brickY -
                    (ballRadius + 0.01); // Move the ball out of the brick
                break;
            }

// Check if the brick is hit and mark it as broken
            setState(() {
              MyBricks[i][2] = true; // Mark the brick as broken
            });
          });
        }
      }
    }

    // Check if all bricks are broken
    setState(() {
      int counter = 0;
      for (int l = 0; l < MyBricks.length; l++) {
        if (MyBricks[l][2] == true) {
          counter++;
        }
      }

      if (counter == MyBricks.length) {
        isGameWon = true; // All bricks are broken
      }
    });
  }

  String findMin(
      double leftDist, double rightDist, double topDist, double bottomDist) {
    // Initialize a variable to hold the minimum distance and the corresponding side
    double minDistance = leftDist;
    String minSide = 'left';

    // Compare distances to find the minimum
    if (rightDist < minDistance) {
      minDistance = rightDist;
      minSide = 'right';
    }
    if (topDist < minDistance) {
      minDistance = topDist;
      minSide = 'top';
    }
    if (bottomDist < minDistance) {
      minDistance = bottomDist;
      minSide = 'bottom';
    }

    return minSide;
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void moveBall() {
    // Return early if the game is won
    if (isGameWon) {
      return;
    }

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
    // Return early if the game is won
    if (isGameWon) {
      return;
    }

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
      isGameWon = false;

      MyBricks = [
        // {x, y, broken = true/false}
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY, false],
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY + 0.07, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY + 0.07, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY + 0.07, false],
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY + 0.14, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY + 0.14, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY + 0.14, false],
        [firstBrickX + 0 * (brickWidth + brickGap), firstBrickY + 0.21, false],
        [firstBrickX + 1 * (brickWidth + brickGap), firstBrickY + 0.21, false],
        [firstBrickX + 2 * (brickWidth + brickGap), firstBrickY + 0.21, false],
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
              GameWinScreen(
                isGameWon: isGameWon,
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
