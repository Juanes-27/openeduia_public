import 'package:flutter/material.dart';
import 'package:Openedu.IA/widgets/widgets.dart';

class CustomStudentHomeBody extends StatelessWidget {
  final int selected_avatar = 0;
  CustomStudentHomeBody({Key? key, selected_avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomStudentAppBarHome(),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: size.height - 235,
                width: size.width - 50,
                child: WorldsCardSwiper(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
