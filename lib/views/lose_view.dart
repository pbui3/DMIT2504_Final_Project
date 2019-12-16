import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:new_flame_game/flame_game.dart';

class LoseView {
  final FlameGame game;
  TextPainter painter;
  TextStyle textStyle;
  Offset position;

  LoseView(this.game) {
    //Initialize YOU LOSE message display
    textStyle = TextStyle(
      color: Color(0xffffffff),
      fontSize: 82,
      fontWeight: FontWeight.bold,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 0,
          color: Color(0xffff0000),
          offset: Offset(5, 2),
        ),
      ],
    );

    painter = TextPainter(
      text: TextSpan( text: 'YOU LOSE', style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    painter.layout();

    position = Offset(
      (game.screenSize.width / 2) - (painter.width / 2),
      (game.screenSize.height * 0.25) - (painter.height / 2),
    );
  }

  void render(Canvas canvas) {
    painter.paint(canvas, position);
  }

  void update(double t) {}
}
