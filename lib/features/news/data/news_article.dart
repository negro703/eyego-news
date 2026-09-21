class NewsArticle {
  final String id;
  final String headline;
  final String description;
  final String? imageUrl;
  final String source;
  final String category;
  final DateTime publishedAt;
  final String url;

  NewsArticle({
    required this.id,
    required this.headline,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.category,
    required this.publishedAt,
    required this.url,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      headline: json['headline'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      source: json['source'] as String,
      category: json['category'] as String,
      publishedAt: DateTime.parse(json['published_at'] as String),
      url: json['url'] as String,
    );
  }
}