import 'dart:math';

import 'package:pogo/game_engine.dart';
import 'package:pogo_rive/plugin.dart';

import 'package:flutter/material.dart' hide Animation, Image;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Assets.rasterCache.loadAll([
    'zap.png',
    'boom3.png', //Credit to Stumpy Strust https://opengameart.org/content/explosion-sheet
  ]);

  // Preload the Rive (Flare) animation.
  final riveAnimation = await RiveComponent.fromFile('assets/diamond.flr', 'Spin', scale: 0.1);

  Game().debugMode = true;
  runApp(Game().widget);

  final Size screenSize = await Screen.waitForStartupSizing();

  MainEntity(screenSize: screenSize, riveAnimation: riveAnimation);
}


class MainEntity extends GameEntity {
  Size screenSize;

  /// Defines dimensions of the sample
  /// grid to be displayed on the screen,
  /// 5x5 in this particular case
  static const gridSize = 5;
  static const steps = 5;

  /// Miscellaneous values used
  /// by examples below
  final Random rnd = Random();
  final StepTween steppedTween = StepTween(begin: 0, end: 5);
  final trafficLight = TrafficLightComponent();

  final TextConfig fpsTextConfig = const TextConfig(color: const Color(0xFFFFFFFF));
  TextPrefab fpsText;

  /// Defines the lifespan of all the particles in these examples
  final sceneDuration = const Duration(seconds: 1);

  Offset cellSize;  //TODO switch to Vector2 maybe
  Offset halfCellSize;
  RiveComponent riveAnimation;

  MainEntity({
    this.screenSize,
    this.riveAnimation,
  }) {
    cellSize = Offset(screenSize.width / gridSize, screenSize.height / gridSize);
    halfCellSize = cellSize * .5;

    // Spawn new particles every second
    Timer.periodic(sceneDuration, (_) => spawnParticles());

    // FPS display.
    fpsText = TextPrefab(
      TextComponent("", textConfig: fpsTextConfig, pivot: Pivot.topLeft),
      position: Vector2(0, screenSize.height - 24),
      enabled: false,
    );
  }

  /// Showcases various different uses of [ParticleComponent]
  /// and its derivatives
  void spawnParticles() {
    // Contains sample particles, in order by complexity
    // and amount of used features. Jump to source for more explanation on each
    final particles = <ParticleComponent>[
      circle(),
      smallWhiteCircle(),
      movingParticle(),
      randomMovingParticle(),
      alignedMovingParticles(),
      easedMovingParticle(),
      intervalMovingParticle(),
      computedParticle(),
      chainingBehaviors(),
      steppedComputedParticle(),
      reuseParticles(),
      imageParticle(),
      reuseImageParticle(),
      rotatingImage(),
      acceleratedParticles(),
      paintParticle(),
      spriteParticle(),
      animationParticle(),
      fireworkParticle(),
      componentParticle(),
      riveParticle(),
    ];

    // Place all the [Particle] instances
    // defined above in a grid on the screen
    // as per defined grid parameters
    do {
      final particle = particles.removeLast();
      final col = particles.length % gridSize;
      final row = particles.length ~/ gridSize;
      final cellCenter =
          cellSize.scale(col.toDouble(), row.toDouble()) + (cellSize * .5);

      ParticlePrefab(
        // Bind all the particles to a [Component] update
        // lifecycle from the [BasicGame].
        TranslatedParticle(
          lifespan: 1,
          offset: cellCenter,
          child: particle,
        ),
      );
    } while (particles.isNotEmpty);
  }

  /// Simple static circle, doesn't move or
  /// change any of its attributes
  ParticleComponent circle() {
    return CircleParticle(
      paint: Paint()..color = Colors.white10,
    );
  }

  /// This one will is a bit smaller,
  /// and a bit less transparent
  ParticleComponent smallWhiteCircle() {
    return CircleParticle(
      radius: 5.0,
      paint: Paint()..color = Colors.white,
    );
  }

  /// Particle which is moving from
  /// one predefined position to another one
  ParticleComponent movingParticle() {
    return MovingParticle(
      // This parameter is optional, will
      // default to [Offset.zero]
      from: const Offset(-20, -20),
      to: const Offset(20, 20),
      child: CircleParticle(paint: Paint()..color = Colors.amber),
    );
  }

  /// [ParticleComponent] which is moving to a random direction
  /// within each cell each time created
  ParticleComponent randomMovingParticle() {
    return MovingParticle(
      to: randomCellOffset(),
      child: CircleParticle(
        radius: 5 + rnd.nextDouble() * 5,
        paint: Paint()..color = Colors.red,
      ),
    );
  }

  /// Generates 5 particles, each moving
  /// symmetrically within grid cell
  ParticleComponent alignedMovingParticles() {
    return ParticleComponent.generate(
      count: 5,
      generator: (i) {
        final currentColumn = (cellSize.dx / 5) * i - halfCellSize.dx;
        return MovingParticle(
          from: Offset(currentColumn, -halfCellSize.dy),
          to: Offset(currentColumn, halfCellSize.dy),
          child: CircleParticle(
            radius: 2.0,
            paint: Paint()..color = Colors.blue,
          ),
        );
      },
    );
  }

  /// Burst of 5 particles each moving
  /// to a random direction within the cell
  ParticleComponent randomMovingParticles() {
    return ParticleComponent.generate(
      count: 5,
      generator: (i) => MovingParticle(
        to: randomCellOffset() * .5,
        child: CircleParticle(
          radius: 5 + rnd.nextDouble() * 5,
          paint: Paint()..color = Colors.deepOrange,
        ),
      ),
    );
  }

  /// Same example as above, but
  /// with easing, utilising [CurvedParticle] extension
  ParticleComponent easedMovingParticle() {
    return ParticleComponent.generate(
      count: 5,
      generator: (i) => MovingParticle(
        curve: Curves.easeOutQuad,
        to: randomCellOffset() * .5,
        child: CircleParticle(
          radius: 5 + rnd.nextDouble() * 5,
          paint: Paint()..color = Colors.deepPurple,
        ),
      ),
    );
  }

  /// Same example as above, but using awesome [Inverval]
  /// curve, which "schedules" transition to happen between
  /// certain values of progress. In this example, circles will
  /// move from their initial to their final position
  /// when progress is changing from 0.2 to 0.6 respectively.
  ParticleComponent intervalMovingParticle() {
    return ParticleComponent.generate(
      count: 5,
      generator: (i) => MovingParticle(
        curve: Interval(.2, .6, curve: Curves.easeInOutCubic),
        to: randomCellOffset() * .5,
        child: CircleParticle(
          radius: 5 + rnd.nextDouble() * 5,
          paint: Paint()..color = Colors.greenAccent,
        ),
      ),
    );
  }

  /// A [ComputedParticle] completely delegates all the rendering
  /// to an external function, hence It's very flexible, as you can implement
  /// any currently missing behavior with it.
  /// Also, it allows to optimize complex behaviors by avoiding nesting too
  /// many [ParticleComponent] together and having all the computations in place.
  ParticleComponent computedParticle() {
    return ComputedParticle(
      renderer: (canvas, particle) => canvas.drawCircle(
        Offset.zero,
        particle.progress * halfCellSize.dx,
        Paint()
          ..color = Color.lerp(
            Colors.red,
            Colors.blue,
            particle.progress,
          ),
      ),
    );
  }

  /// Using [ComputedParticle] to use custom tweening
  /// In reality, you would like to keep as much of renderer state
  /// defined outside and reused between each call
  ParticleComponent steppedComputedParticle() {
    return ComputedParticle(
      lifespan: 2,
      renderer: (canvas, particle) {
        const steps = 5;
        final steppedProgress =
            steppedTween.transform(particle.progress) / steps;

        GameCanvas.main.drawCircle(
          Offset.zero,
          (1 - steppedProgress) * halfCellSize.dx,
          Paint()
            ..color = Color.lerp(
              Colors.red,
              Colors.blue,
              steppedProgress,
            ),
        );
      },
    );
  }

  /// Particle which is used in example below
  ParticleComponent reusableParticle;

  /// A burst of white circles which actually using a single circle
  /// as a form of optimization. Look for reusing parts of particle effects
  /// whenever possible, as there are limits which are relatively easy to reach.
  ParticleComponent reuseParticles() {
    reusableParticle ??= circle();

    return ParticleComponent.generate(
      count: 10,
      generator: (i) => MovingParticle(
        curve: Interval(rnd.nextDouble() * .1, rnd.nextDouble() * .8 + .1),
        to: randomCellOffset() * .5,
        child: reusableParticle,
      ),
    );
  }

  /// Simple static image particle which doesn't do much.
  /// Images are great examples of where assets should
  /// be reused across particles. See example below for more details.
  ParticleComponent imageParticle() {
    return ImageParticle(
      size: const Size.square(24),
      image: Assets.rasterCache.get('zap.png').source,
    );
  }

  /// Particle which is used in example below
  ParticleComponent reusableImageParticle;

  /// A single [imageParticle] is drawn 9 times
  /// in a grid within grid cell. Looks as 9 particles
  /// to user, saves us 8 particle objects.
  ParticleComponent reuseImageParticle() {
    const count = 9;
    const perLine = 3;
    const imageSize = 24.0;
    final colWidth = cellSize.dx / perLine;
    final rowHeight = cellSize.dy / perLine;

    reusableImageParticle ??= imageParticle();

    return ParticleComponent.generate(
      count: count,
      generator: (i) => TranslatedParticle(
          offset: Offset(
            (i % perLine) * colWidth - halfCellSize.dx + imageSize,
            (i ~/ perLine) * rowHeight - halfCellSize.dy + imageSize,
          ),
          child: reusableImageParticle),
    );
  }

  /// [RotatingParticle] is a simple container which rotates
  /// a child particle passed to it.
  /// As you can see, we're reusing [imageParticle] from example above.
  /// Such a composability is one of the main implementation features.
  ParticleComponent rotatingImage({double initialAngle = 0}) {
    return RotatingParticle(from: initialAngle, child: imageParticle());
  }

  /// [AcceleratedParticle] is a very basic acceleration physics container,
  /// which could help implementing such behaviors as gravity, or adding
  /// some non-linearity to something like [MovingParticle]
  ParticleComponent acceleratedParticles() {
    return ParticleComponent.generate(
      count: 10,
      generator: (i) => AcceleratedParticle(
        speed:
            Offset(rnd.nextDouble() * 600 - 300, -rnd.nextDouble() * 600) * .2,
        acceleration: const Offset(0, 200),
        child: rotatingImage(initialAngle: rnd.nextDouble() * pi),
      ),
    );
  }

  /// [PaintParticle] allows to perform basic composite operations
  /// by specifying custom [Paint].
  /// Be aware that it's very easy to get *really* bad performance
  /// misusing composites.
  ParticleComponent paintParticle() {
    final List<Color> colors = [
      const Color(0xffff0000),
      const Color(0xff00ff00),
      const Color(0xff0000ff),
    ];
    final List<Offset> positions = [
      const Offset(-10, 10),
      const Offset(10, 10),
      const Offset(0, -14),
    ];

    return ParticleComponent.generate(
      count: 3,
      generator: (i) => PaintParticle(
        paint: Paint()..blendMode = BlendMode.difference,
        child: MovingParticle(
          curve: SineCurve(),
          from: positions[i],
          to: i == 0 ? positions.last : positions[i - 1],
          child: CircleParticle(
            radius: 20.0,
            paint: Paint()..color = colors[i],
          ),
        ),
      ),
    );
  }

  /// [SpriteParticle] allows easily embed
  /// Flame's [SpriteComponent] into the effect.
  ParticleComponent spriteParticle() {
    return SpriteParticle(
      sprite: SpriteComponent(Assets.rasterCache.get('zap.png')),
      size: Vector2(cellSize.dx * .5, cellSize.dx * .5),
    );
  }

  /// An [AnimationParticle] takes a Flame [AnimationComponent]
  /// and plays it during the particle lifespan.
  ParticleComponent animationParticle() {
    return AnimationParticle(
      animation: getBoomAnimation(),
      size: Vector2(128, 128),
    );
  }

  /// [EntityParticle] proxies particle lifecycle hooks
  /// to its child [GameEntity]. In example below, [GameEntity] is
  /// reused between particle effects and has internal behavior
  /// which is independent from the parent [ParticleComponent].
  ParticleComponent componentParticle() {
    return MovingParticle(
      from: -halfCellSize * .2,
      to: halfCellSize * .2,
      curve: SineCurve(),
      child: EntityParticle(entity: trafficLight),
    );
  }

  /// Not very realistic firework, yet it highlights
  /// use of [ComputedParticle] within other particles,
  /// mixing predefined and fully custom behavior.
  ParticleComponent fireworkParticle() {
    // A palette to paint over the "sky"
    final List<Paint> paints = [
      Colors.amber,
      Colors.amberAccent,
      Colors.red,
      Colors.redAccent,
      Colors.yellow,
      Colors.yellowAccent,
      // Adds a nice "lens" tint
      // to overall effect
      Colors.blue,
    ].map<Paint>((color) => Paint()..color = color).toList();

    return ParticleComponent.generate(
      count: 10,
      generator: (i) {
        final initialSpeed = randomCellOffset();
        final deceleration = initialSpeed * -1;
        const gravity = const Offset(0, 40);

        return AcceleratedParticle(
          speed: initialSpeed,
          acceleration: deceleration + gravity,
          child: ComputedParticle(renderer: (canvas, particle) {
            final paint = randomElement(paints);
            // Override the color to dynamically update opacity
            paint.color = paint.color.withOpacity(1 - particle.progress);

            GameCanvas.main.drawCircle(
              Offset.zero,
              // Closer to the end of lifespan particles
              // will turn into larger glaring circles
              rnd.nextDouble() * particle.progress > .6
                  ? rnd.nextDouble() * (50 * particle.progress)
                  : 2 + (3 * particle.progress),
              paint,
            );
          }),
        );
      },
    );
  }

  /// [RiveParticle] renders fiven [RiveComponent] inside
  /// as you can see, animation could be reused across
  /// different particles.
  ParticleComponent riveParticle() {
    final rive = CompositeParticle(children: <ParticleComponent>[
      // Circle Particle for background
      CircleParticle(
          paint: Paint()..color = Colors.white12,
          radius: riveAnimation.width / 2),
      RiveParticle(rive: riveAnimation),
    ]);

    final List<Offset> corners = [
      -halfCellSize,
      halfCellSize,
    ];

    return RotatingParticle(
      to: pi,
      child: ParticleComponent.generate(
        count: 2,
        generator: (i) => MovingParticle(
          to: corners[i] * .4,
          curve: SineCurve(),
          child: rive,
        ),
      ),
    );
  }

  /// [ParticleComponent] base class exposes a number
  /// of convenience wrappers to make positioning.
  ///
  /// Just remember that the less chaining and nesting - the
  /// better for performance!
  ParticleComponent chainingBehaviors() {
    final paint = Paint()..color = randomMaterialColor();
    final rect = ComputedParticle(
      renderer: (canvas, _) => canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: 10, height: 10),
        paint,
      ),
    );

    return CompositeParticle(children: <ParticleComponent>[
      rect
          .rotating(to: pi / 2)
          .moving(to: -cellSize)
          .scaled(2)
          .accelerated(acceleration: halfCellSize * 5)
          .translated(halfCellSize),
      rect
          .rotating(to: -pi)
          .moving(to: cellSize.scale(1, -1))
          .scaled(2)
          .translated(halfCellSize.scale(-1, 1))
          .accelerated(acceleration: halfCellSize.scale(-5, 5))
    ]);
  }


  @override
  void update() {
    fpsText.enabled = Game().debugMode;
    if (fpsText.enabled) {
      fpsText.textComponent.text = "${Game().fps(120).toStringAsFixed(1)} fps";
    }
  }


  /// Returns random [Offset] within a virtual
  /// grid cell
  Offset randomCellOffset() {
    return cellSize.scale(rnd.nextDouble(), rnd.nextDouble()) - halfCellSize;
  }

  /// Returns random [Color] from primary swatches
  /// of material palette
  Color randomMaterialColor() {
    return Colors.primaries[rnd.nextInt(Colors.primaries.length)];
  }

  /// Returns a random element from a given list
  T randomElement<T>(List<T> list) {
    return list[rnd.nextInt(list.length)];
  }

  /// Sample "explosion" animation for [AnimationParticle] example
  AnimationComponent getBoomAnimation() {
    const columns = 8;
    const rows = 8;
    final spriteImage = Assets.rasterCache.get('boom3.png');
    return AnimationComponent.fromRaster(
      spriteImage,
      frameWidth:  spriteImage.width ~/ columns,
      frameHeight: spriteImage.height ~/ rows,
      frameCount:  columns * rows,
    );
  }
}



/// A curve which maps sinus output (-1..1,0..pi)
/// to an oscillating (0..1..0,0..1), essentially "ease-in-out and back"
class SineCurve extends Curve {
  @override
  double transformInternal(double t) {
    return (sin(pi * (t * 2 - 1 / 2)) + 1) / 2;
  }
}


/// Sample for [EntityParticle], changes its colors
/// each 2s of registered lifetime.
class TrafficLightComponent extends GameEntity {
  final Rect rect = Rect.fromCenter(center: Offset.zero, height: 32, width: 32);
  final TimerComponent colorChangeTimer = TimerComponent(2, repeat: true);
  final colors = <Color>[
    Colors.green,
    Colors.orange,
    Colors.red,
  ];

  TrafficLightComponent() {
    colorChangeTimer.start();
  }

  @override
  void update() {
    colorChangeTimer.update();
    GameCanvas.main.drawRect(rect, Paint()..color = currentColor);
  }

  Color get currentColor {
    return colors[(colorChangeTimer.progress * colors.length).toInt()];
  }
}
