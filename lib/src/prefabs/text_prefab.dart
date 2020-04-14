import 'package:pogo/src/components/text_component.dart';
import 'package:pogo/src/entities/game_entity.dart';

export 'package:pogo/src/components/text_component.dart';
export 'package:pogo/src/entities/game_entity.dart';

/// A [GameEntity] containing a [TextComponent].
/// This gives components position, Z order, rotation, and scale.
///
/// This creates a prefabricated entity intended for single-use entities.
class TextPrefab extends GameEntity {
	TextComponent textComponent;

	TextPrefab(
			this.textComponent,
			{
				Vector2 position,
				int     zOrder = 0,
				double  rotation,
				double  rotationDeg,
				Vector2 scale,
				bool    enabled = true,
				GameEntity parent,
			}
	) : super(
		position:    position,
		zOrder:      zOrder,
		rotation:    rotation,
		rotationDeg: rotationDeg,
		scale:       scale,
		enabled:     enabled,
		parent:      parent,
	);

	@override
	void update() {
		textComponent.render();
	}

	/*@override
	void render() {
		super.render();
		textComponent.render();
	}*/

}
