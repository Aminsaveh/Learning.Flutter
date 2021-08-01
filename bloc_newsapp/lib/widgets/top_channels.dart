import 'package:bloc_newsapp/bloc/get_source_news_bloc.dart';
import 'package:bloc_newsapp/bloc/get_sources_bloc.dart';
import 'package:bloc_newsapp/elements/error_element.dart';
import 'package:bloc_newsapp/elements/loader_element.dart';
import 'package:bloc_newsapp/model/source.dart';
import 'package:bloc_newsapp/model/source_response.dart';
import 'package:flutter/material.dart';

class TopChannel extends StatefulWidget {
  const TopChannel({Key? key}) : super(key: key);

  @override
  _TopChannelState createState() => _TopChannelState();
}

class _TopChannelState extends State<TopChannel> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSourcesBloc..getSources();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SourceResponse>(
      stream: getSourcesBloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<SourceResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null && snapshot.data!.error.length > 0) {
            return buildErrorWidget(snapshot.data!.error);
          }
          return _buildTopChannels(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data!.error);
        } else {
          return buildloadingWidget();
        }
      },
    );
  }

  Widget _buildTopChannels(SourceResponse? data) {
    List<SourceModel> sources = data!.sources;
    if (sources.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [Text('No Sources!')],
        ),
      );
    } else {
      return Container(
        height: 115.0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: sources.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              padding: EdgeInsets.only(
                top: 10.0,
              ),
              width: 80.0,
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: sources[index],
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5.0,
                                  spreadRadius: 1.0,
                                  offset: Offset(1.0, 1.0),
                                )
                              ],
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      'assets/logos/${sources[index].id}.png')))),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      sources[index].name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          height: 1.4,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      sources[index].category,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 9.0),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
