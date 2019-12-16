import 'dart:ui';
import 'package:flame/animation.dart';
import 'package:flame/sprite.dart';
import 'package:new_flame_game/flame_game.dart';
import 'package:random_color/random_color.dart';

class Alien {
  final FlameGame game;
  Rect alienRect;
  Paint signalPaint;
  double spreadSpeed;
  Animation alienAnimationController;
  RandomColor randomColor;
  List<Sprite> alienSprites;
  double lifeTime = 1;
  bool isDead = false;
  bool isDestroyable = false;

  Alien(this.game, double x, double y) {
    //Initialize aliens and color of alien's distress signal
    alienRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
    signalPaint = Paint();

    //Add sprites to a list
    alienSprites = List<Sprite>();
    alienSprites.add(Sprite('alien/square-green-alien.png'));
    alienSprites.add(Sprite('alien/square-green-alien-turned.png'));

    //Create animation spriteList
    alienAnimationController =
        Animation.spriteList(alienSprites, stepTime: 0.5);
  }

  void render(Canvas canvas) {
    if (isDead) {
      //If dead draw the signal Rect
      canvas.drawRect(alienRect, signalPaint);
    } else {
      //If not draw the current sprite
      alienAnimationController.getSprite().renderRect(canvas, alienRect);
    }
  }

  void update(double t) {
    //Update the alien's animation
    alienAnimationController.update(t);

    //Spread alien's distress signal
    changeDifficulty();
    if (isDead) {
      alienRect = alienRect.deflate(spreadSpeed);//Use deflate for the visual of shrinking in before expanding
    }

    //Mark the alien signal to be destroyed if 10 seconds have passed
    if (isDead) {
      lifeTime = lifeTime - .1 * t;
      if (lifeTime <= 0) {
        isDestroyable = true;
      }
    }
  }

  void onTapDown() {
    //Check if alien already dead to appropriately reward score
    if (!isDead) {
      isDead = true;
      game.score += 1;

      //If current score higher than highscore
      if (game.score > (game.storage.getInt('highscore') ?? 0)) {
        //Set current core as new highscore
        game.storage.setInt('highscore', game.score);

        //Update highscore for next display
        game.highscoreDisplay.updateHighscore();

        //Set flag to display the congratulations
        game.newHighscore = true;
      }
    }

    //change color of the signal Rect to a random red
    randomColor = RandomColor();
    signalPaint.color = randomColor.randomColor(
        colorHue: ColorHue.red,
        colorSaturation: ColorSaturation.highSaturation);
  }

  void changeDifficulty() {
    //Make signal spread faster as player kill more aliens
    if (game.score < 10) {
      spreadSpeed = 0.8;
    } else if (game.score < 15) {
      spreadSpeed = 1;
    } else if (game.score < 25) {
      spreadSpeed = 1.2;
    } else if (game.score < 35) {
      spreadSpeed = 1.4;
    } else if (game.score < 45) {
      spreadSpeed = 1.6;
    } else if (game.score < 55) {
      spreadSpeed = 1.8;
    } else if (game.score < 65) {
      spreadSpeed = 2;
    }
  }
}
