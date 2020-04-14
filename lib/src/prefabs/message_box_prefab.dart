import 'package:pogo/src/components/message_box_component.dart';
import 'package:pogo/src/entities/game_entity.dart';

export 'package:pogo/src/components/message_box_component.dart';
export 'package:pogo/src/entities/game_entity.dart';

/// A [GameEntity] containing a [MessageBoxComponent].
/// This gives components position, Z order, rotation, and scale.
///
/// This creates a prefabricated entity intended for single-use entities.
class MessageBoxPrefab extends GameEntity {
	MessageBoxComponent messageBoxComponent;
	bool destroyOnFinish;

	MessageBoxPrefab(
			this.messageBoxComponent,
			{
				Vector2 position,
				int     zOrder = 0,
				double  rotation,
				double  rotationDeg,
				Vector2 scale,
				bool    enabled = true,
				GameEntity parent,
				this.destroyOnFinish = false,
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
		messageBoxComponent.update();
		if (destroyOnFinish && messageBoxComponent.isFinished) {
			destroy();
		}
		messageBoxComponent.render();
	}

	/*@override
	void render() {
		super.render();
		messageBoxComponent.render();
	}*/

}
