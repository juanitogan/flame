import 'dart:ui';

import 'package:pogo/src/game/screen_static.dart';

/// Static class for camera data.
///
class Camera {

	/// The main [Rect] that sets the main camera position and size/scale.
	///
	/// Use [offset] to pan around a map, for example.  Scales according to size/scale.
	///
	/// Leave [size] at zero for default behavior of camera equaling the whole
	/// screen/window at native resolution.
	/// Set to a low value for low-res game support with low-res coordinates and art.
	///
	/// The values here are also used to correct gesture coordinates.
	static Rect rect = Rect.zero;

	// A bunch of helper fields:
	//TODO what to do about these if get/setting while Screen.size is null? let the error fly?

	static Offset get offset           => rect.topLeft;
	static        set offset(Offset o) => rect = Rect.fromLTWH(o.dx, o.dy, rect.width, rect.height);

	static Size   get size             => rect.size;
	static        set size(Size s)     => rect = Rect.fromLTWH(rect.left, rect.top, s.width, s.height);

	static Offset get scale        => rect.size == Size.zero
																		? const Offset(1, 1)
																		: Offset(Screen.size.width / rect.width, Screen.size.height / rect.height);
	static set scale(Offset scale) => rect = Rect.fromLTWH(rect.left, rect.top, Screen.size.width / scale.dx, Screen.size.height / scale.dx);

	static double get left      => rect.left;
	static double get top       => rect.top;
	static double get width     => rect.width; // Like Image width and height (and not Box size).
	static double get height    => rect.height;
	static set left(double d)   => rect = Rect.fromLTWH(d        , rect.top, rect.width, rect.height);
	static set top(double d)    => rect = Rect.fromLTWH(rect.left, d       , rect.width, rect.height);
	static set width(double d)  => rect = Rect.fromLTWH(rect.left, rect.top, d         , rect.height);
	static set height(double d) => rect = Rect.fromLTWH(rect.left, rect.top, rect.width, d          );


	// Scaled fields:
	/* not needed - all fields are scaled now - doubt we'll need unscaled/real fields
	static Offset get scaledOffset  	=> rect.topLeft.scale(
																					rect.width / Screen.size.width,
																					rect.height / Screen.size.height);
	static set scaledOffset(Offset o) => rect = Rect.fromLTWH(
																					o.dx * Screen.size.width / rect.width,
																					o.dy * Screen.size.height / rect.height,
																					rect.width, rect.height);

	static double get scaledLeft      => rect.left * rect.width / Screen.size.width;
	static double get scaledTop       => rect.top * rect.height / Screen.size.height;
	static set scaledLeft(double d)   => rect = Rect.fromLTWH(d * Screen.size.width / rect.width, rect.top   , rect.width, rect.height);
	static set scaledTop(double d)    => rect = Rect.fromLTWH(rect.left, d * Screen.size.height / rect.height, rect.width, rect.height);

	//TOnotDO what about scaledRect? no. for now
	*/

	/// Camera position; every non-HUD entity is translated so that the camera position is the top-left corner of the screen.
	//static Vector2 cameraPosition = Vector2.zero();

	/// Global canvas X & Y scaling.
	/// Intended to allow low-res games to use low-res coordinates.
	///
	/// The values here are also used to correct gesture coordinates.
	///
	//Vector2 scale = Vector2(1.0, 1.0);
	// Would like to add setter/getter for scale to also add getter for scaleInverted,
	// but probably can't do so with mutable Vector2; need immutable Offset maybe.
	// This, so we don't have to invert on the fly with gestures.
	// Like this:
	/*
	static Offset _scale         = const Offset(1.0, 1.0);
	static Offset _scaleInverted = const Offset(1.0, 1.0);
	static Offset get scale => _scale;
	static set scale(Offset scale) {
		_scale = scale;
		_scaleInverted = Offset(1.0 / scale.dx, 1.0 / scale.dy); //TODOlater maybe I should rely on caching more and not do it this way
	}
	static Offset get scaleInverted => _scaleInverted;
	*/

}