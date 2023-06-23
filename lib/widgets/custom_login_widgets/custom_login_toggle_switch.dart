import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class CustomToggleSwitch extends StatelessWidget {
  const CustomToggleSwitch({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ToggleSwitch(
      minWidth: 150.0,
      initialLabelIndex: 1,
      cornerRadius: 20.0,
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: const ['Estudiante', 'Profesor'],
      icons: const [Icons.person, Icons.book],
      activeBgColors: const [
        [Colors.indigo],
        [Colors.indigo]
      ],
      onToggle: (index) {},
    );
  }
}
