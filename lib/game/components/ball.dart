import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../pong.dart';
import 'paddle.dart';

class Ball extends CircleComponent with HasGameRef<Pong>, CollisionCallbacks {
  Ball({required super.position, required super.radius});

  late ShapeHitbox hitBox;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    final defaultPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    hitBox = CircleHitbox()
      ..paint = defaultPaint
      ..renderShape = true;
    add(hitBox);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Paddle) {
      gameRef.ballMovingLeft = !gameRef.ballMovingLeft;
      gameRef.increaseBallSpeed();
      return;
    }
  }
}
