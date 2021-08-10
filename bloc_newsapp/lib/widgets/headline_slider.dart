import 'package:bloc_newsapp/bloc/get_top_headlines_bloc.dart';
import 'package:bloc_newsapp/elements/error_element.dart';
import 'package:bloc_newsapp/elements/loader_element.dart';
import 'package:bloc_newsapp/model/article.dart';
import 'package:bloc_newsapp/model/article_response.dart';
import 'package:bloc_newsapp/screens/news_detail.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:timeago/timeago.dart' as timeago;

class HeadlineSliderWidget extends StatefulWidget {
  const HeadlineSliderWidget({Key? key}) : super(key: key);

  @override
  _HeadlineSliderWidgetState createState() => _HeadlineSliderWidgetState();
}

class _HeadlineSliderWidgetState extends State<HeadlineSliderWidget> {
  @override
  void initState() {
    super.initState();
    getTopHeadlinesBloc..getHeadlines();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getTopHeadlinesBloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null && snapshot.data!.error.length > 0) {
            return buildErrorWidget(snapshot.data!.error);
          }
          return _buildHeadlineSlider(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data!.error);
        } else {
          return buildloadingWidget();
        }
      },
    );
  }

  Widget _buildHeadlineSlider(ArticleResponse? data) {
    List<ArticleModel>? articles = data!.articles;
    return Container(
      child: CarouselSlider(
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: false,
              height: 200.0,
              viewportFraction: 0.9),
          items: getExpenseSliders(articles!)),
    );
  }

  getExpenseSliders(List<ArticleModel> articles) {
    return articles
        .map((article) => GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return NewsDetail(article: article);
                }));
              },
              child: Container(
                padding: EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 10,
                  top: 10,
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: article.img == null
                              ? AssetImage("assets/img/placeholder.png")
                              : NetworkImage(article.img) as ImageProvider,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            stops: [0.1, 0.9],
                            colors: [
                              Colors.black.withOpacity(0.9),
                              Colors.white.withOpacity(0.0)
                            ],
                          )),
                    ),
                    Positioned(
                      bottom: 30.0,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: 250,
                        child: Column(
                          children: [
                            Text(
                              article.title,
                              style: TextStyle(
                                  height: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      left: 10,
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        width: 250,
                        child: Text(
                          article.source.name,
                          style:
                              TextStyle(color: Colors.white54, fontSize: 9.0),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 10.0,
                        right: 10.0,
                        child: Text(
                          timeUntil(DateTime.parse(article.date)),
                          style:
                              TextStyle(color: Colors.white54, fontSize: 9.0),
                        )),
                  ],
                ),
              ),
            ))
        .toList();
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
