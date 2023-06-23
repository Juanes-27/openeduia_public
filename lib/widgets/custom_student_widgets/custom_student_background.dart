import 'dart:math';

import 'package:flutter/material.dart';

class CustomStudentBackground extends StatelessWidget {
  const CustomStudentBackground({Key? key}) : super(key: key);
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
        //const Positioned(top: -300, left: -30, child: _WhiteBox()),
        const Positioned(top: 600, left: 40, child: _PinkBox()),
      ],
    );
  }
}

//class _WhiteBox extends StatelessWidget {
//  const _WhiteBox();

//  @override
//  Widget build(BuildContext context) {
//    return Transform.rotate(
//      angle: -pi / 5.0,
//      child: Container(
//        width: 360,
//        height: 360,
//        decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(80),
//            color: Colors.purpleAccent.shade100),
//      ),
//    );
//  }
//}

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
            color: Colors.purpleAccent.shade100),
      ),
    );
  }
}
