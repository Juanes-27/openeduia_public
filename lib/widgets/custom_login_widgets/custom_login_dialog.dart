import 'package:flutter/material.dart';

void customshowDialog(BuildContext context) {
  showAboutDialog(
    context: context,
    applicationName: 'OpenEduIA',
    applicationIcon: const FlutterLogo(),
    applicationVersion: '0..0.1',
    children: [
      const Text(
        'Información acerca de las librerias utilizadas en la aplicación.',
        textAlign: TextAlign.justify,
        style: TextStyle(
            color: Colors.indigo, fontSize: 15, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
