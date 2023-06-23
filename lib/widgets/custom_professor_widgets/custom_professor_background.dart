import 'dart:math';

import 'package:flutter/material.dart';

class ProfessorBackground extends StatelessWidget {
  const ProfessorBackground({Key? key}) : super(key: key);
  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.2, 0.8],
          colors: [Colors.white, Colors.white]));
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //purple Gradient
        Container(
          decoration: boxDecoration,
        ),
        // Pink Box
        const Positioned(top: 620, left: 30, child: _PinkBox()),
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
          borderRadius: BorderRadius.circular(80),
          color: Color.fromRGBO(197, 189, 236, 1),
        ),
      ),
    );
  }
}
