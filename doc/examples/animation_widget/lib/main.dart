import 'package:pogo/game_engine.dart';
import 'package:flutter/material.dart';

SpriteComponent _sprite;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  System.defaultPivot = Pivot.topLeft;

  _sprite = await SpriteComponent.fromRasterFile('minotaur.png', frameWidth: 96, frameHeight: 96);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation as a Widget Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Size _size = const Size(256.0, 256.0);

  @override
  void initState() {
    super.initState();
    changeSize();
  }

  void changeSize() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _size = Size(_size.width + 10, _size.height + 10);
    });
  }

  void _clickFab(GlobalKey<ScaffoldState> key) {
    key.currentState.showSnackBar(
      const SnackBar(
        content: const Text('You clicked the FAB!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Animation as a Widget Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Hi there! This is a regular Flutter app,'),
            const Text('with a complex widget tree and also'),
            const Text('some pretty sprite sheet animations :)'),
            PogoWidget.fromAnimation(
                AnimationComponent.fromRaster(
                  _sprite.image,
                  frameWidth: 96,
                  frameCount: 19,
                ),
                _size
            ),
            // Alternative to fromAnimation() with more flexibility:
            /*PogoWidget.fromEntity(
                AnimationPrefab(
                    AnimationComponent.fromRaster(
                        _sprite.image,
                        frameWidth: 96,
                        frameCount: 19,
                        pivot: Pivot.center,
                    ),
                    position: Vector2(_size.width / 2, _size.height / 2),
                    rotationDeg: 45,
                    scale: Vector2(_size.width / 96, _size.height / 96),
                ),
                _size
            ),*/
            const Text('Neat, hum?'),
            const Text('By the way, you can also use static sprites as widgets:'),
            PogoWidget.fromSprite(_sprite, const Size(100, 100)),
            const SizedBox(height: 20),
            const Text('Sprites from Elthen\'s amazing work on itch.io:'),
            const Text('https://elthen.itch.io/2d-pixel-art-minotaur-sprites'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _clickFab(key),
        child: const Icon(Icons.add),
      ),
    );
  }
}
