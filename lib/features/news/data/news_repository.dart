import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_article.dart';

class NewsRepository {
  static const String _baseUrl = 'https://noozra.com/api/articles';

  Future<List<NewsArticle>> fetchArticles({
    String? category,
    int limit = 30,
  }) async {
    final uri = Uri.parse(_baseUrl).replace(
      queryParameters: {
        'limit': limit.toString(),
        if (category != null && category != 'all') 'category': category,
      },
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> articlesJson = data['articles'];
      return articlesJson
          .map((json) => NewsArticle.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load articles (${response.statusCode})');
    }
  }

  Future<List<NewsArticle>> searchArticles(String query) async {
    final uri = Uri.parse('https://noozra.com/api/search').replace(
      queryParameters: {'q': query},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> articlesJson = data['articles'];
      return articlesJson
          .map((json) => NewsArticle.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to search articles (${response.statusCode})');
    }
  }
}