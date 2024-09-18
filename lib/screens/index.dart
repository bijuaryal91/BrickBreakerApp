import 'package:flutter/material.dart';

class BrickBreaker extends StatefulWidget {
  const BrickBreaker({super.key});

  @override
  State<BrickBreaker> createState() => _BrickBreakerState();
}

class _BrickBreakerState extends State<BrickBreaker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Brick Breaker",
              style: TextStyle(
                  fontFamily: 'CabinSketch',
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 80,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
              ),
              onPressed: () {},
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
