import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stickball/utils.dart';
import 'package:stickball/models/trajectory_line.dart';
import 'package:stickball/models/player.dart';
import 'package:stickball/models/wall.dart';

class GameState extends ChangeNotifier {
  Player? player;
  bool isGameOver = false;
  TrajectoryLine? trajectoryLine;
  Size? screenSize;
  Wall? leftWall;
  Wall? rightWall;

  void initializeGame(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    double width = percentageOfWidth(context, 5);
    double height = percentageOfHeight(context, 5);
    Offset position = getCenterPosition(context, width, height);

    player = Player(position: position, width: width, height: height);
    isGameOver = false;
    trajectoryLine = TrajectoryLine(player: player!, screenSize: screenSize!);

    // Initialize walls
    leftWall = Wall(position: Offset(0, 0), width: screenSize!.width * 0.1, height: screenSize!.height);
    rightWall = Wall(position: Offset(screenSize!.width - screenSize!.width * 0.1, 0), width: screenSize!.width * 0.1, height: screenSize!.height);

    notifyListeners();
  }

  void startDrag(Offset position) {
    trajectoryLine?.startDrag(position);
    notifyListeners();
  }

  void updateDrag(Offset position) {
    trajectoryLine?.updateDrag(position);
    notifyListeners();
  }

  void endDrag() {
    if (trajectoryLine?.getEndPoint() != null) {
      movePlayerAlongTrajectory();
    }
    trajectoryLine?.endDrag();
    notifyListeners();
  }

  void movePlayerAlongTrajectory() {
  if (trajectoryLine?.points.isNotEmpty ?? false) {
    // Move to the next point in the trajectory
    Offset nextPoint = trajectoryLine!.points.removeAt(0);

    // Check for collision with walls
    if (_isCollidingWithWall(nextPoint)) {
      // Stick to the wall
      if (nextPoint.dx < leftWall!.position.dx + leftWall!.width) {
        nextPoint = Offset(
            leftWall!.position.dx + leftWall!.width + player!.width / 2,
            nextPoint.dy);
      } else if (nextPoint.dx > rightWall!.position.dx) {
        nextPoint = Offset(rightWall!.position.dx - player!.width / 2,
            nextPoint.dy);
      }
    }

    player!.position = nextPoint;
    trajectoryLine?.updatePlayerPosition(player!.position);

    if (_isOutOfBounds()) {
      isGameOver = true;
    }

    // If there are more points, continue moving after a delay
    if (trajectoryLine!.points.isNotEmpty) {
      Future.delayed(Duration(milliseconds: 100), () {
        movePlayerAlongTrajectory();
      });
    }
  }
}

  bool _isCollidingWithWall(Offset endPoint) {
    return (endPoint.dx < leftWall!.position.dx + leftWall!.width ||
            endPoint.dx > rightWall!.position.dx);
  }

  bool _isOutOfBounds() {
    if (player == null || screenSize == null) return false;
    return player!.position.dx < 0 ||
        player!.position.dx > screenSize!.width - player!.width ||
        player!.position.dy < 0 ||
        player!.position.dy > screenSize!.height - player!.height;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameState = Provider.of<GameState>(context);

    if (gameState.player?.position == null) {
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
  const PlayScreen({super.key});

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
    if (gameState.player != null) {
      gameState.player!.draw(canvas);
      gameState.trajectoryLine?.draw(canvas);
      
      // Draw walls
      gameState.leftWall?.draw(canvas);
      gameState.rightWall?.draw(canvas);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

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
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text('Click here to start again'),
            onPressed: () {
              Provider.of<GameState>(context, listen: false).initializeGame(context);
            },
          ),
        ],
      ),
    );
  }
}