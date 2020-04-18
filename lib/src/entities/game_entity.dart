//import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:pogo/src/components/text_component.dart';
import 'package:pogo/src/components/text_config.dart';
import 'package:pogo/src/entities/mixins/gesture_mixins.dart';
import 'package:pogo/src/game/game_main.dart';
//import 'package:pogo/src/vector_math.dart';

export 'package:pogo/src/game/game_main.dart';

/// This is an entity with the typical components added that most entities
/// need for use with the [Game] loop.
///
/// This gives an entity [position], [rotation], and [scale] data, and the
/// common methods of [update] and [render].
///
//abstract class BasicGameEntity extends GameEntity with BasicComponents {
abstract class GameEntity {

  //final UniqueKey uniqueKey = UniqueKey(); //TOneverDO test if useful for faster ordered set use

  bool _enabled = true;
  bool get enabled => _enabled;
  // This and child setter.
  set enabled(bool enabled) {
    _enabled = enabled;
    //_children.forEach((child) => child.enabled = enabled);
    _globalEnabled &= enabled;
  }
  bool _globalEnabled = true; // awesomeness methinks
  bool get globalEnabled => _globalEnabled;

  /// Call to mark this entity (and it's children) for destruction at the end of the current loop tick.
  @mustCallSuper
  void destroy() {
    // Parent first to save on children.remove() work, I hope.
    Game().destroyEntity(this);
    _children.forEach((child) => child.destroy());
  }

  //TODO probably don't need to set init vals... except with empty()?.. which could maybe set them itself
  Vector2 position = Vector2.zero();   // local position (considered a Vector3 for Z but no)
  int     zOrder   = 0;                // local Z order, camera at -infinity looking at +infinity
  double  rotation = 0.0;              // local rotation
  Vector2 scale    = Vector2.all(1.0); // local scale (considered a Vector3 for Z but no)

  Vector2 _globalPosition = Vector2.zero();
  int     _globalZ        = 0;
  double  _globalRotation = 0.0;
  Vector2 _globalScale    = Vector2.all(1.0);
  Vector2 get globalPosition => _globalPosition;
  int     get globalZ        => _globalZ;
  double  get globalRotation => _globalRotation;
  Vector2 get globalScale    => _globalScale;

  double get rotationDeg => rotation * radians2Degrees;
  set rotationDeg(double degrees) => rotation = degrees * degrees2Radians;

  // Can't just use setters because parents may be added, not triggering the setter.
  @nonVirtual
  void updateGlobalTransform() {
    _globalPosition = position;
    _globalZ        = zOrder;
    _globalRotation = rotation; // no Deg on purpose: Why take time for it?
    _globalScale    = scale;
    _globalEnabled  = enabled;
    GameEntity p = parent;
    while (p != null) {
      _globalPosition += p.position;
      _globalZ        += p.zOrder;
      _globalRotation += p.rotation;
      _globalScale    .multiply(p.scale);
      _globalEnabled  &= p.enabled;
      p = p.parent;
    }
  }

  /// Whether this entity is a camera overlay (UI, HUD) object or not.
  ///
  /// Overlay objects ignore the [Camera.offset] when rendered (so their position
  /// stays relative to the device screen and doesn't move with the game scene).
  bool isOverlay = false;


  // CHILDREN ////////

  GameEntity _parent;
  GameEntity get parent => _parent;
  set parent(GameEntity parent) {
    if (parent == this) {
      throw ArgumentError.value(this, "parent", "A child cannot be its own parent.");
    }
    if (_parent != null) {
      _parent._children.remove(this);
    }
    if (parent != null) {
      parent._children.add(this);
    }
    _parent = parent;
  }

  final List<GameEntity> _children = []; //TODONE disable user adding
  //List<GameEntity> get children => _children;
  @nonVirtual
  List<GameEntity> getChildren() {
    return _children;
  }

  @nonVirtual
  void addChild(GameEntity child, {bool adjustTransform = false}) {
    child.parent = this;
    if (adjustTransform) {
      child.position -= position;
      child.zOrder   -= zOrder;
      child.rotation -= rotation;
      child.globalScale.divide(scale);
    }
  }

  @nonVirtual
  void removeChild(GameEntity child, {bool adjustTransform = false}) {
    child.parent = null;
    if (adjustTransform) {
      child.position += position;
      child.zOrder   += zOrder;
      child.rotation += rotation;
      child.globalScale.multiply(scale);
    }
  }


  // CONSTRUCTORS ////////

  GameEntity(
      {
        this.position		,
        this.zOrder 		= 0,
        double  				rotation,
        double  				rotationDeg,
        this.scale			,
        enabled    			= true,
        GameEntity parent,
      }
  ) {
    position = position ?? Vector2.zero();
    if (rotationDeg == null) {
      this.rotation = rotation ?? 0.0;
    } else {
      this.rotationDeg = rotationDeg;
    }
    scale = scale ?? Vector2.all(1.0);
    this.enabled = enabled;
    // Parenting.
    //if (parent != null) {
    //	parent.addChild(this, adjustTransform: false);
    //}
    this.parent = parent;
    // Instantiate it.
    Game().lateAdd(this);

    // Check for proper gesture initialization in the game core.
    assert(this is! TapDetector || (Game().widget as GestureDetector).onTapDown != null,
    "To use this Detector, you must set 'GestureInitializer.detectTaps = true' before BasicGame() instantiation."
    );
    assert(this is! SecondaryTapDetector || (Game().widget as GestureDetector).onSecondaryTapDown != null,
    "To use this Detector, you must set 'GestureInitializer.detectSecondaryTaps = true' before BasicGame() instantiation."
    );
    assert(this is! SingleTapDetector || (Game().widget as GestureDetector).onTap != null,
    "To use this Detector, you must set 'GestureInitializer.detectSingleTaps = true' before BasicGame() instantiation."
    );
    assert(this is! DoubleTapDetector || (Game().widget as GestureDetector).onDoubleTap != null,
    "To use this Detector, you must set 'GestureInitializer.detectDoubleTaps = true' before BasicGame() instantiation."
    );
    assert(this is! LongPressDetector || (Game().widget as GestureDetector).onLongPress != null,
    "To use this Detector, you must set 'GestureInitializer.detectLongPresses = true' before BasicGame() instantiation."
    );
    assert(this is! VerticalDragDetector || (Game().widget as GestureDetector).onVerticalDragStart != null,
    "To use this Detector, you must set 'GestureInitializer.detectVerticalDrags = true' before BasicGame() instantiation."
    );
    assert(this is! HorizontalDragDetector || (Game().widget as GestureDetector).onHorizontalDragStart != null,
    "To use this Detector, you must set 'GestureInitializer.detectHorizontalDrags = true' before BasicGame() instantiation."
    );
    assert(this is! PanDetector || (Game().widget as GestureDetector).onPanStart != null,
    "To use this Detector, you must set 'GestureInitializer.detectPans = true' before BasicGame() instantiation."
    );
    assert(this is! ScaleDetector || (Game().widget as GestureDetector).onScaleStart != null,
    "To use this Detector, you must set 'GestureInitializer.detectScales = true' before BasicGame() instantiation."
    );
  }

  GameEntity.empty();


  // CORE ////////

  /// Called by the main update loop.  Override to use.
  void update() {
    // Don't do anything... unless we add a velocity component, or something.
    // Here because this a required part of the interface.
  }
  // Note: the following syntax would require the user to always concrete
  // implement this (currently optional):
  //void update();
  // Passing on that idea... for now.

  /// Called by the main render loop.  Transforms this entity on the main canvas.
  ///
  /// **Important:** All overrides should call `super.render()` first.
  /// That is, if you want your objects transformed correctly.
  ///
  // WARNING: Call super FIRST on render() overrides, to handle entity transforms.
  /*@mustCallSuper
  void render() {
    GameCanvas.main.translate(globalPosition.x, globalPosition.y);
    GameCanvas.main.rotate(globalRotation);
    GameCanvas.main.scale(globalScale.x, globalScale.y);

    if (Game().debugMode) {
      _renderDebugMode();
    }
  }*/

  /// This is a hook called by [Game] to let this component know that the screen (or flame draw area) has been update.
  ///
  /// It receives the new size.
  /// You can use the [Resizable] mixin if you want an implementation of this hook that keeps track of the current size.
  //killed by a camera//void resize() {}


  // DEBUG MODE ////////

  //use the singleton//bool debugMode = false;

  Color debugColor = const Color(0xFFFF00FF);

  /*Paint get _debugPaint => Paint()
    ..color = debugColor
    ..style = PaintingStyle.stroke
  ;

  TextConfig get _debugTextConfig => TextConfig(color: debugColor, fontSize: 12);

  // Note: Draws behind components (unless the component failed to call super.render() first).
  // If you want to draw on top of a component, add similar debug-mode draws to the component.
  void _renderDebugMode() {
    GameCanvas.main.drawCircle(Offset.zero, 5, _debugPaint);
    GameCanvas.main.drawCircle(Offset.zero, 100.0, _debugPaint);
    final String text = "x:${position.x.toStringAsFixed(1)} y:${position.y.toStringAsFixed(1)}";
    //_debugTextConfig.render(pos, const Offset(   0,   10), pivot: Pivot.topCenter);
    //_debugTextConfig.render(pos, const Offset(-100, -100), pivot: Pivot.topLeft);
    //_debugTextConfig.render(pos, const Offset( 100,  100), pivot: Pivot.bottomRight);
    final TextPainter tp = _debugTextConfig.getTextPainter(text);
    tp.paint(GameCanvas.main, Pivot.topCenter  .translateOffset(const Offset(   0,   10), tp.size));
    //tp.paint(GameCanvas.main, Pivot.topLeft    .translateOffset(const Offset(-100, -100), tp.size));
    //tp.paint(GameCanvas.main, Pivot.bottomRight.translateOffset(const Offset( 100,  100), tp.size));
  }*/

}
