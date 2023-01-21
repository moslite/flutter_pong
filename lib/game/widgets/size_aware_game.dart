import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../managers/score_notifier.dart';
import '../pong.dart';

class SizeAwareGame extends StatelessWidget {
  const SizeAwareGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scoreNotifier = Provider.of<ScoreNotifier>(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GameWidget(game: Pong(constraints, scoreNotifier));
      },
    );
  }
}
