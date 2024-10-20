import 'package:flutter/material.dart';

class MyPlayer extends StatefulWidget {
  @override
  _MyPlayerState createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  Offset _position = Offset(0, 0);

  void _movePlayer() {
    print('Current position: $_position');
    setState(() {
      _position += const Offset(10, 10);
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
              width: 50,
              height: 50,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}