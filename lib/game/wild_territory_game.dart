import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_jam/game/components/enemy.dart';
import 'package:game_jam/game/components/player.dart';
import 'package:game_jam/game/components/zones/zone.dart';
import 'package:game_jam/services/terrain_service.dart';

import 'components/wall.dart';

class WildTerritoryGame extends Forge2DGame with KeyboardEvents {
  WildTerritoryGame() : super(gravity: Vector2(0, 0));



  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;

    // final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowUp)) {
        world.firstChild<Player>()?.move(MoveEnum.top);
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        world.firstChild<Player>()?.move(MoveEnum.left);
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        world.firstChild<Player>()?.move(MoveEnum.right);
      }
      if (keysPressed.contains(LogicalKeyboardKey.arrowDown)) {
        world.firstChild<Player>()?.move(MoveEnum.bottom);
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  late Player myPlayer;

  @override
  Color backgroundColor() => const Color(0xFF043333);

  List<List<double>> terrain = [];
  int n = pow(2, 6).toInt() + 1; // g1 : 128
  double d = 0.8;
  TerrainService terrainService = TerrainService();
  Vector2 gamingSize = Vector2(64, 64);
  static const double worldScale = 4.0; // g1: 10.0

  @override
  Future<void> onLoad() async {

    terrain = terrainService.makeTerrain(n, d, terrainService.fixed);
    print(terrain[0].reduce(max));
    print(terrain[0].reduce(min));
    await super.onLoad();
    camera.viewport.add(FpsTextComponent());

    for (int i = 0; i < terrain.length; i++) {
      for (int j = 0; j < terrain[i].length; j++) {
        Zone tempZone;
        double terrainWeight = terrain[i][j];
        if (terrainWeight > 0.53 &&terrainWeight < 0.55){
          world.add(Enemy(pos: Vector2(-n + i * worldScale, -n + j * worldScale))..priority=99);
        }
        
        if (terrainWeight > 0.5) {
          tempZone = WinterZone(
              Vector2(-n + i * worldScale, -n + j * worldScale),
              Vector2(worldScale, worldScale));
          tempZone.setColor(Colors.grey);
          world.add(tempZone);
        } else if (-0.5 <= terrainWeight && terrainWeight <= 0.5) {
          tempZone = EarthZone(
              Vector2(-n + i * worldScale, -n + j * worldScale),
              Vector2(worldScale, worldScale));
          tempZone.setColor(Colors.green);
          world.add(tempZone);
        } else if (terrainWeight < -0.5) {
          tempZone = WaterZone(
              Vector2(-n + i * worldScale, -n + j * worldScale),
              Vector2(worldScale, worldScale));
          tempZone.setColor(Colors.blueAccent);
          world.add(tempZone);
        }
        // world.add(RectangleComponent()
        //   ..setColor(
        //       // Color.fromRGBO(255, (55 + 100 * terrain[i][j]).toInt(), 255, 1)
        //       colorPicker(terrain[i][j]))
        //   // ..radius = worldScale/2
        //   ..size = Vector2(worldScale, worldScale)
        //   ..priority = 0
        //   ..position = Vector2(-n + i * worldScale, -n + j * worldScale));
      }
    }

    myPlayer = Player(pos: Vector2(0, 0))..priority = 99;
    world.add(myPlayer);
    world.addAll(createBoundaries());
  }

  int await = 100;

  @override
  void update(double dt) {
    await--;

    if (await == 5) {
      camera.follow(myPlayer);
    }
    super.update(dt);
  }

  List<Component> createBoundaries() {
    double scale = worldScale - 1;
    final topLeft = Vector2(-gamingSize.x, -gamingSize.y);
    final topRight = Vector2(gamingSize.x * scale, -gamingSize.y);
    final bottomRight = Vector2(gamingSize.x * scale, gamingSize.y * scale);
    final bottomLeft = Vector2(-gamingSize.x, gamingSize.y * scale);

    return [
      Wall(topLeft, topRight),
      Wall(topRight, bottomRight),
      Wall(bottomLeft, bottomRight),
      Wall(topLeft, bottomLeft),
    ];
  }
}

Color colorPicker(double num) {
  if (num > 0.5) {
    return Colors.grey;
  } else if (-0.5 <= num && num <= 0.5) {
    return Colors.green;
  } else if (num < -0.5) {
    return Colors.blueAccent;
  }
  return Colors.black;
}
