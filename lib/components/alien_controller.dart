import 'dart:ui';
import 'dart:math';
import 'package:new_flame_game/components/alien.dart';

class AlienController {
  Random rnd;
  List<Alien> aliens = [];

  void render(Canvas canvas) {}

  void update(double t) {
    //Remove aliens that has been dead for 10 seconds
    aliens.removeWhere((alien) => alien.isDestroyable);
  }

  void spawnAlien(game) {
    //Spawn alien at a random point on top of the screen
    rnd = Random();
    double x = rnd.nextDouble() * (game.screenSize.width - game.tileSize);
    aliens.add(Alien(game, x, 5));
  }

  void advanceAliens(game) {
    //Move all aliens downward
    aliens.forEach((alien) => alien.alienRect = alien.alienRect.translate(0, game.tileSize + 7));
  }

  bool inverseOverlap(Rect target, Rect other) {
      //Check if two Rects overlaps with one of them inverted
    if (target.left >= other.left || other.right >= target.right) return false;
    if (target.top >= other.top || other.bottom >= target.bottom) return false;
    return true;
  }
}
