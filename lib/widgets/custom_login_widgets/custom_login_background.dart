import 'dart:math';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);
  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
        0.2,
        0.8
      ],
          colors: [
        Color.fromRGBO(177, 201, 232, 1),
        Color.fromRGBO(177, 201, 232, 1),
      ]));
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //purple Gradient
        Container(
          decoration: boxDecoration,
        ),
        // Pink Box
        const Positioned(top: -100, left: -30, child: _PinkBox()),
        const Positioned(top: 500, left: 30, child: _PinkBox()),
      ],
    );
  }
}

class _PinkBox extends StatelessWidget {
  const _PinkBox();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5.0,
      child: Container(
        width: 360,
        height: 360,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80), color: Colors.white),
      ),
    );
  }
}
