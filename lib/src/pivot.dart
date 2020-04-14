import 'dart:ui';

import 'package:pogo/src/vector_math.dart';

class Pivot {
  static const Pivot topLeft = Pivot(Offset(0.0, 0.0));
  static const Pivot topCenter = Pivot(Offset(0.5, 0.0));
  static const Pivot topRight = Pivot(Offset(1.0, 0.0));
  static const Pivot centerLeft = Pivot(Offset(0.0, 0.5));
  static const Pivot center = Pivot(Offset(0.5, 0.5));
  static const Pivot centerRight = Pivot(Offset(1.0, 0.5));
  static const Pivot bottomLeft = Pivot(Offset(0.0, 1.0));
  static const Pivot bottomCenter = Pivot(Offset(0.5, 1.0));
  static const Pivot bottomRight = Pivot(Offset(1.0, 1.0));

  final Offset offsetFactor;

  const Pivot(this.offsetFactor);

  // Flutter has so many immutable types they seem more trouble than they are worth at times.

  Offset translate(Size size) {
    return Offset(-size.width * offsetFactor.dx, -size.height * offsetFactor.dy);
  }

  Offset translateOffset(Offset position, Size size) {
    return position - Offset(size.width * offsetFactor.dx, size.height * offsetFactor.dy);
  }

  Rect translateRect(Rect rect) {
    return rect.translate(-rect.width * offsetFactor.dx, -rect.height * offsetFactor.dy);
  }

  Vector2 translateVector2(Vector2 position, double width, double height) {
    return position - Vector2(width * offsetFactor.dx, height * offsetFactor.dy);
  }

}
