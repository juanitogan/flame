import 'dart:ui';

import 'package:flutter_svg/flutter_svg.dart';

/// Wrapper class for all image types [SpriteComponent] can render.
/// Currently: [Image] and [Svg].
abstract class SpriteImage {
	Object get source;
	double get width;
	double get height;

	bool loaded() {return false;}

	void draw(Canvas c, Rect frameRect, Rect drawRect, Paint paint) {}
}

/// Wrapper class for raster image types supported by [Image].
class Raster implements SpriteImage {
	final Image _source;

	@override
	Image get source => _source;

	@override
	double get width => _source.width.toDouble();
	@override
	double get height => _source.height.toDouble();

	//TODO work out these hidden interfaces
	int get intWidth => _source.width;
	int get intHeight => _source.height;

	Raster(this._source);

	@override
	bool loaded() {
		return _source != null;
	}

	@override
	void draw(Canvas c, Rect frameRect, Rect drawRect, Paint paint) {
		if (loaded()) {
			c.drawImageRect(_source, frameRect, drawRect, paint);
		}
	}
}

/// Wrapper class for SVG images.
/// [scale] can be provided to adapt the SVG's units to the app's units.
class Svg implements SpriteImage {
	final DrawableRoot _source;
	double scale = 1.0; // No X/Y scale because that is the job of the entity's transform.

	//TOmaybeDO create some unit constants to help setting scale: scaleBy.pointPerPixel = 72 / 96 = 0.75
	//TOmaybeDO create some unit constants to help setting scale: scaleBy.tenthInchPerPixel = 10 / 96 = 0.10416666
	//TOmaybeDO create some unit constants to help setting scale: scaleBy.sixteenthInchPerPixel = 16 / 96 = 0.16666
	//TOmaybeDO create some unit constants to help setting scale: scaleBy.mmPerPixel = 25.4 / 96 = 0.264583333

	//TODO what is: https://api.dart.dev/stable/2.7.1/dart-svg/dart-svg-library.html vs flutter_svg?

	@override
	DrawableRoot get source => _source;

	//TODO viewport.size currently set to infinity -- figure out if should set or what?
	@override
	double get width => _source.viewport.viewBox.width * scale; // or _source.viewport.viewBox.width; ??? yes
	@override
	double get height => _source.viewport.viewBox.height * scale;

	double get unscaledWidth => _source.viewport.viewBox.width;
	double get unscaledHeight => _source.viewport.viewBox.height;

	//Svg(this._source, {this.scale = 1.0}) : assert (scale != null);
	Svg(this._source, {this.scale}) {scale ??= 1.0;}

	//TODO for frameRect testing only:
	//     quick test: SpriteComponent.fromSvg(Svg.withRect(Assets.svgCache.get('android.svg').source, Rect.fromLTWH(20, 20, 50, 50), scale: 1)),
	//     This works but is it worth working into the framework?
	//     It probably takes more memory than just pointing to the cache, as this copies from it.
	//     It would require doing this to all SVGs in Sprites, whether needed or not.
	//DrawableRoot _source;
	/*Svg.withRect(DrawableRoot source, Rect frameRect, {this.scale = 1.0}) : assert (scale != null) {
		_source = DrawableRoot(
			//DrawableViewport(source.viewport.size, frameRect.size, viewBoxOffset: frameRect.topLeft),
			//DrawableViewport(frameRect.size, frameRect.size, viewBoxOffset: frameRect.topLeft),
			//DrawableViewport(frameRect.size, frameRect.size, viewBoxOffset: -frameRect.topLeft),
			DrawableViewport(source.viewport.size, frameRect.size, viewBoxOffset: -frameRect.topLeft), //WHY DO I HAVE TO NEGATE OFFSET??!
			source.children,
			source.definitions,
			source.style,
			transform: source.transform
		);
	}*/

	@override
	bool loaded() {
		return _source != null;
	}

	@override
	void draw(Canvas c, Rect frameRect, Rect drawRect, Paint paint) {
		//TODO frameRect on an SVG could be meaningful (in theory) by applying it to the viewBox... but why???
		//     But, both viewport and viewport.viewBox are final, meaning the
		//     DrawableRoot would need reconstruction with the new viewBox.
		if (loaded()) {
			//Graphics.canvas.save();
				//Graphics.canvas.scale(scale);
				_source.scaleCanvasToViewBox(c, Size(width, height));
				//_source.clipCanvasToViewBox(c); // Only needed if wanting to obey the viewBox. Yes, I suspect, but at what CPU cost?
				_source.draw(c, null);
			//Graphics.canvas.restore();
		}
	}
}
