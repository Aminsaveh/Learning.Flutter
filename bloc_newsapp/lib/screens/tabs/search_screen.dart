import 'package:bloc_newsapp/bloc/search_bloc.dart';
import 'package:bloc_newsapp/elements/error_element.dart';
import 'package:bloc_newsapp/elements/loader_element.dart';
import 'package:bloc_newsapp/model/article.dart';
import 'package:bloc_newsapp/model/article_response.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bloc_newsapp/style/theme.dart' as style;
import 'package:timeago/timeago.dart' as timeago;

import '../news_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchBloc..search("");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextFormField(
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
            controller: _searchController,
            onChanged: (changed) {
              searchBloc..search(_searchController.text);
            },
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                filled: true,
                fillColor: Colors.grey[100]!,
                suffixIcon: _searchController.text.length > 0
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _searchController.clear();
                            searchBloc..search(_searchController.text);
                          });
                        },
                        icon: Icon(EvaIcons.backspaceOutline))
                    : Icon(
                        EvaIcons.searchOutline,
                        color: Colors.grey[500],
                        size: 16.0,
                      ),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.grey[100]!.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(30.0)),
                contentPadding: EdgeInsets.only(left: 15.0, right: 20.0),
                labelText: 'Search...',
                hintStyle: TextStyle(
                    fontSize: 14.0,
                    color: style.Colors.grey,
                    fontWeight: FontWeight.w500),
                labelStyle: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
            autocorrect: false,
            autovalidate: true,
          ),
        ),
        Expanded(
            child: StreamBuilder<ArticleResponse>(
          stream: searchBloc.subject.stream,
          builder:
              (BuildContext context, AsyncSnapshot<ArticleResponse> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.error != null &&
                  snapshot.data!.error.length > 0) {
                return Container();
              }
              return _buildSearchedNews(snapshot.data);
            } else if (snapshot.hasError) {
              return Container();
            } else {
              return buildloadingWidget();
            }
          },
        ))
      ],
    );
  }

  Widget _buildSearchedNews(ArticleResponse? data) {
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
