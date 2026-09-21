import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/news_repository.dart';
import 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository _newsRepository;

  NewsCubit({required NewsRepository newsRepository})
      : _newsRepository = newsRepository,
        super(NewsInitial());

  Future<void> fetchArticles({String category = 'all'}) async {
    emit(NewsLoading());
    try {
      final articles = await _newsRepository.fetchArticles(
        category: category == 'all' ? null : category,
      );
      emit(NewsLoaded(articles: articles, selectedCategory: category));
    } catch (e) {
      emit(NewsError('Failed to load news. Please try again.'));
    }
  }

  Future<void> searchArticles(String query) async {
    if (query.trim().isEmpty) {
      fetchArticles();
      return;
    }
    emit(NewsLoading());
    try {
      final articles = await _newsRepository.searchArticles(query.trim());
      emit(NewsLoaded(articles: articles, selectedCategory: 'search'));
    } catch (e) {
      emit(NewsError('Search failed. Please try again.'));
    }
  }
}