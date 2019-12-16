import 'dart:ui';
import 'package:flutter/painting.dart';
import 'package:new_flame_game/flame_game.dart';
import 'package:new_flame_game/view.dart';

class RetryButton {
  final FlameGame game;
  Rect button;
  Paint buttonPaint;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  RetryButton(this.game) {
    //Initialize RETRY button as a Rect
    button = Rect.fromLTWH(
      game.tileSize * 1.5,
      (game.screenSize.height * 0.88) - (game.tileSize * 1.5),
      game.tileSize * 6,
      game.tileSize * 2,
    );
    buttonPaint = Paint();
    buttonPaint.color = Color(0xff00ffcc);

    //Initialize RETRY message display
    textStyle = TextStyle(
      color: Color(0xff000000),
      fontSize: 50,
      fontWeight: FontWeight.bold,
    );

    painter = TextPainter(
      text: TextSpan( text: 'RETRY', style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
      (game.screenSize.height * 0.85) - (painter.height / 2),
    );
  }

  void render(Canvas canvas) {
    canvas.drawRect(button, buttonPaint);
    painter.paint(canvas, position);
  }

  void update(double t) {}

  void onTapDown() {
    game.activeView = View.playing;
    game.newHighscore = false;
    game.score = 0;
  }
}
