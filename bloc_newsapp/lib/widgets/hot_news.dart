import 'package:bloc_newsapp/bloc/get_hotnews_bloc.dart';
import 'package:bloc_newsapp/elements/error_element.dart';
import 'package:bloc_newsapp/elements/loader_element.dart';
import 'package:bloc_newsapp/model/article.dart';
import 'package:bloc_newsapp/model/article_response.dart';
import 'package:bloc_newsapp/screens/news_detail.dart';
import 'package:flutter/material.dart';
import 'package:bloc_newsapp/style/theme.dart' as Style;
import 'package:timeago/timeago.dart' as timeago;

class HotNews extends StatefulWidget {
  const HotNews({Key? key}) : super(key: key);

  @override
  _HotNewsState createState() => _HotNewsState();
}

class _HotNewsState extends State<HotNews> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHotNewsBloc..getHotNews();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ArticleResponse>(
      stream: getHotNewsBloc.subject.stream,
      builder: (BuildContext context, AsyncSnapshot<ArticleResponse> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.error != null && snapshot.data!.error.length > 0) {
            return buildErrorWidget(snapshot.data!.error);
          }
          return _buildHotNews(snapshot.data);
        } else if (snapshot.hasError) {
          return buildErrorWidget(snapshot.data!.error);
        } else {
          return buildloadingWidget();
        }
      },
    );
  }

  Widget _buildHotNews(ArticleResponse? data) {
    List<ArticleModel>? articles = data!.articles;
    if (articles!.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'No More News!',
              style: TextStyle(color: Colors.black45),
            )
          ],
        ),
      );
    } else {
      return Container(
        height: articles.length / 2 * 210,
        padding: EdgeInsets.all(5),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          itemCount: articles.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.85),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return NewsDetail(article: articles[index]);
                  }));
                },
                child: Container(
                  width: 220.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      boxShadow: [
                        BoxShadow(
                          color: (Colors.grey[100])!,
                          blurRadius: 5.0,
                          spreadRadius: 1.0,
                          offset: Offset(1, 1),
                        )
                      ]),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5.0),
                                  topRight: Radius.circular(5.0)),
                              image: DecorationImage(
                                  image: articles[index].img == null
                                      ? AssetImage("assets/img/placeholder.png")
                                      : NetworkImage(articles[index].img)
                                          as ImageProvider,
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 15.0, bottom: 15.0),
                        child: Text(
                          articles[index].title,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(height: 1.3, fontSize: 15.0),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            width: 180,
                            height: 1.0,
                            color: Colors.black12,
                          ),
                          Container(
                            width: 40,
                            height: 3.0,
                            color: Style.Colors.mainColor,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              articles[index].source.name,
                              style: TextStyle(
                                  color: Style.Colors.mainColor, fontSize: 9),
                            ),
                            Text(
                              timeUntil(DateTime.parse(articles[index].date)),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 9.0,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
