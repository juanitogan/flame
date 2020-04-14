import 'dart:math' as math;

//import 'package:flutter/widgets.dart' hide WidgetBuilder;
//import 'package:ordered_set/comparing.dart';
//import 'package:ordered_set/ordered_set.dart';

import 'package:pogo/src/components/text_config.dart';
import 'package:pogo/src/entities/game_entity.dart';
import 'package:pogo/src/entities/mixins/gesture_mixins.dart';
import 'package:pogo/src/game/game_core.dart';
//import 'package:pogo/src/game/gestures.dart';
//import 'package:flutter/gestures.dart';

export 'package:pogo/src/game/game_core.dart'; //show Offset, Size, runApp;


/// This is an extension of [GameCore] that implements a fairly standard game loop.
/// This implements a pseudo Entity Component System -- one with the common
/// [update] loop -- and is a bit easier to ramp up on than a more pure ECS.
/// This makes [Game] a bit like other popular game engines used for rapid development.
///
/// This class is currently implement as a singleton.  Use `Game()` to access it.
class Game extends GameCore {//with TapDetector {
	// Make this a singleton.
	static final Game _game = Game._privateConstructor();
	factory Game() {
		return _game;
	}
	Game._privateConstructor();

	Game.empty();

	/// All loaded entities to be updated and rendered by [Game].
	//final _zOrderedEntities = OrderedSet<BasicGameEntity>(Comparing.on((c) => -Graphics.canvas.globalZ));
	final List<GameEntity> _zOrderedEnts = [];

	/// Entities added by the [lateAdd] method.
	final List<GameEntity> _lateEnts = [];

	/// Entities to be [destroy]ed at the end of the tick.
	final List<GameEntity> _destroyEnts = [];

	/// Entities with a [TapDetector] component to receive tap events.
	/// Current design is pass all gestures to all gesture components
	/// and not allow a component to "steal" a gesture.
	/// (If wanting to steal, it should happen by reverse Z order, I guess
	/// [which would be a bit slower to track], while resolving same-Z issues.)
	final List<GameEntity> _tapEnts = [];
	final List<GameEntity> _lateTapEnts = [];

	final List<GameEntity> _secondaryTapEnts = [];
	final List<GameEntity> _lateSecondaryTapEnts = [];

	final List<GameEntity> _singleTapEnts = [];
	final List<GameEntity> _lateSingleTapEnts = [];

	final List<GameEntity> _doubleTapEnts = [];
	final List<GameEntity> _lateDoubleTapEnts = [];

	final List<GameEntity> _longPressEnts = [];
	final List<GameEntity> _lateLongPressEnts = [];

	final List<GameEntity> _verticalDragEnts = [];
	final List<GameEntity> _lateVerticalDragEnts = [];

	final List<GameEntity> _horizontalDragEnts = [];
	final List<GameEntity> _lateHorizontalDragEnts = [];

	final List<GameEntity> _panEnts = [];
	final List<GameEntity> _latePanEnts = [];

	final List<GameEntity> _scaleEnts = [];
	final List<GameEntity> _lateScaleEnts = [];

	/// List of delta times used in debug mode to calculate FPS
	final List<double> _deltas = [];


	// ENTITY MANAGEMENT ////////

	/// This method is called for every entity added, both via [add] and [lateAdd] methods.
	///
	/// You can use this to setup your mixins, pre-calculate stuff on every entity, or anything you desire.
	/// By default, this calls the initial resize for every entity, so don't forget to call super.preAdd when overriding.
	///
	/// By definition, [GameEntity] must have the [BasicComponents] mixin
	/// (or a similar design), so no need to code that check here.
	//@mustCallSuper
	/*void preAdd(GameEntity e) {
		//e.gameRef = this;

		// initial resize
		//if (size != null) {
		//	e.resize(size);
		//}

		//if (e is Tappable) {
			//e.gameCanvasScale = scale;
		//}

		//if (debugMode) {
			//e.debugMode = true;
		//}
	}*/

	//TODO should this even exist still??
	/// Adds a new entity to the entity set.
	///
	/// Also calls [preAdd], witch in turn sets the current size on the entity
	/// (because the resize hook won't be called until a new resize happens).
	/*void add(GameEntity e) {
		//preAdd(e);
		_zOrderedEnts.add(e);
		if (e is TapDetector)            {_tapEnts.add(e);}
		if (e is SecondaryTapDetector)   {_secondaryTapEnts.add(e);}
		if (e is SingleTapDetector)      {_singleTapEnts.add(e);}
		if (e is DoubleTapDetector)      {_doubleTapEnts.add(e);}
		if (e is LongPressDetector)      {_longPressEnts.add(e);}
		if (e is VerticalDragDetector)   {_verticalDragEnts.add(e);}
		if (e is HorizontalDragDetector) {_horizontalDragEnts.add(e);}
		if (e is PanDetector)            {_panEnts.add(e);}
		if (e is ScaleDetector)          {_scaleEnts.add(e);}
		e.children.forEach(add); //TODO ???
	}*/

	/// Registers a entity to be added on the next tick.
	///
	/// Use this to add entities in places where a concurrent issue with the update method might happen.
	/// Also calls [preAdd] for the entity added, immediately.
	void lateAdd(GameEntity e) {
		//preAdd(e);
		_lateEnts.add(e);
		if (e is TapDetector)            {_lateTapEnts.add(e);}
		if (e is SecondaryTapDetector)   {_lateSecondaryTapEnts.add(e);}
		if (e is SingleTapDetector)      {_lateSingleTapEnts.add(e);}
		if (e is DoubleTapDetector)      {_lateDoubleTapEnts.add(e);}
		if (e is LongPressDetector)      {_lateLongPressEnts.add(e);}
		if (e is VerticalDragDetector)   {_lateVerticalDragEnts.add(e);}
		if (e is HorizontalDragDetector) {_lateHorizontalDragEnts.add(e);}
		if (e is PanDetector)            {_latePanEnts.add(e);}
		if (e is ScaleDetector)          {_lateScaleEnts.add(e);}
		//print("$_lateEnts from $this");

		// Hack to support PseudoGame.
		// If this is a PseudoGame add, then clear the add from the Game() singleton.
		// Could get more targeted with remove(e) instead of clear(), if ever needed.
		if (this != Game()) {
			Game()._lateEnts.clear();
			Game()._lateTapEnts.clear();
			Game()._lateSecondaryTapEnts.clear();
			Game()._lateSingleTapEnts.clear();
			Game()._lateDoubleTapEnts.clear();
			Game()._lateLongPressEnts.clear();
			Game()._lateVerticalDragEnts.clear();
			Game()._lateHorizontalDragEnts.clear();
			Game()._latePanEnts.clear();
			Game()._lateScaleEnts.clear();
		}
	}

	/// Marks the given entity for destruction at the end of the current loop tick.
	void destroyEntity(GameEntity e) {
		_destroyEnts.add(e);
	}


	// CORE EVENTS ////////

	/// Update every globalEnabled entity in the set.
	///
	/// First, remove all [destroy]ed entities, then add all [lateAdd] entities,
	/// then call [update] on the new set.
	@override
	void update() {
		_zOrderedEnts.addAll(_lateEnts);
		_lateEnts.clear();

		_tapEnts           .addAll(_lateTapEnts);            _lateTapEnts.clear();
		_secondaryTapEnts  .addAll(_lateSecondaryTapEnts);   _lateSecondaryTapEnts.clear();
		_singleTapEnts     .addAll(_lateSingleTapEnts);      _lateSingleTapEnts.clear();
		_doubleTapEnts     .addAll(_lateDoubleTapEnts);      _lateDoubleTapEnts.clear();
		_longPressEnts     .addAll(_lateLongPressEnts);      _lateLongPressEnts.clear();
		_verticalDragEnts  .addAll(_lateVerticalDragEnts);   _lateVerticalDragEnts.clear();
		_horizontalDragEnts.addAll(_lateHorizontalDragEnts); _lateHorizontalDragEnts.clear();
		_panEnts           .addAll(_latePanEnts);            _latePanEnts.clear();
		_scaleEnts         .addAll(_lateScaleEnts);          _lateScaleEnts.clear();

		// Process after adds to allow destroy in same frame as add, for whatever reason.
		_destroyEnts.forEach(_destroyMe);
		_destroyEnts.clear();

		// Sort each frame like a crazy engine.
		// Does update or render run first??? Who cares?  Where to put this?
		// Between collection mutation and iteration of course.
		//TODO investigate performance options; OrderedSet package doesn't dynamic sort
		_zOrderedEnts.forEach((e) => {if (e.enabled) e.updateGlobalTransform()}); // DNU globalEnabled
		_zOrderedEnts.sort((a, b) => b.globalZ.compareTo(a.globalZ)); // reverse sort

		// Update and render.
		//_zOrderedEnts.forEach((e) => {if (e.globalEnabled) e.update()});
		_zOrderedEnts.forEach((e) {
			if (e.globalEnabled) {
				// Prep the canvas for rendering.
				GameCanvas.main.save();
					// Camera transform.
					// Must scale before translate in order to translate in scale units.
					if (Camera.size != Size.zero) {
						GameCanvas.main.scale(Camera.scale.dx, Camera.scale.dy);
					}
					// Don't translate overlay (UI, HUD) objects.
					if (!e.isOverlay) {
						GameCanvas.main.translate(-Camera.rect.left, -Camera.rect.top);
					}

					// Entity transform.
					// Note: cannot combine entity with the camera else you might
					// translate the camera by entity scale and vice verse.
					GameCanvas.main.translate(e.globalPosition.x, e.globalPosition.y);
					GameCanvas.main.rotate(e.globalRotation);
					GameCanvas.main.scale(e.globalScale.x, e.globalScale.y);

					// Do it.
					e.update();

					// Render debug last to draw on top of entity renders.
					if (Game().debugMode) {
						_renderEntityDebug(e);
					}
				GameCanvas.main.restore();
			}
		});

		if (Game().debugMode) {
			_renderGameDebug();
		}
		GameCanvas.main.restore();

		//print("sgtn: ${Game()._zOrderedEnts.length} this: ${_zOrderedEnts.length} from $this");
		//print("sgtn late: ${Game()._lateEnts.length} from $this");
	}

	// Draw some basic system info for debug mode.
	void _renderGameDebug() {
		final String text = "fps: ${Game().fps(120).toStringAsFixed(1)}";
		final TextPainter tp = const TextConfig(color: const Color(0xFFFF00FF), fontSize: 15).getTextPainter(text);
		tp.paint(GameCanvas.main, Pivot.topRight.translateOffset(Offset(Screen.size.width, 20), tp.size));
	}

	final Paint _debugPaint = Paint()
		..color = const Color(0xFFFF00FF) // magenta... but always set before use
		..style = PaintingStyle.stroke
	;

	// Draw some basic entity visualizations for debug mode.
	void _renderEntityDebug(GameEntity e) {
		_debugPaint.color = e.debugColor;
		GameCanvas.main.drawCircle(Offset.zero, 5, _debugPaint);
		GameCanvas.main.drawCircle(Offset.zero, 100.0, _debugPaint);
		final String text = "x:${e.position.x.toStringAsFixed(1)} y:${e.position.y.toStringAsFixed(1)}";
		final TextPainter tp = TextConfig(color: e.debugColor, fontSize: 12).getTextPainter(text);
		tp.paint(GameCanvas.main, Pivot.topCenter  .translateOffset(const Offset(   0,   10), tp.size));
		//tp.paint(GameCanvas.main, Pivot.topLeft    .translateOffset(const Offset(-100, -100), tp.size));
		//tp.paint(GameCanvas.main, Pivot.bottomRight.translateOffset(const Offset( 100,  100), tp.size));
	}

	// Do the hard work of destroying the game entity.
	void _destroyMe(GameEntity e) {
		// First, remove from parent's children collection.
		if (e.parent != null) {
			// Not sure if try needed here, just being safe until better testing.
			try {
				//e.parent.children.remove(e);
				e.parent = null;
			} catch (_) {
				// Parent presumed destroyed.
			}
		}
		// Second, remove from game loop collections.
		if (e is TapDetector)            {_tapEnts.remove(e);}
		if (e is SecondaryTapDetector)   {_secondaryTapEnts.remove(e);}
		if (e is SingleTapDetector)      {_singleTapEnts.remove(e);}
		if (e is DoubleTapDetector)      {_doubleTapEnts.remove(e);}
		if (e is LongPressDetector)      {_longPressEnts.remove(e);}
		if (e is VerticalDragDetector)   {_verticalDragEnts.remove(e);}
		if (e is HorizontalDragDetector) {_horizontalDragEnts.remove(e);}
		if (e is PanDetector)            {_panEnts.remove(e);}
		if (e is ScaleDetector)          {_scaleEnts.remove(e);}
		_zOrderedEnts.remove(e); // The slow part of list vs set, I think.

		//TODO With auto garbage collection, not sure how else to destroy the object.
		//     Need to check if dart provides a way to find all ref vars so they can be set to null.
	}

	/// Render every globalEnabled entity in the set, making sure the canvas is reset for each one.
	/// It translates the camera unless the entity is marked as HUD.
	///
	/// Beware, however, if you are rendering entities outside of this,
	/// be careful to save() and restore() the canvas to avoid entities messing each other up.
	/*@override
	void render() {
		_zOrderedEnts.forEach((e) {
			if (e.globalEnabled) {
				GameCanvas.main.save();
          // Must scale before translate in order to translate in scale units.
          if (Camera.size != Size.zero) {
            GameCanvas.main.scale(Camera.scale.dx, Camera.scale.dy);
          }
					if (!e.isHud) {
						//GameCanvas.main.translate(-GameCanvas.cameraPosition.x, -GameCanvas.cameraPosition.y);
						GameCanvas.main.translate(-Camera.rect.left, -Camera.rect.top);
					}
					e.render();
				GameCanvas.main.restore();
			}
		});
	}*/

	/// This implementation of resize passes the resize call along to every entity in the list,
	/// enabling each one to make their decisions as how to handle the resize.
	//@mustCallSuper
	/*@override
	void resize() {
		//_zOrderedEnts.forEach((e) => e.resize()); // ??? globalEnabled or not?
	}*/
	//TODO !!! really need to figure this resize stuff out sometime !!! and find a static home for size
	//     It's REALLY looking a lot like this resize load will be axed.
	//     I really don't see the point given a proper camera with panning and scaling.
	//     Could set a callback in the a static class, or just let devs query screen sizes if they care.
	//     First, I need some use cases to test with as my current game doesn't need much on the camera front.


	// GESTURES ////////

	@override
	void onTapDown(TapDownDetails details) {
		_tapEnts.forEach((e) => {if (e.globalEnabled) (e as TapDetector).handleTapDown(details)});
	}
	@override
	void onTapUp(TapUpDetails details) {
		_tapEnts.forEach((e) => {if (e.globalEnabled) (e as TapDetector).handleTapUp(details)});
	}
	@override
	void onTapCancel() {
		_tapEnts.forEach((e) => {if (e.globalEnabled) (e as TapDetector).handleTapCancel()});
	}

	@override
	void onSecondaryTapDown(TapDownDetails details) {
		_secondaryTapEnts.forEach((e) => {if (e.globalEnabled) (e as SecondaryTapDetector).handleSecondaryTapDown(details)});
	}
	@override
	void onSecondaryTapUp(TapUpDetails details) {
		_secondaryTapEnts.forEach((e) => {if (e.globalEnabled) (e as SecondaryTapDetector).handleSecondaryTapUp(details)});
	}
	@override
	void onSecondaryTapCancel() {
		_secondaryTapEnts.forEach((e) => {if (e.globalEnabled) (e as SecondaryTapDetector).handleSecondaryTapCancel()});
	}

	@override
	void onSingleTap() {
		_singleTapEnts.forEach((e) => {if (e.globalEnabled) (e as SingleTapDetector).handleSingleTap()});
	}
	@override
	void onDoubleTap() {
		_doubleTapEnts.forEach((e) => {if (e.globalEnabled) (e as DoubleTapDetector).handleDoubleTap()});
	}

	@override
	void onLongPress() {
		_longPressEnts.forEach((e) => {if (e.globalEnabled) (e as LongPressDetector).handleLongPress()});
	}

	@override
	void onVerticalDragStart(DragStartDetails details) {
		_verticalDragEnts.forEach((e) => {if (e.globalEnabled) (e as VerticalDragDetector).handleVerticalDragStart(details)});
	}
	@override
	void onVerticalDragUpdate(DragUpdateDetails details) {
		_verticalDragEnts.forEach((e) => {if (e.globalEnabled) (e as VerticalDragDetector).handleVerticalDragUpdate(details)});
	}
	@override
	void onVerticalDragEnd(DragEndDetails details) {
		_verticalDragEnts.forEach((e) => {if (e.globalEnabled) (e as VerticalDragDetector).handleVerticalDragEnd(details)});
	}

	@override
	void onHorizontalDragStart(DragStartDetails details) {
		_horizontalDragEnts.forEach((e) => {if (e.globalEnabled) (e as HorizontalDragDetector).handleHorizontalDragStart(details)});
	}
	@override
	void onHorizontalDragUpdate(DragUpdateDetails details) {
		_horizontalDragEnts.forEach((e) => {if (e.globalEnabled) (e as HorizontalDragDetector).handleHorizontalDragUpdate(details)});
	}
	@override
	void onHorizontalDragEnd(DragEndDetails details) {
		_horizontalDragEnts.forEach((e) => {if (e.globalEnabled) (e as HorizontalDragDetector).handleHorizontalDragEnd(details)});
	}

	@override
	void onPanStart(DragStartDetails details) {
		_panEnts.forEach((e) => {if (e.globalEnabled) (e as PanDetector).handlePanStart(details)});
	}
	@override
	void onPanUpdate(DragUpdateDetails details) {
		_panEnts.forEach((e) => {if (e.globalEnabled) (e as PanDetector).handlePanUpdate(details)});
	}
	@override
	void onPanEnd(DragEndDetails details) {
		_panEnts.forEach((e) => {if (e.globalEnabled) (e as PanDetector).handlePanEnd(details)});
	}

	@override
	void onScaleStart(ScaleStartDetails details) {
		_scaleEnts.forEach((e) => {if (e.globalEnabled) (e as ScaleDetector).handleScaleStart(details)});
	}
	@override
	void onScaleUpdate(ScaleUpdateDetails details) {
		_scaleEnts.forEach((e) => {if (e.globalEnabled) (e as ScaleDetector).handleScaleUpdate(details)});
	}
	@override
	void onScaleEnd(ScaleEndDetails details) {
		_scaleEnts.forEach((e) => {if (e.globalEnabled) (e as ScaleDetector).handleScaleEnd(details)});
	}


	// DEBUG MODE ////////

	/// In debug mode, the [debugUpdate] method gets called in addition to [update].
	/// Here, in [Game], [Time.deltaTime]s are recorded to allow finding the FPS with the [fps] method.
	/// You can also use the [debugMode] field to enable other debug behaviors in
	/// your components and entities, like bounding box rendering, for instance.
	@override
	void debugUpdate() {
		_deltas.add(Time.deltaTime);
	}

	/// Returns the average FPS for the last [frameSpan] measures.
	///
	/// The values are only saved if in debug mode (override [debugMode] to use this).
	/// Selects the last [frameSpan] dts, averages then, and returns the inverse value.
	/// So it's technically updates per second, but the relation between updates and renders is 1:1.
	/// Returns 0 if empty.
	double fps([int frameSpan = 1]) {
		final List<double> dts = _deltas.sublist(math.max(0, _deltas.length - frameSpan));
		if (dts.isEmpty) {
			return 0.0;
		}
		final double dtSum = dts.reduce((s, t) => s + t);
		final double averageDt = dtSum / frameSpan;
		return 1 / averageDt;
	}

}
