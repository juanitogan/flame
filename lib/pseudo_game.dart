import 'package:pogo/src/entities/game_entity.dart';
import 'package:pogo/src/game/game_main.dart';

export 'package:pogo/src/entities/game_entity.dart';
export 'package:pogo/src/game/game_main.dart';

/// This is a helper implementation of a [Game] designed to allow to easily create a game with a single component.
///
/// This is useful to add sprites, animations and other Flame components "directly"
/// to your non-game Flutter widget tree, when combined with [EmbeddedGameWidget].
class PseudoGame extends Game {
  PseudoGame(GameEntity e) : super.empty() {
    lateAdd(e);
    //TODO This lateAdd() is needed, but why?
    //     The GE constructor's Basic().lateAdd() executes and instantiates
    //        the Game() singleton, not knowing about this Game instance.
    //     How to fix I wonder?  How to turn off the GE lateAdd at least?
    //     Or... make this tap into the singleton as well, instead of subclassing.
    //     But, then, how to properly destroy..?
    //     Which, it doesn't: the _lateEnts lists just grow with each call/show/hide
    //        to the pseudo entity.
    //     Yup, debug prints show the inefficiencies.
    //Game().destroyEntity(e); // doesn't matter because Game() isn't "running" to process lateEnts.
    // But Game()._late*Ents will continue to build unless I add "run" detection code to block it.
    // Or, add code to scrub it from here.  Ugh.
    // Considered a flag on Game but no way to set it automatically before first
    //    pseudo entity created.
    // Ultimately, added hacky code to lateAdd to scrub Basic()._lateEnts lists
    //    when Game != Game() singleton.
  }
}
