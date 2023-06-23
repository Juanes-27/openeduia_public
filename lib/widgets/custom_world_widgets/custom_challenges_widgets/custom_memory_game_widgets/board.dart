import 'package:flutter/material.dart';

Widget board(String title, String info) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(info,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold))
        ],
      ),
    ),
  );
}
