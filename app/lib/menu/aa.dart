import 'package:flutter/material.dart';

class HorizontalSlider extends StatelessWidget {
 HorizontalSlider({Key? key}) : super(key: key);

// Dummy Month name
List<String> monthName = [
"Jan",
"Feb",
"Mar",
"Apr",
"May",
"Jun",
"July",
"Aug",
"Sep",
"Oct",
"Nov",
"Dec"
 ];
ScrollController slideController = new ScrollController();

@override
Widget build(BuildContext context) {
 return Container(
  child: Flex(
    direction: Axis.horizontal,
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: () {
          // Here monthScroller.position.pixels represent current postion 
          // of scroller
           slideController.animateTo(
            slideController.position.pixels - 100, // move slider to left
             duration: Duration(
              seconds: 1,
            ),
            curve: Curves.ease,
          );
        },
        child: Icon(Icons.arrow_left),
      ),
      Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.7,
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: slideController,
          physics: ScrollPhysics(),
          children: monthName
              .map((e) => Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("$e"),
                  ))
              .toList(),
        ),
      ),
      GestureDetector(
        onTap: () {
          slideController.animateTo(
            slideController.position.pixels +
                100, // move slider 100px to right
            duration: Duration(
              seconds: 1,
            ),
            curve: Curves.ease,
          );
        },
        child: Icon(Icons.arrow_right),
      ),
    ],
  ),
);
 }
 }