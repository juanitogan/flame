import 'package:pogo/src/components/sprite_image.dart';
import 'package:pogo/src/game/assets_static.dart';
import 'package:pogo/src/game/game_main.dart';
import 'package:pogo/src/palette.dart';

export 'package:pogo/src/components/sprite_image.dart';
export 'package:pogo/src/pivot.dart';

class SpriteComponent {
  //Image image;
  SpriteImage _image;
  SpriteImage get image => _image;
  Rect  _frameRect;
  Rect  _drawRect; // Annoyingly needed for drawImageRect.
	Pivot pivot;
	Paint paint = BasicPalette.white.paint;

  Rect get frameRect => _frameRect;
  //set frameRect(Rect r) {
  //  _frameRect = r;
  //  _drawRect = Rect.fromLTWH(0.0, 0.0, r.width, r.height);
  //}

	// Not likely needed (esp the setters) but, well, here it is.
  // Not sure why I made all these setters as I can't think of a good use case for them.
  // Probably mode them out of habit of just being thorough.  Oops.
  // Perhaps was thinking about lazy constructors and post-use.
  // Removing them so no one uses them as a surprising way to do animation.
  double get frameLeft   => frameRect.left;
	double get frameTop    => frameRect.top;
	double get frameWidth  => frameRect.width; // Like Image width and height (and not Box size).
	double get frameHeight => frameRect.height;
	//set frameLeft(double d)   => frameRect = Rect.fromLTWH(d             , frameRect.top, frameRect.width, frameRect.height);
	//set frameTop(double d)    => frameRect = Rect.fromLTWH(frameRect.left, d            , frameRect.width, frameRect.height);
	//set frameWidth(double d)  => frameRect = Rect.fromLTWH(frameRect.left, frameRect.top, d              , frameRect.height);
	//set frameHeight(double d) => frameRect = Rect.fromLTWH(frameRect.left, frameRect.top, frameRect.width, d               );
	Offset get frameOffset           => frameRect.topLeft;
	//     set frameOffset(Offset o) => frameRect = Rect.fromLTWH(o.dx, o.dy, frameRect.width, frameRect.height);
	Size   get frameSize             => frameRect.size;
	//     set frameSize(Size s)     => frameRect = Rect.fromLTWH(frameRect.left, frameRect.top, s.width, s.height);


	//TODO frame* values on an SVG could be meaningful (in theory) by applying them to the viewBox... but why???
	SpriteComponent(
			this._image,
			{
				double frameLeft = 0,
				double frameTop = 0,
				double frameWidth,
				double frameHeight,
				this.pivot,
			}
	) {
		frameWidth ??= image.width;
		frameHeight ??= image.height;
		_frameRect = Rect.fromLTWH(frameLeft, frameTop, frameWidth, frameHeight);
    _drawRect = Rect.fromLTWH(0.0, 0.0, frameWidth, frameHeight);
		pivot ??= System.defaultPivot;
	}

	SpriteComponent.empty();

  SpriteComponent.fromRaster(
			Raster raster,
			{
				int frameLeft = 0, //TODO add assert()s to keep ints >= 0
				int frameTop = 0,
				int frameWidth,
				int frameHeight,
				Pivot pivot,
			}
  ) : this(
    raster,
    frameLeft:   frameLeft.toDouble(),
    frameTop:    frameTop.toDouble(),
    frameWidth:  frameWidth?.toDouble(),
    frameHeight: frameHeight?.toDouble(),
    pivot:       pivot,
  );

  SpriteComponent.fromRasterCache(
			String filename,
			{
				int frameLeft = 0,
				int frameTop = 0,
				int frameWidth,
				int frameHeight,
				Pivot pivot,// = Pivot.center,
			}
  ) : this(
    Assets.rasterCache.get(filename),
    frameLeft:   frameLeft.toDouble(),
    frameTop:    frameTop.toDouble(),
    frameWidth:  frameWidth?.toDouble(),
    frameHeight: frameHeight?.toDouble(),
    pivot:       pivot,
  );

  static Future<SpriteComponent> fromRasterFile(
			String filename,
			{
				int frameLeft = 0,
				int frameTop = 0,
				int frameWidth,
				int frameHeight,
				Pivot pivot,
			}
  ) async {
    final Raster raster = await Assets.rasterCache.load(filename);
    return SpriteComponent(
      raster,
      frameLeft:   frameLeft.toDouble(),
      frameTop:    frameTop.toDouble(),
      frameWidth:  frameWidth?.toDouble(),
      frameHeight: frameHeight?.toDouble(),
      pivot:       pivot,
    );
  }


	SpriteComponent.fromSvg(
			Svg svg,
			{
				Pivot pivot,
			}
	) : this(
		svg,
		pivot:       pivot,
	);

	SpriteComponent.fromSvgCache(
			String filename,
			{
				Pivot pivot,
			}
	) : this(
		Assets.svgCache.get(filename),
		pivot:       pivot,
	);

	static Future<SpriteComponent> fromSvgFile(
			String filename,
			{
				double scale,
				Pivot pivot,
			}
	) async {
		final Svg svg = await Assets.svgCache.load(filename, scale: scale);
		return SpriteComponent(
			svg,
			pivot:       pivot,
		);
	}


  bool loaded() {
    //return image != null && frameRect != null;
		return image.loaded();
  }


  /// Renders this sprite with its pivot at local position zero.
  /// Renders actual size according to instance frame width and height.
  /// Has an optional [paint] parameter for rendering with a different palette.
  ///
  /// All scaling and positioning render methods were whacked from this class.
  /// If needing such things, you're not using [BasicGameEntity] correctly,
  /// or you should manipulate the canvas yourself to do such things.
  void render({Paint paint}) {
    //final double dx = -pivot.offsetFactor.dx * frameRect.width;
    //final double dy = -pivot.offsetFactor.dy * frameRect.height;
		final Offset o = pivot.translate(frameRect.size); //TODO could avoid live pivoting by encapsulating and keeping _offset
    GameCanvas.main.save();
      GameCanvas.main.translate(o.dx, o.dy);
      //Graphics.canvas.drawImageRect(image, frameRect, _drawRect, paint ?? this.paint);
			image.draw(GameCanvas.main, frameRect, _drawRect, paint ?? this.paint);
			//
			if (Game().debugMode) {
				_renderDebugMode();
			}
    GameCanvas.main.restore();
  }

  //TODO possibly needed...
	//     Used by spriteAsWidget which wants to send its own canvas but dunno if needed really.
	//     Current testing shows, no, this is not needed -- the main canvas works fine --
	//     but I can't say I know all use cases that need to be tested.
	//     Thus, leaving for now.
	void renderCanvas(Canvas c, {Paint paint}) {
		final Offset o = pivot.translate(frameRect.size);
		c.save();
			c.translate(o.dx, o.dy);
			image.draw(c, frameRect, _drawRect, paint ?? this.paint);
		c.restore();
	}


	// DEBUG MODE ////////

	Color debugColor = const Color(0xFFFF00FF);

	Paint get _debugPaint => Paint()
		..color = debugColor
		..style = PaintingStyle.stroke
	;

	void _renderDebugMode() {
		GameCanvas.main.drawRect(frameRect, _debugPaint);
	}

}
