class ArticleModel {
  final String author;
  final String title;
  final String description;
  final String url;
  final String img;
  final String date;
  final String content;

  ArticleModel(
      {required this.author,
      required this.title,
      required this.content,
      required this.date,
      required this.description,
      required this.img,
      required this.url});
  ArticleModel.fromJson(Map<String, dynamic> json)
      : author = json["author"],
        title = json["title"],
        description = json["description"],
        url = json["url"],
        img = json["utlToImage"],
        date = json["publishedAt"],
        content = json["content"];
}
