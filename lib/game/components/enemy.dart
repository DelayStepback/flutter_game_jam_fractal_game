import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:game_jam/game/components/enemy.dart';
import 'package:game_jam/game/components/player.dart';
import 'package:game_jam/game/wild_territory_game.dart';

class Enemy extends BodyComponent with ContactCallbacks {
  Enemy({required this.pos});

  double health = 100;

  late Vector2 pos;
  late Vector2 enemySize;

  late RectangleComponent healthPosComp;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    enemySize =
        Vector2(WildTerritoryGame.worldScale, WildTerritoryGame.worldScale);

    healthPosComp = RectangleComponent()
      ..anchor = Anchor.center
      ..position = Vector2(0, -enemySize.y * 1.4)
      ..size = Vector2(enemySize.x * 1.6, enemySize.y / 4);

    final paintComp = CircleComponent()
      ..radius = enemySize.x
      ..position = Vector2(-enemySize.x, -enemySize.y);
    paintComp.paint = Paint()..color = Colors.red;

    add(paintComp);
    add(healthPosComp);
    renderBody = true;
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Player) {
      final status = decreaseHealth(20);
      if (status == DecreaseStatus.killed) {
        other.increaseScore();
      }
    }
  }

  DecreaseStatus decreaseHealth(double value) {
    if (health - value > 0) {
      health -= value;
      healthPosComp.scale = Vector2(health / 100, 1);
      return DecreaseStatus.alive;
    } else {
      destroy();
      return DecreaseStatus.killed;
    }
  }

  void destroy() {
    world.remove(this);
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      angularDamping: 999,

      position: pos,
      type: BodyType.dynamic,
      // active: true,
    );

    final shape = CircleShape()
      ..radius = enemySize.x; //setAsBoxXY(game.size.x / 200, game.size.x / 200)
    final fixtureDef = FixtureDef(shape)
      ..density = 5
      ..friction = .1
      ..restitution = .1;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..angularVelocity = radians(0)
      ..linearDamping = 2;
  }


  List<double> offsets = [0,0,0,0]; // top,left,bottom, right

  double scaleMove =100;
  void randomMove(){

    int dir = Random().nextInt(4);
    double move = - 6 + Random().nextDouble()*12;
    switch(dir){
      case 0:
        //top
        body.applyLinearImpulse(Vector2(0, -move *scaleMove));
      case 1:
        body.applyLinearImpulse(Vector2(-move*scaleMove, 0));
      case 2:
        body.applyLinearImpulse(Vector2(0, move *scaleMove));
      case 3:
        body.applyLinearImpulse(Vector2(move*scaleMove, 0));

    }
  }


  double awaitForMove = 20;
  @override
  void update(double dt) {
    awaitForMove--;
    if (awaitForMove < 0){
      awaitForMove = 20+  Random().nextDouble()*31;
      randomMove();
    }

    super.update(dt);
  }
}

enum DecreaseStatus { killed, alive }
