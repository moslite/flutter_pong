import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'managers/score_notifier.dart';
import 'components/ball.dart';
import 'components/paddle.dart';

class Pong extends FlameGame with HasCollisionDetection, KeyboardEvents {
  Pong(
    this.constraints,
    this.scoreNotifier,
  )   : ballMovingUp = random.nextBool(),
        ballMovingLeft = random.nextBool();

  static Random random = Random();

  BoxConstraints constraints;
  bool ballMovingUp;
  bool ballMovingLeft;
  ScoreNotifier scoreNotifier;

  PaddleMovement leftPaddleMovement = PaddleMovement.idle;
  PaddleMovement rightPaddleMovement = PaddleMovement.idle;

  static const double paddlePadding = 30;
  static const double paddleHeight = 50;
  static const double paddleWidth = 10;
  static const double ballRadius = 10;

  // Pixels per second.
  static const double startingBallSpeed = 1.5;
  double ballSpeed = Pong.startingBallSpeed;

  // Pixels per second.
  static const double paddleSpeed = 1.5;

  late Paddle leftPaddle;
  late Paddle rightPaddle;
  late CircleComponent ball;

  bool isPaused = false;

  Vector2 get startingBallPosition => Vector2(
        constraints.maxWidth / 2,
        constraints.maxHeight / 2,
      );

  Vector2 get startingRightPaddlePosition => Vector2(
        constraints.maxWidth - paddlePadding,
        constraints.maxHeight / 2,
      );

  Vector2 get startingLeftPaddlePosition => Vector2(
        paddlePadding,
        constraints.maxHeight / 2,
      );

  @override
  Color backgroundColor() => Colors.teal;

  @override
  Future<void> onLoad() async {
    final whiteFill = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    leftPaddle = Paddle(
      position: startingLeftPaddlePosition,
      anchor: Anchor.center,
      size: Vector2(paddleWidth, paddleHeight),
    )..paint = whiteFill;

    rightPaddle = Paddle(
      position: startingRightPaddlePosition,
      anchor: Anchor.center,
      size: Vector2(paddleWidth, paddleHeight),
    )..paint = whiteFill;

    ball = Ball(
      radius: ballRadius,
      position: startingBallPosition,
    );

    add(leftPaddle);
    add(rightPaddle);
    add(ball);
  }

  @override
  void update(double dt) {
    if (isPaused) return;
    _updatePaddles(dt);
    _updateBall(dt);
    super.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      rightPaddleMovement = isKeyDown ? PaddleMovement.up : PaddleMovement.idle;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      rightPaddleMovement =
          isKeyDown ? PaddleMovement.down : PaddleMovement.idle;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      leftPaddleMovement = isKeyDown ? PaddleMovement.up : PaddleMovement.idle;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      leftPaddleMovement =
          isKeyDown ? PaddleMovement.down : PaddleMovement.idle;
    }

    return super.onKeyEvent(event, keysPressed);
  }

  void _updatePaddles(double dt) {
    final double distanceTraveled = dt * 100 * paddleSpeed;
    if (leftPaddleMovement != PaddleMovement.idle) {
      leftPaddle.center += Vector2(
        0,
        leftPaddleMovement != PaddleMovement.up
            ? distanceTraveled
            : -distanceTraveled,
      );
    }
    if (rightPaddleMovement != PaddleMovement.idle) {
      rightPaddle.center += Vector2(
        0,
        rightPaddleMovement != PaddleMovement.up
            ? distanceTraveled
            : -distanceTraveled,
      );
    }

    leftPaddle.center.y = leftPaddle.center.y
        .clamp(paddleHeight / 2, constraints.maxHeight - paddleHeight / 2);
    rightPaddle.center.y = rightPaddle.center.y
        .clamp(paddleHeight / 2, constraints.maxHeight - paddleHeight / 2);
  }

  void _updateBall(double dt) {
    final double distanceTraveled = dt * 100 * ballSpeed;
    double dx = ballMovingLeft ? distanceTraveled * -1 : distanceTraveled;
    double dy = ballMovingUp ? distanceTraveled * -1 : distanceTraveled;

    ball.center += Vector2(dx, dy);

    if (ball.center.x <= ballRadius) {
      scoreNotifier.rightScored();
      _resetPositions();
      _pauseBriefly();
      ballMovingUp = random.nextBool();
      ballMovingLeft = random.nextBool();
    } else if (ball.center.x >= constraints.maxWidth - ballRadius) {
      scoreNotifier.leftScored();
      _resetPositions();
      _pauseBriefly();
      ballMovingUp = random.nextBool();
      ballMovingLeft = random.nextBool();
    }

    if (ball.center.y <= ballRadius / 2) {
      ballMovingUp = false;
      ball.center = Vector2(ball.center.x, ballRadius);
    } else if (ball.center.y >= constraints.maxHeight - ballRadius) {
      ballMovingUp = true;
      ball.center = Vector2(ball.center.x, constraints.maxHeight - ballRadius);
    }
  }

  void _pauseBriefly() {
    isPaused = true;
    Future<void>.delayed(const Duration(seconds: 3))
        .then((_) => isPaused = false);
  }

  void increaseBallSpeed() => ballSpeed = ballSpeed * 1.1;

  void _resetPositions() {
    leftPaddle.center = startingLeftPaddlePosition;
    rightPaddle.center = startingRightPaddlePosition;
    ball.center = startingBallPosition;
    ballSpeed = Pong.startingBallSpeed;
  }
}
