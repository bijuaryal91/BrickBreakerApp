import 'package:brick_breaker_app/screens/index.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyGame());

class MyGame extends StatelessWidget {
  const MyGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BrickBreaker(),
    );
  }
}
