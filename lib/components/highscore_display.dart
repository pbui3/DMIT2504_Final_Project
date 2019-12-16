import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:new_flame_game/flame_game.dart';

class HighscoreDisplay {
  final FlameGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;
  TextPainter congratsPainter;
  TextStyle congratsTextStyle;
  Offset congratsPosition;

  HighscoreDisplay(this.game) {
    //Initialize the highscore display
    painter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 50,
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

    //Initialize the congrats display
    congratsTextStyle = TextStyle(
      color: Color(0xff00ffcc),
      fontSize: 43,
      fontWeight: FontWeight.bold,
    );

    congratsPainter = TextPainter(
      text: TextSpan( text: 'NEW HIGH SCORE!!!', style: congratsTextStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    congratsPainter.layout();

    congratsPosition = Offset(
      (game.screenSize.width / 2) - (congratsPainter.width / 2),
      (game.screenSize.height * 0.7) - (congratsPainter.height / 2),
    );

    //Call to manually update the highscore
    updateHighscore();
  }

  void render(Canvas canvas) {
    painter.paint(canvas, position);
    //Display congrats if new highscore and reset the flag
    if (game.newHighscore) {
      congratsPainter.paint(canvas, congratsPosition);
    }
  }

  void updateHighscore() {
    //Get highscore form database
    int highscore = game.storage.getInt('highscore') ?? 0;

    painter.text = TextSpan(
      text: 'High Score: $highscore',
      style: textStyle,
    );

    painter.layout();

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
        (game.screenSize.height * 0.6) - (painter.height / 2),
    );
  }
}
