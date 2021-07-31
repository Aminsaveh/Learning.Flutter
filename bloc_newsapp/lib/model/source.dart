class SourceModel {
  final String id;
  final String name;
  final String description;
  final String url;
  final String category;
  final String country;
  final String language;

  SourceModel(
      {required this.name,
      required this.category,
      required this.country,
      required this.description,
      required this.id,
      required this.language,
      required this.url});

  SourceModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        url = json['url'],
        category = json['category'],
        country = json['country'],
        language = json['language'];
}
