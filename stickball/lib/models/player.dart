import 'package:flutter/material.dart';
import 'package:stickball/utils.dart';

class MyPlayer extends StatefulWidget {
  @override
  _MyPlayerState createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  Offset _position = Offset(0, 0);

  void _movePlayer() {
    print('Current position: $_position');
    setState(() {
      _position += Offset(
        0.2*percentageOfWidth(context, 1), // Move by 1% of the screen width
        1.8*percentageOfHeight(context, 1), // Move by 1% of the screen height
      );
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _position.dx,
            top: _position.dy,
            child: Container(
              width: percentageOfWidth(context, 5),
              height: percentageOfHeight(context, 5), 
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}