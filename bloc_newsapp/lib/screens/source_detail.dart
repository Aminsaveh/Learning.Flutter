import 'package:bloc_newsapp/bloc/get_source_news_bloc.dart';
import 'package:bloc_newsapp/elements/error_element.dart';
import 'package:bloc_newsapp/elements/loader_element.dart';
import 'package:bloc_newsapp/model/article.dart';
import 'package:bloc_newsapp/model/article_response.dart';
import 'package:bloc_newsapp/model/source.dart';
import 'package:bloc_newsapp/screens/news_detail.dart';
import 'package:flutter/material.dart';
import 'package:bloc_newsapp/style/theme.dart' as style;
import 'package:timeago/timeago.dart' as timeago;

class SourceDetail extends StatefulWidget {
  final SourceModel source;
  const SourceDetail({Key? key, required this.source}) : super(key: key);

  @override
  _SourceDetailState createState() => _SourceDetailState(source);
}

class _SourceDetailState extends State<SourceDetail> {
  final SourceModel source;
  _SourceDetailState(this.source);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSourceNewsBloc..getSourceNews(source.id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    getSourceNewsBloc..drainStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          elevation: 0.0,
          backgroundColor: style.Colors.mainColor,
          title: Text(""),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
            color: style.Colors.mainColor,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Hero(
                  tag: source.id,
                  child: SizedBox(
                    height: 80.0,
                    width: 80.0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2.0, color: Colors.white),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/logos/${source.id}.png'),
                              fit: BoxFit.cover)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  source.description,
                  style: TextStyle(color: Colors.white, fontSize: 12.0),
                )
              ],
            ),
          ),
          Expanded(
              child: StreamBuilder<ArticleResponse>(
            stream:
                getSourceNewsBloc.subject.stream as Stream<ArticleResponse>?,
            builder: (BuildContext context,
                AsyncSnapshot<ArticleResponse> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.error != null &&
                    snapshot.data!.error.length > 0) {
                  return buildErrorWidget(snapshot.data!.error);
                }
                return _buildSourceNews(snapshot.data);
              } else if (snapshot.hasError) {
                return buildErrorWidget(snapshot.data!.error);
              } else {
                return buildloadingWidget();
              }
            },
          ))
        ],
      ),
    );
  }

  Widget _buildSourceNews(ArticleResponse? data) {
    List<ArticleModel>? articles = data!.articles;
    if (articles!.length == 0) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [Text('No Articles!')],
        ),
      );
    } else {
      return ListView.builder(
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewsDetail(article: articles[index]);
              }));
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey[200]!, width: 1.0)),
                  color: Colors.white),
              height: 150.0,
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.0),
                    width: MediaQuery.of(context).size.width * 3 / 5,
                    child: Column(
                      children: [
                        Text(
                          articles[index].title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 14.0),
                        ),
                        Expanded(
                            child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            children: [
                              Text(
                                timeUntil(DateTime.parse(articles[index].date)),
                                style: TextStyle(
                                    color: Colors.black26,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0),
                              ),
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    width: MediaQuery.of(context).size.width * 2 / 5,
                    height: 130.0,
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/img/placeholder.png",
                      image: articles[index].img,
                      fit: BoxFit.fitHeight,
                      width: double.maxFinite,
                      height: MediaQuery.of(context).size.height * 1 / 3,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

  String timeUntil(DateTime date) {
    return timeago.format(date, allowFromNow: true, locale: 'en');
  }
}
