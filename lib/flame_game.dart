import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:new_flame_game/components/alien_controller.dart';
import 'package:new_flame_game/components/score_display.dart';
import 'package:new_flame_game/components/highscore_display.dart';
import 'package:new_flame_game/components/retry_button.dart';
import 'package:new_flame_game/view.dart';
import 'package:new_flame_game/views/lose_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlameGame extends Game {
  final SharedPreferences storage;
  Size screenSize;
  double tileSize;
  AlienController aCon;
  ScoreDisplay scoreDisplay;
  HighscoreDisplay highscoreDisplay;
  int score;
  bool newHighscore = false;
  bool hasLost = false;
  View activeView = View.playing;
  LoseView loseView;
  RetryButton retryButton;

  FlameGame(this.storage) {
    initialize();
  }

  void initialize() async {
    //Get the dimentions of phone and pass it to resize
    resize(await Flame.util.initialDimensions());

    //Initialize alien controller
    aCon = AlienController();

    //Spawn first alien
    aCon.spawnAlien(this);

    //Initialize score display and highscore display
    scoreDisplay = ScoreDisplay(this);
    highscoreDisplay = HighscoreDisplay(this);

    //Initialize score
    score = 0;
    //newHighscore = false;

    //Initialize retry button and lose view
    loseView = LoseView(this);
    retryButton = RetryButton(this);
  }

  void render(Canvas canvas) {
    //Draw background the size of the screen
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xff000000);
    canvas.drawRect(bgRect, bgPaint);

    //Draw the aliens
    aCon.aliens.forEach((alien) => alien.render(canvas));

    //Draw the score display on top of aliens
    scoreDisplay.render(canvas);

    //Render lose view, highscore and retry button on top of everything
    if (activeView == View.lost) {
      loseView.render(canvas);
      retryButton.render(canvas);
      highscoreDisplay.render(canvas);
    }
  }

  void update(double t) {
    //Update the state of the aliens
    aCon.aliens.forEach((alien) => alien.update(t));
    aCon.update(t);

    //Update the score display
    scoreDisplay.update(t);

    //Check if death signal reached a living alien
    if (score > 0 && activeView != View.lost) {
      if (aCon.inverseOverlap(aCon.aliens.firstWhere((alien) => !alien.isDead).alienRect, aCon.aliens.lastWhere((alien) => alien.isDead).alienRect)) {
        lost();
      }
    }
    if (score > 1 && activeView != View.lost) {
      if (aCon.inverseOverlap(aCon.aliens.firstWhere((alien) => !alien.isDead).alienRect, aCon.aliens[aCon.aliens.lastIndexWhere((alien) => alien.isDead) - 1].alienRect)) {
        lost();
      }
    }
    if (score > 2 && activeView != View.lost) {
      if (aCon.inverseOverlap(aCon.aliens.firstWhere((alien) => !alien.isDead).alienRect, aCon.aliens[aCon.aliens.lastIndexWhere((alien) => alien.isDead) - 2].alienRect)) {
        lost();
      }
    }
    if (score > 3 && activeView != View.lost) {
      if (aCon.inverseOverlap(aCon.aliens.firstWhere((alien) => !alien.isDead).alienRect, aCon.aliens[aCon.aliens.lastIndexWhere((alien) => alien.isDead) - 3].alienRect)) {
        lost();
      }
    }
  }

  void resize(Size size) {
    screenSize = size;
    //determine the tile size (a base unit to scale with different screen size)
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    //Call alien.onTapDown if tapped an alien
    if (activeView != View.lost) {
      aCon.aliens.forEach((alien) {
        if (alien.alienRect.contains(d.globalPosition)) {
          alien.onTapDown();
        }
      });

      //Advance the aliens
      aCon.advanceAliens(this);

      //Spawn more aliens
      aCon.spawnAlien(this);
    } else {
      //If tapped retry buttony
      if (retryButton.button.contains(d.globalPosition)) {
        retryButton.onTapDown();
        aCon.aliens.forEach((alien) => alien.isDestroyable = true);
        aCon.spawnAlien(this);
      }
    }
  }

  void lost() {
    //What to do when player loses
    activeView = View.lost;

    //To make all remaining living aliens spread black quare, purely visual
    aCon.aliens.forEach((alien) => alien.isDead = true);
  }
}
