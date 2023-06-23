import 'package:flutter/material.dart';

import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/services.dart';

class HomeStudentScreen extends StatefulWidget {
  @override
  State<HomeStudentScreen> createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    CustomStudentHomeBody(),
    CustomStudentArchivementsBody(),
    CustomStudentAssistantBody(),
    CustomStudentPythonShell(),
  ];

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body: SizedBox(
              width: size.width,
              height: size.height,
              child: Stack(
                children: [
                  const CustomStudentBackground(),
                  if (_currentIndex == 0)
                    CustomStudentHomeBody()
                  else
                    _children[_currentIndex],
                ],
              ),
            ),
            bottomNavigationBar: Container(
              color: Colors.indigo,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                child: GNav(
                  backgroundColor: Colors.transparent,
                  color: Colors.transparent,
                  activeColor: Colors.white,
                  tabBackgroundColor: Colors.purpleAccent.shade100,
                  gap: 8,
                  onTabChange: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  padding: const EdgeInsets.all(5),
                  tabs: const [
                    GButton(
                      icon: Icons.home,
                      iconColor: Colors.white,
                      iconActiveColor: Colors.white,
                      iconSize: 30,
                      text: 'Inicio',
                      textColor: Colors.white,
                    ),
                    GButton(
                      icon: Icons.workspace_premium_outlined,
                      iconColor: Colors.white,
                      iconActiveColor: Colors.white,
                      iconSize: 30,
                      text: 'Logros',
                      textColor: Colors.white,
                    ),
                    GButton(
                      icon: Icons.support_agent_outlined,
                      iconColor: Colors.white,
                      iconActiveColor: Colors.white,
                      iconSize: 30,
                      text: 'Asistencia virtual',
                      textColor: Colors.white,
                    ),
                    GButton(
                      icon: Icons.terminal,
                      iconColor: Colors.white,
                      iconActiveColor: Colors.white,
                      iconSize: 30,
                      text: 'Compilador Python',
                      textColor: Colors.white,
                    )
                  ],
                ),
              ),
            )));
  }
}
