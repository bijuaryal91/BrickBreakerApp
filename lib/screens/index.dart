import 'package:brick_breaker_app/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class BrickBreaker extends StatefulWidget {
  const BrickBreaker({super.key});

  @override
  State<BrickBreaker> createState() => _BrickBreakerState();
}

class _BrickBreakerState extends State<BrickBreaker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  height: 120,
                  width: 120,
                  image: AssetImage('assets/logo.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                WidgetAnimator(
                  atRestEffect: WidgetRestingEffects.wave(),
                  child: const Text(
                    "Brick Breaker",
                    style: TextStyle(
                        fontFamily: 'CabinSketch',
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 180,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(_fadePageRoute(const MainGame()));
                      },
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Developed By Biju Aryal",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'CabinSketch',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
