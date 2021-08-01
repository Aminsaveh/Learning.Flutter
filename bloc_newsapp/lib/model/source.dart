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
      : id = json['id'] == null ? '' : json['id'],
        name = json['name'] == null ? '' : json['name'],
        description = json['description'] == null ? '' : json['description'],
        url = json['url'] == null ? '' : json['url'],
        category = json['category'] == null ? '' : json['category'],
        country = json['country'] == null ? '' : json['country'],
        language = json['language'] == null ? '' : json['language'];
}
