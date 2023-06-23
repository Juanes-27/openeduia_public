import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  _RegisterScreenState();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
            children: const [
              Background(),
              Register(),
            ],
          )),
    );
  }
}
