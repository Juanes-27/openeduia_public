import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:Openedu.IA/widgets/widgets.dart';

class WorldsSubsectionsScreen extends StatefulWidget {
  final int world_index;
  final String world_name;

  WorldsSubsectionsScreen(
      {Key? key, required this.world_index, required this.world_name})
      : super(key: key);

  @override
  State<WorldsSubsectionsScreen> createState() =>
      _WorldsSubsectionsScreenState();
}

class _WorldsSubsectionsScreenState extends State<WorldsSubsectionsScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
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
            widget.world_name,
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
              DescriptionWorldScreen(
                world_index: widget.world_index,
              )
            else if (_currentIndex == 1)
              ContentSubsectionScreen(
                world_index: widget.world_index,
                world_name: widget.world_name,
              ),
            if (_currentIndex == 2)
              ChallengesWorldScreen(
                world_index: widget.world_index,
              ),
            if (_currentIndex == 3)
              CommentsWorldScreen(
                world_index: widget.world_index,
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
                setState(() {
                  _currentIndex = index;
                });
              },
              padding: const EdgeInsets.all(5),
              tabs: const [
                GButton(
                  icon: Icons.description,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  iconSize: 30,
                  text: 'Descripción',
                  textColor: Colors.white,
                ),
                GButton(
                  icon: Icons.menu_book_sharp,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  iconSize: 30,
                  text: 'Contenido',
                  textColor: Colors.white,
                ),
                GButton(
                  icon: Icons.emoji_objects_outlined,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  iconSize: 30,
                  text: 'Desafíos',
                  textColor: Colors.white,
                ),
                GButton(
                  icon: Icons.comment,
                  iconColor: Colors.white,
                  iconActiveColor: Colors.white,
                  iconSize: 30,
                  text: 'Comentarios',
                  textColor: Colors.white,
                )
              ],
            ),
          ),
        ));
  }
}
