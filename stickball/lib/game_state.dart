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
    leftWall =
        Wall(position: Offset(0, 0), width: 10, height: screenSize!.height);
    rightWall = Wall(
        position: Offset(screenSize!.width - 10, 0),
        width: 10,
        height: screenSize!.height);

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

  void movePlayerAlongTrajectory() async {
    if (trajectoryLine == null || player == null) return;

    // Log player position and touch point
    print(
        'Player Position: dx=${player!.position.dx}, dy=${player!.position.dy}');
    print(
        'Touch Point: dx=${trajectoryLine!.currentTouchPoint!.dx}, dy=${trajectoryLine!.currentTouchPoint!.dy}');

    // Calculate the angle (theta) and initial velocity (v) once
    double theta = starting_trajectory_angle(
      player!.position.dx,
      player!.position.dy,
      trajectoryLine!.currentTouchPoint!.dx,
      trajectoryLine!.currentTouchPoint!.dy,
    );
    print('Theta: $theta');

    double v = createVelocity(
      player!.position.dx,
      player!.position.dy,
      trajectoryLine!.currentTouchPoint!.dx,
      trajectoryLine!.currentTouchPoint!.dy,
    );
    print('Initial Velocity (v): $v');

    double t = 0;
    double dt = 0.1; // Time step, adjust as needed
    Offset initialPosition = player!.position; // Store the initial position

    while (true) {
      t += dt;
      double x = initialPosition.dx + StartingVelocityX(v, theta) * t;
      double y = initialPosition.dy -
          createTrajectoryFunc(
              theta, v, x, initialPosition.dx, initialPosition.dy, 0, 0);
      print("Calculated new position: dx=$x, dy=$y");
      Offset newPosition = Offset(x, y);

      // Check for collision with walls
      if (_isCollidingWithWall(newPosition)) {
        // Stick to the wall
        if (newPosition.dx <
            leftWall!.position.dx + leftWall!.width + player!.width / 2) {
          newPosition = Offset(
              leftWall!.position.dx + leftWall!.width + player!.width / 2,
              newPosition.dy);
        } else if (newPosition.dx >
            rightWall!.position.dx - player!.width / 2) {
          newPosition = Offset(
              rightWall!.position.dx - player!.width / 2, newPosition.dy);
        }
        break;
      }

      if (_isOutOfBounds()) {
        isGameOver = true;
        break;
      }

      // Update the player's position
      player!.position = newPosition;
      print(
          "Player's updated position: dx=${player!.position.dx}, dy=${player!.position.dy}");

      trajectoryLine?.updatePlayerPosition(newPosition);
      notifyListeners();
      await Future.delayed(
          Duration(milliseconds: 1)); // Adjust the delay as needed

      // Break the loop if the player reaches the end of the trajectory
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
        setScreenDimensions(
            context); // Call the function to set screen dimensions
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

      // Draw trajectory
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
              Provider.of<GameState>(context, listen: false)
                  .initializeGame(context);
            },
          ),
        ],
      ),
    );
  }
}
