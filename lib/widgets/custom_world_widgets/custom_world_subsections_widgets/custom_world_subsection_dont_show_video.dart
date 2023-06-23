import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomWorldSubsectionDontShowVideo extends StatelessWidget {
  final String videoURL;
  final String videoName;
  CustomWorldSubsectionDontShowVideo(
      {Key? key, required this.videoURL, required this.videoName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        this.videoName,
        textAlign: TextAlign.justify,
        style: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: TextField(
                  readOnly: true,
                  controller: TextEditingController(
                      text: "https://youtu.be/${this.videoURL}")),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Clipboard.setData(
                      ClipboardData(text: "https://youtu.be/${this.videoURL}"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Texto copiado')),
                  );
                },
                child: Icon(Icons.copy)),
          ],
        ),
      ),
    );
  }
}
