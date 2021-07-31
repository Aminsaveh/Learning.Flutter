import 'package:bloc_newsapp/model/article_response.dart';
import 'package:bloc_newsapp/model/source_response.dart';
import 'package:dio/dio.dart';

class NewsRepository {
  static String mainUrl = 'https://newsapi.org/v2';
  final String apiKey = '5f18a4778c744b43b524e158bd3e93e5';

  final Dio _dio = Dio();

  var getSourcesUrl = '$mainUrl/sources';
  var getTopHeadLinesUrl = '$mainUrl/top-headlines';
  var everythingUrl = '$mainUrl/everything';

  Future<SourceResponse> getSources() async {
    var params = {'apikey': apiKey, 'language': 'en', 'country': 'us'};
    try {
      Response response =
          await _dio.get(getSourcesUrl, queryParameters: params);
      return SourceResponse.fromJson(response.data);
    } catch (error, stackTrace) {
      print('Error occured : $error , stackTrace : $stackTrace');
      return SourceResponse.withError(error.toString());
    }
  }

  Future<ArticleResponse> getTopHeadLines() async {
    var params = {'apikey': apiKey, 'country': 'us'};
    try {
      Response response =
          await _dio.get(getTopHeadLinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error) {
      return ArticleResponse.withError(error.toString());
    }
  }

  Future<ArticleResponse> getHotNews() async {
    var params = {'apikey': apiKey, 'sortBy': 'popularity', 'q': 'apple'};
    try {
      Response response =
          await _dio.get(everythingUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error) {
      return ArticleResponse.withError(error.toString());
    }
  }

  Future<ArticleResponse> getSourceNews(String sourceId) async {
    var params = {'apikey': apiKey, 'sources': sourceId};
    try {
      Response response =
          await _dio.get(getTopHeadLinesUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error) {
      return ArticleResponse.withError(error.toString());
    }
  }

  Future<ArticleResponse> search(String searchValue) async {
    var params = {'apikey': apiKey, 'q': searchValue, 'sortBy': 'popularity'};
    try {
      Response response =
          await _dio.get(everythingUrl, queryParameters: params);
      return ArticleResponse.fromJson(response.data);
    } catch (error) {
      return ArticleResponse.withError(error.toString());
    }
  }
}
