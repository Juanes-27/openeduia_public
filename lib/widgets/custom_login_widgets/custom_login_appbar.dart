import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';

class CustomLogInAppBar extends StatelessWidget {
  const CustomLogInAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        ]);
  }
}
