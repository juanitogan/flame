//import 'package:pogo/src/game/game_main.dart';

/// This is a skeleton Game Entity.
/// Really, it is just a placeholder for now until we find a reason to use it...
/// and so others don't steal it.  Call it a reserved name.
/// Well, it was called GameEntity until I decided to not build for the future
/// and renamed BasicGameEntity > GameEntity, thus GameEntity > GameEntityCore.
///
///
/// Entities are composed of entity components and can also contain child entities.
///
/// This is not intended for regular use with the [Game] loop, but can be.
/// Use [GameEntity] instead.
/// This is intended for use by those looking to build their own entity system.
///
/// Anything that either renders or updates can be added to the entity list on [Game]
/// and it will call those methods for you.
/// Entities also have other methods that can help you out if you want to overwrite them.
abstract class GameEntityCore {
  //final UniqueKey uniqueKey = UniqueKey();
  /*
  bool enabled = true;

  Set<GameEntity> children = {};

  /// Whether this should be destroyed or not.
  ///
  /// It will be called once per component per loop, and if it returns true,
  /// [BasicGame] will mark your component for deletion and remove it before the next loop.
  bool destroy() => false;

  /// Whether this component is HUD object or not.
  ///
  /// HUD objects ignore the [BasicGame.camera] when rendered (so their position
  /// coordinates are considered relative to the device screen).
  bool isHud() => false;
   */

}
