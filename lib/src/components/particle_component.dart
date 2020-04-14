import 'dart:math';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

import 'package:pogo/src/entities/game_entity.dart';
import 'package:pogo/src/prefabs/particle_prefab.dart';
import 'package:pogo/src/particles/accelerated_particle.dart';
import 'package:pogo/src/particles/composite_particle.dart';
import 'package:pogo/src/particles/moving_particle.dart';
import 'package:pogo/src/particles/rotating_particle.dart';
import 'package:pogo/src/particles/scaled_particle.dart';
import 'package:pogo/src/particles/translated_particle.dart';
import 'package:pogo/src/components/timer_component.dart';

/// A function which returns [ParticleComponent] when called
typedef ParticleGenerator = ParticleComponent Function(int);

/// Base class implementing common behavior for all the particles.
///
/// Intention is to follow same "Extreme Composability" style
/// as across the whole Flutter framework, so each type of particle implements
/// some particular behavior which then could be nested and combined together
/// to create specifically required experience.
abstract class ParticleComponent {
  /// Generates given amount of particles,
  /// combining them into one [CompositeParticle]
  /// Useful for procedural particle generation.
  static ParticleComponent generate({
    int count = 10,
    @required ParticleGenerator generator,
    double lifespan,
  }) {
    return CompositeParticle(
      lifespan: lifespan,
      children: List<ParticleComponent>.generate(count, generator),
    );
  }

  /// Internal timer defining how long
  /// this [ParticleComponent] will live. [ParticleComponent] will
  /// be marked for destroy when this timer is over.
  TimerComponent _timer;

  /// Stores desired lifespan of the
  /// particle in seconds.
  double _lifespan;

  /// Will be set to true by update hook
  /// when this [ParticleComponent] reaches end of its lifespan
  bool _shouldBeDestroyed = false;

  ParticleComponent({
    /// Particle lifespan in [TimerComponent] format,
    /// double in seconds with microsecond precision
    double lifespan,
  }) {
    setLifespan(lifespan ?? .5);
  }

  /// This method will return true as
  /// soon as particle reaches an end of its
  /// lifespan, which means it's ready to be
  /// destroyed by a wrapping container.
  /// Follows same style as [GameEntity].
  bool destroy() => _shouldBeDestroyed; //TODO why not just use a getter?

  /// Getter which should be used by subclasses
  /// to get overall progress. Also allows to substitute
  /// progress with other values, for example adding easing as in [CurvedParticle].
  double get progress => _timer.progress;

  /// Should render this [ParticleComponent] to given [Canvas].
  /// Default behavior is empty, so that it's not
  /// required to override this in [ParticleComponent] which
  /// render nothing and serve as behavior containers.
  void render() {
    // Do nothing by default
  }

  /// Updates internal [TimerComponent] of this [ParticleComponent]
  /// which defines its position on the lifespan.
  /// Marks [ParticleComponent] for destroy when it is over.
  void update() {
    _timer.update();

    if (_timer.progress >= 1) {
      _shouldBeDestroyed = true;
    }
  }

  /// A control method allowing a parent of this [ParticleComponent]
  /// to pass down it's lifespan. Allows to only specify desired lifespan
  /// once, at the very top of the [ParticleComponent] tree which
  /// then will be propagated down using this method.
  /// See [SingleChildParticle] or [CompositeParticle] for details.
  void setLifespan(double lifespan) {
    _lifespan = lifespan;
    _timer?.stop();
    _timer = TimerComponent(lifespan);
    _timer.start();
  }

  /// Wtaps this particle with [TranslatedParticle]
  /// statically repositioning it for the time
  /// of the lifespan.
  ParticleComponent translated(Offset offset) {
    return TranslatedParticle(
      offset: offset,
      child: this,
      lifespan: _lifespan,
    );
  }

  /// Wraps this particle with [MovingParticle]
  /// allowing it to move from one [Offset]
  /// on the canvas to another one.
  ParticleComponent moving({
    Offset from = Offset.zero,
    @required Offset to,
    Curve curve = Curves.linear,
  }) {
    return MovingParticle(
      from: from,
      to: to,
      curve: curve,
      child: this,
      lifespan: _lifespan,
    );
  }

  /// Wraps this particle with [AcceleratedParticle]
  /// allowing to specify desired position speed and acceleration
  /// and leave the basic physics do the rest.
  ParticleComponent accelerated({
    Offset acceleration = Offset.zero,
    Offset position = Offset.zero,
    Offset speed = Offset.zero,
  }) {
    return AcceleratedParticle(
      position: position,
      speed: speed,
      acceleration: acceleration,
      child: this,
      lifespan: _lifespan,
    );
  }

  /// Rotates this particle to a fixed angle
  /// in radians with [RotatingParticle]
  ParticleComponent rotated([double angle = 0]) {
    return RotatingParticle(
        child: this, lifespan: _lifespan, from: angle, to: angle);
  }

  /// Rotates this particle from given angle
  /// to another one in radians with [RotatingParticle]
  ParticleComponent rotating({
    double from = 0,
    double to = pi,
  }) {
    return RotatingParticle(
      child: this,
      lifespan: _lifespan,
      from: from,
      to: to,
    );
  }

  /// Wraps this particle with [ScaledParticle]
  /// allowing to change size of it and/or its children
  ParticleComponent scaled(double scale) {
    return ScaledParticle(scale: scale, child: this, lifespan: _lifespan);
  }

  /// Wraps this particle with [ParticlePrefab]
  /// to be used within the [Game] component system.
  GameEntity asComponent() {
    return ParticlePrefab(this);
  }
}
