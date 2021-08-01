import 'package:bloc_newsapp/widgets/headline_slider.dart';
import 'package:bloc_newsapp/widgets/hot_news.dart';
import 'package:bloc_newsapp/widgets/top_channels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HeadlineSliderWidget(),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Top Channels',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        TopChannel(),
        Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Hot News',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
        ),
        HotNews(),
      ],
    );
  }
}
