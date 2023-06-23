import 'package:flutter/material.dart';

class HomeScreenMemoryGame extends StatelessWidget {
  const HomeScreenMemoryGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: Text("Challenge Mundo 2"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'game',
                      arguments: {'level': 'medium'});
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all<Size>(Size(250, 70)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                child: Text(
                  'Inicia',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                )),
          ),
        ],
      ),
    );
  }
}
