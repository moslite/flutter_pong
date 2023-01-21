import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../managers/score_notifier.dart';
import 'size_aware_game.dart';

class PongApp extends StatelessWidget {
  PongApp({super.key});

  final scoreNotifier = ScoreNotifier();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ChangeNotifierProvider.value(
          value: scoreNotifier,
          child: Column(
            children: [
              Builder(
                builder: (context) {
                  return SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ColoredBox(
                      color: Colors.black,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            Provider.of<ScoreNotifier>(context)
                                .leftScore
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                          Text(
                            Provider.of<ScoreNotifier>(context)
                                .rightScore
                                .toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const Flexible(
                child: SizeAwareGame(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
