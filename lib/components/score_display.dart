import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:new_flame_game/flame_game.dart';

class ScoreDisplay {
  final FlameGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;
  int highScore;


  ScoreDisplay(this.game) {
    //Initialize the score display
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 120,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 0,
          color: Color(0xff000000),
          offset: Offset(5, 2),
        ),
      ],
    );

    position = Offset.zero;
  }

  void render(Canvas canvas) {
    painter.paint(canvas, position);
  }

  void update(double t) {
    if ((painter.text ?? '') != game.score.toString()) {
      painter.text = TextSpan(
        text: game.score.toString(),
        style: textStyle,
      );

      painter.layout();

      position = Offset(
        (game.screenSize.width / 2) - (painter.width / 2),
        (game.screenSize.height * 0.43) - (painter.height / 2),
      );
    }
  }
}
