import 'package:Openedu.IA/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomWorldSubsectionHomeScreen extends StatefulWidget {
  final String subsectionName;
  final String subsectionProgress;
  final String worldProgress;
  final String actualWorld;
  final String actualSubsection;
  const CustomWorldSubsectionHomeScreen({
    Key? key,
    required this.subsectionName,
    required this.subsectionProgress,
    required this.worldProgress,
    required this.actualWorld,
    required this.actualSubsection,
  }) : super(key: key);

  @override
  State<CustomWorldSubsectionHomeScreen> createState() =>
      _CustomWorldSubsectionHomeScreenState();
}

class _CustomWorldSubsectionHomeScreenState
    extends State<CustomWorldSubsectionHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.indigo,
          toolbarHeight: 100,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70),
                  bottomLeft: Radius.circular(70))),
          title: Text(
            this.widget.subsectionName,
            textAlign: TextAlign.justify,
            maxLines: 3,
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(children: [
            const CustomStudentBackground(),
            if (_currentIndex == 0)
              CustomWorldSubsectionWidgetVideos(
                  world_index: widget.actualWorld,
                  subsection_index: widget.actualSubsection),
            if (_currentIndex == 1)
              CustomWorldSubsectionWidgetQuiz(
                worldIndex: widget.actualWorld,
                subsectionIndex: widget.actualSubsection,
              )
          ]),
        ),
        bottomNavigationBar: Container(
          color: Colors.indigo,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: GNav(
              backgroundColor: Colors.transparent,
              color: Colors.transparent,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.purpleAccent.shade100,
              gap: 8,
              onTabChange: (index) {
                print(widget.actualWorld);
                setState(() {
                  _currentIndex = index;
                });
              },
              padding: const EdgeInsets.all(5),
              tabs: [
                GButton(
                  icon: Icons.videocam,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  iconSize: 30,
                  text: 'Videos',
                  textColor: Colors.white,
                ),
                if (widget.actualWorld != 6)
                  GButton(
                    icon: Icons.quiz_outlined,
                    iconColor: Colors.white,
                    iconActiveColor: Colors.white,
                    iconSize: 30,
                    text: 'Quices',
                    textColor: Colors.white,
                  ),
              ],
            ),
          ),
        ));
  }
}
