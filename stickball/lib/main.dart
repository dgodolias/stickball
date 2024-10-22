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
      onTap: () => gameState.movePlayer(context),
      child: Stack(
        children: [
          if (gameState.position != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: gameState.position!.dx,
              top: gameState.position!.dy,
              child: Container(
                width: gameState.width,
                height: gameState.height,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
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