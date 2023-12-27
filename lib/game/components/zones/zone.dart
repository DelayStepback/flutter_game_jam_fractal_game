import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:game_jam/game/wild_territory_game.dart';

enum ZoneEnum { winter, earth, water }

class Zone extends RectangleComponent {
  Zone(this.pos, this.sizeComp);

  Vector2 pos;
  Vector2 sizeComp;

  @override
  Future<void> onLoad() async {
    priority = 0;
    position = pos;
    size = sizeComp;
    super.onLoad();
  }

}

class WinterZone extends Zone {
  WinterZone(super.pos, super.size);
}

class EarthZone extends Zone {
  EarthZone(super.pos, super.size);
}

class WaterZone extends Zone {
  WaterZone(super.pos, super.size);
}
