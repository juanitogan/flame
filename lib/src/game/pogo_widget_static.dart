import 'package:flutter/widgets.dart';
import 'package:pogo/pseudo_game.dart';
import 'package:pogo/src/prefabs/animation_prefab.dart';

/// Static class for Pogo's Flutter widgets.
class PogoWidget {

	/// Returns a regular Flutter widget containing the given [GameEntity]
	/// that reserves UI space according to the given `reservedSize`
	/// (which the game entity is NOT restricted to).
	///
	/// This creates an [EmbeddedGameWidget] with a [PseudoGame] whose only content is a [GameEntity].
	/// You can use this implementation as base to create your own widgets based on more complex game entities.
	/// This is intended to be used by non-game apps that want to add sprite animations and such.
	static Widget fromEntity(GameEntity entity, Size reservedSize) {
		//TODO This executes twice at startup and again with each hide/show.
		//     This leads to an ever-growing list of ents in Game() singleton.
		return EmbeddedGameWidget(
				PseudoGame(entity),
				//Game(), // If using this, need to find way to flush the ent lists when widget hides.
				size: reservedSize
		);
	}

	/// Returns a regular Flutter widget containing the given [AnimationComponent]
	/// rendered at the given `size`.
	///
	/// This is a helper method for creating a [GameEntity] from the given [AnimationComponent] and size.
	/// This scales the animation for you (based on frame 0) and then calls `entityAsWidget()`.
	///
	/// This creates an [EmbeddedGameWidget] with a [PseudoGame] whose only content is a [GameEntity].
	/// This is intended to be used by non-game apps that want to add a spritesheet animation.
	static Widget fromAnimation(AnimationComponent animation, Size size) {
		return fromEntity(
				AnimationPrefab(
					animation,
					scale: Vector2(
							size.width / animation.frames[0].sprite.frameWidth,
							size.height / animation.frames[0].sprite.frameHeight
					),
				),
				size
		);
	}

	/// Returns a regular Flutter widget containing the given [SpriteComponent]
	/// rendered at the given `size`.
	///
	/// This is a thin wrapper that skips creating a [GameEntity] for when just an image is needed.
	///
	/// This will create a [CustomPaint] widget using a [CustomPainter] for rendering the [SpriteComponent].
	/// Be aware that the Sprite must have been loaded, otherwise it can't be rendered.
	static CustomPaint fromSprite(SpriteComponent sprite, Size size) =>
			CustomPaint(size: size, painter: _SpriteCustomPainter(sprite));

}


class _SpriteCustomPainter extends CustomPainter {
	final SpriteComponent _sprite;

	_SpriteCustomPainter(this._sprite);

	@override
	void paint(Canvas canvas, Size size) { //TODO does this really need its own Canvas?
		if (_sprite.loaded()) {
			canvas.save();
			canvas.scale(size.width / _sprite.frameWidth, size.height / _sprite.frameHeight);
			_sprite.renderCanvas(canvas);
			canvas.restore();
			/*
      // Note: using the main game canvas works too:
      Graphics.canvas.save();
        Graphics.canvas.scale(size.width / _sprite.frameWidth, size.height / _sprite.frameHeight);
        _sprite.render();
      Graphics.canvas.restore();
      */
		}
	}

	@override
	bool shouldRepaint(CustomPainter old) => false;
}