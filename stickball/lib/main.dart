import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickball/game_state.dart';

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
      if (gameState.trajectoryLine != null) {
        // Draw green line
        final linePaint = Paint()
          ..color = Colors.green
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        
        // Draw yellow dots
        final dotPaint = Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.fill;

        // Draw the green line
        if (gameState.trajectoryLine!.startPoint != null && gameState.trajectoryLine!.endPoint != null) {
          canvas.drawLine(gameState.trajectoryLine!.startPoint!, gameState.trajectoryLine!.endPoint!, linePaint);
        }

        // Draw the yellow dots
        for (var point in gameState.trajectoryLine!.points) {
          canvas.drawCircle(point, 5, dotPaint);
        }
      }
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
          Text(
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