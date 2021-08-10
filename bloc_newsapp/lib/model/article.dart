import 'package:bloc_newsapp/model/source.dart';

class ArticleModel {
  final SourceModel source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String img;
  final String date;
  final String content;

  ArticleModel(
      {required this.source,
      required this.author,
      required this.title,
      required this.content,
      required this.date,
      required this.description,
      required this.img,
      required this.url});
  ArticleModel.fromJson(Map<String, dynamic> json)
      : source = SourceModel.fromJson(json['source']),
        author = json["author"] == null ? '' : json["author"],
        title = json["title"] == null ? '' : json["title"],
        description = json["description"] == null ? '' : json["description"],
        url = json["url"] == null ? '' : json["url"],
        img = json["urlToImage"] == null ? '' : json["urlToImage"],
        date = json["publishedAt"] == null ? '' : json["publishedAt"],
        content = json["content"] == null ? '' : json["content"];
}
