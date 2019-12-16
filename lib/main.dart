import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flame/util.dart';
import 'package:flame/flame.dart';
import 'package:new_flame_game/flame_game.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //Fix defaultBinaryMessenger error
  WidgetsFlutterBinding.ensureInitialized();

  //wait until the game goes fullscreen and change to portrait mode
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  //Load assets
  Flame.images.loadAll(<String>[
    'alien/square-green-alien.png',
    'alien/square-green-alien-turned.png'
    ]);

  //Get an instance of shared preference (To store highscore)
  SharedPreferences storage = await SharedPreferences.getInstance();

  //pass the game widget to runApp
  FlameGame game = FlameGame(storage);
  runApp(game.widget);

  //Set up the tap down gesture
  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  flameUtil.addGestureRecognizer(tapper);
}