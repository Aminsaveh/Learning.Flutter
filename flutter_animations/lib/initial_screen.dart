import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animations/item.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  late List<Item> items;
  late Color _statusColor;
  List<double> opacities = [1, 1, 1, 1];
  List<GlobalKey<ItemState>> keys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  late int index;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    items = [
      Item(
        text: 'Finished!',
        color: Colors.blue,
        key: keys[0],
      ),
      Item(
        text: 'For more...',
        color: Colors.yellow,
        key: keys[1],
      ),
      Item(
        text: 'Do you know?',
        color: Colors.red,
        key: keys[2],
      ),
      Item(
        text: 'Welcome!',
        color: Colors.green,
        key: keys[3],
      ),
      Item(
        text: 'Hi!',
        color: Colors.white,
        key: keys[4],
      )
    ];
    index = items.length - 1;
    _statusColor = items[index].color;
  }

  void changeStatusBarColorAndHideArrow(Sides side) {
    setState(() {
      _statusColor = items[index - 1].color;
      switch (side) {
        case Sides.left:
          opacities[0] = 0;
          break;
        case Sides.top:
          opacities[1] = 0;
          break;
        case Sides.right:
          opacities[2] = 0;
          break;
        case Sides.bottom:
          opacities[3] = 0;
          break;
      }
    });
  }

  void move(Sides side) async {
    keys[index].currentState!.changeDirection(side);
    index--;
    await Future.delayed(Duration(seconds: 1)).then((value) {
      keys.removeAt(index + 1);
      items.removeAt(index + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(statusBarColor: _statusColor),
        child: Scaffold(
          body: SafeArea(
            top: true,
            child: Stack(
              children: <Widget>[
                ...items,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: opacities[0],
                        child: IconButton(
                          onPressed: () {
                            changeStatusBarColorAndHideArrow(Sides.left);
                            move(Sides.left);
                          },
                          icon: Icon(Icons.arrow_left),
                          iconSize: 40,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: opacities[1],
                          child: IconButton(
                            onPressed: () {
                              changeStatusBarColorAndHideArrow(Sides.top);
                              move(Sides.top);
                            },
                            icon: Icon(
                              Icons.arrow_drop_up,
                            ),
                            iconSize: 40,
                          ),
                        ),
                        AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: opacities[3],
                          child: IconButton(
                              onPressed: () {
                                changeStatusBarColorAndHideArrow(Sides.bottom);
                                move(Sides.bottom);
                              },
                              icon: Icon(
                                Icons.arrow_drop_down,
                              ),
                              iconSize: 40,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Center(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 500),
                        opacity: opacities[2],
                        child: IconButton(
                          icon: Icon(
                            Icons.arrow_right,
                          ),
                          iconSize: 40,
                          onPressed: () {
                            changeStatusBarColorAndHideArrow(Sides.right);
                            move(Sides.right);
                          },
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
