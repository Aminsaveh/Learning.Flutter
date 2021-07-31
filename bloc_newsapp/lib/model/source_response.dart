import 'package:bloc_newsapp/model/source.dart';

class SourceResponse {
  final List<SourceModel> sources;
  final String error;

  SourceResponse({required this.error, required this.sources});
  SourceResponse.fromJson(Map<String, dynamic> json)
      : sources = (json["sources"] as List)
            .map((i) => new SourceModel.fromJson(i))
            .toList(),
        error = "";

  SourceResponse.withError(String errorValue)
      : sources = [],
        error = errorValue;
}
