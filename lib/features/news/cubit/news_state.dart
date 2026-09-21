import 'package:equatable/equatable.dart';
import '../data/news_article.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;
  final String selectedCategory;

  const NewsLoaded({
    required this.articles,
    this.selectedCategory = 'all',
  });

  @override
  List<Object?> get props => [articles, selectedCategory];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object?> get props => [message];
}