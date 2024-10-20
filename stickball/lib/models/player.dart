import 'package:flutter/material.dart';
import 'package:stickball/utils.dart';

class MyPlayer extends StatefulWidget {
  @override
  _MyPlayerState createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  Offset? _position;
  double? width;
  double? height;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        width = percentageOfWidth(context, 5);
        height = percentageOfHeight(context, 5);
        print('Width: $width');
        print('Height: $height');
        _position = getCenterPosition(context, width!, height!);
        print('Initial position: $_position');
      });
    });
  }

  void _movePlayer() {
    if (_position == null) return;
    print('Current position: $_position');
    setState(() {
      _position = moveByPercentage(context, _position!, 0.2, 1.8, width!,
          height!); // Move by 0.2% width and 1.8% height
      print('Changed by height: ${percentageOfHeight(context, 1)}');
      print('New position: $_position');
    });
    print('State updated');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Container tapped');
        _movePlayer();
      },
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
    );
  }
}
