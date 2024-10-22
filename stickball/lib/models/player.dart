import 'package:flutter/material.dart';
import 'package:stickball/utils.dart';
import 'package:stickball/models/trajectory_line.dart';


class MyPlayer extends StatefulWidget {
  @override
  _MyPlayerState createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  Offset? _position;
  double? width;
  double? height;
  late TrajectoryLine trajectoryLine;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        width = percentageOfWidth(context, 5);
        height = percentageOfHeight(context, 5);
        _position = getCenterPosition(context, width!, height!);
        trajectoryLine = TrajectoryLine(
          playerPosition: _position!,
          screenSize: MediaQuery.of(context).size,
        );
      });
    });
  }

  void _movePlayer() {
    if (_position == null) return;
    setState(() {
      _position = moveByPercentage(context, _position!, 0.2, 1.8, width!, height!);
      trajectoryLine.updatePlayerPosition(_position!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _movePlayer,
      child: CustomPaint(
        painter: TrajectoryPainter(trajectoryLine),
        child: Stack(
          children: [
            if (_position != null)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: _position!.dx,
                top: _position!.dy,
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class TrajectoryPainter extends CustomPainter {
  final TrajectoryLine trajectoryLine;

  TrajectoryPainter(this.trajectoryLine);

  @override
  void paint(Canvas canvas, Size size) {

    trajectoryLine.draw(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}