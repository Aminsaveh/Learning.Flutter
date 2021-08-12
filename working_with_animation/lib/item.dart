import 'package:flutter/material.dart';

enum Sides { left, top, right, bottom }

class Item extends StatefulWidget {
  double right, left, top, bottom;
  Color color;
  String text;
  double opacity = 1;
  Item(
      {Key? key,
      this.right = 0,
      this.bottom = 0,
      this.left = 0,
      this.top = 0,
      this.text = '',
      required this.color})
      : super(key: key);

  @override
  ItemState createState() => ItemState();
}

class ItemState extends State<Item> {
  void changeDirection(Sides sides) {
    setState(() {
      switch (sides) {
        case Sides.left:
          widget.right = MediaQuery.of(context).size.width;
          break;
        case Sides.right:
          widget.left = MediaQuery.of(context).size.width;
          break;
        case Sides.top:
          widget.bottom = MediaQuery.of(context).size.height;
          break;
        case Sides.bottom:
          widget.top = MediaQuery.of(context).size.height;
          break;
      }
      widget.opacity = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      margin: EdgeInsets.only(
        right: widget.right,
        bottom: widget.bottom,
        left: widget.left,
        top: widget.top,
      ),
      duration: Duration(seconds: 1),
      color: widget.color,
      child: Center(
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: widget.opacity,
          child: Text(
            widget.text,
            style: TextStyle(color: Colors.black, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
