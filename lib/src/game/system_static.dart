import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/widgets.dart';
import 'package:pogo/src/pivot.dart';

export 'package:pogo/src/pivot.dart';
//handled by game_core.dart//export 'dart:ui' show Paint;


/// Static class for system setup and such.
class System {

  //TODO not sure of the best home for this
  /// Sets the default [Pivot] point for newly-created [components] (including [GestureArea]).
  static Pivot defaultPivot = Pivot.center;

  /// Sets the default [Paint] properties for newly-created [components].
  /// Default color is white with all other properties left at their Flutter defaults.
  ///
  /// A common use of this is that low-res games will likely want to set
  /// `.isAntiAlias = false` (the default is true) to turn AA off for the edges of images.
  static Paint defaultPaint = Paint()..color = const Color(0xFFFFFFFF);


  /// TODONE Verify if this is still needed (I don't think so).
  /// Yes, it is, depending on order you want to call runApp() in main().
  /// See end of Step 3 here:
  ///   https://jap.alekhin.io/create-mobile-game-flutter-flame-beginner-tutorial
  /*static void initializeGameWidget () {
    WidgetsFlutterBinding.ensureInitialized();
  }*/
  //TODONE but why wrap one function with another? it doesn't help with understanding other messages and online help

}


/// This class never needs to be used.
///
/// It only exists here in order for [BindingBase] to setup Flutter services.
/// TODO: this could possibly be private, verify if it'd work.
//TODO MJJ looks like a sort of singleton
class PogoBinding extends BindingBase with GestureBinding, ServicesBinding {
  static PogoBinding instance;

  static PogoBinding ensureInitialized() {
    if (PogoBinding.instance == null) {
      PogoBinding();
    }
    return PogoBinding.instance;
  }
}
