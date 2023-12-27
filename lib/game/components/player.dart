import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/body_component.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:game_jam/game/components/zones/zone.dart';
import 'package:game_jam/game/wild_territory_game.dart';

import 'enemy.dart';

enum MoveEnum { left, right, top, bottom }


class PlayerHitBox extends CircleHitbox{
  PlayerHitBox(){
    triggersParentCollision = false;
  }
}

class Player extends BodyComponent with ContactCallbacks {
  Player({required this.pos});

  double health = 100;
  double score = 0;

  late Vector2 pos;
  late Vector2 playerSize;

  late PlayerHitBox playerHitbox;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    playerSize =
        Vector2(WildTerritoryGame.worldScale, WildTerritoryGame.worldScale);

    playerHitbox =PlayerHitBox()..radius=playerSize.x;
    add(CircleComponent()..radius=playerSize.x..anchor=Anchor.center..add(playerHitbox..debugMode=true));

    renderBody = true;
  }

  void increaseScore(){
    score += 20;
    if (score % 100 == 0){

    }
    body.angularVelocity = score/5;
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      userData: this,
      angularDamping: 0.8,
      position: pos,
      type: BodyType.dynamic,
      // active: true,
    );

    final shape = CircleShape()
      ..radius = 3; //setAsBoxXY(game.size.x / 200, game.size.x / 200)
    final fixtureDef = FixtureDef(shape)
      ..density = 5
      ..friction = .1
      ..restitution = .1;
    return world.createBody(bodyDef)
      ..createFixture(fixtureDef)
      ..angularVelocity = radians(0)
      ..linearDamping = 2;
  }

  void move(MoveEnum moveEnum) {
    double impulseScale = 600;
    switch (moveEnum) {
      case MoveEnum.left:
        body.applyLinearImpulse(Vector2(-1 * impulseScale, 0));
      case MoveEnum.right:
        body.applyLinearImpulse(Vector2(1 * impulseScale, 0));

      case MoveEnum.top:
        body.applyLinearImpulse(Vector2(0, -1 * impulseScale));
      case MoveEnum.bottom:
        body.applyLinearImpulse(Vector2(0, 1 * impulseScale));
    }
  }
}
