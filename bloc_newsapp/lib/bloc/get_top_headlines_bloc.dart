import 'package:bloc_newsapp/model/article.dart';
import 'package:bloc_newsapp/model/article_response.dart';
import 'package:bloc_newsapp/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class GetTopHeadlinesBloc {
  final NewsRepository _repository = NewsRepository();
  final BehaviorSubject<ArticleResponse> _subject =
      BehaviorSubject<ArticleResponse>();
  getHeadlines() async {
    ArticleResponse response = await _repository.getTopHeadLines();
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ArticleResponse> get subject => _subject;
}

final GetTopHeadlinesBloc getTopHeadlinesBloc = GetTopHeadlinesBloc();
