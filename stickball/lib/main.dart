import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickball/game_state.dart';
import 'package:stickball/utils.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameState(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    if (gameState.position == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setScreenDimensions(context); // Call the function to set screen dimensions
        gameState.initializeGame(context);
      });
    }

    return Scaffold(
      body: gameState.isGameOver ? GameOverScreen() : PlayScreen(),
    );
  }
}

class PlayScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    return GestureDetector(
      onPanStart: (details) => gameState.startDrag(details.localPosition),
      onPanUpdate: (details) => gameState.updateDrag(details.localPosition),
      onPanEnd: (_) => gameState.endDrag(),
      child: CustomPaint(
        painter: GamePainter(gameState),
        child: Container(),
      ),
    );
  }
}

class GamePainter extends CustomPainter {
  final GameState gameState;

  GamePainter(this.gameState);

  @override
  void paint(Canvas canvas, Size size) {
    if (gameState.position != null) {
      // Draw player
      final playerPaint = Paint()..color = Colors.blue;
      canvas.drawCircle(gameState.position!, gameState.width! / 2, playerPaint);

      // Draw trajectory
      gameState.trajectoryLine?.draw(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GameOverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Game Over',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            child: Text('Click here to start again'),
            onPressed: () {
              Provider.of<GameState>(context, listen: false).initializeGame(context);
            },
          ),
        ],
      ),
    );
  }
}