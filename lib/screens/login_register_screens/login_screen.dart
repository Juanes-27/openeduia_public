import 'package:flutter/material.dart';

import 'package:Openedu.IA/widgets/widgets.dart';

class LoginRegisterScreen extends StatelessWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  void signUserIn() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Center(
              child: Text(
                'OpenEduIA',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    customshowDialog(context);
                  },
                  icon: const Icon(Icons.info))
            ]),
        body: Stack(
          children: const [Background(), CustomLogInBody()],
        ));
  }
}
