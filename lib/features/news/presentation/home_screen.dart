import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/app_colors.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/news_cubit.dart';
import '../cubit/news_state.dart';
import '../data/news_article.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'all',
    'general',
    'world',
    'politics',
    'sports',
    'entertainment',
    'health',
    'science',
    'ai',
    'finance',
  ];

  @override
  void initState() {
    super.initState();
    context.read<NewsCubit>().fetchArticles();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text('Eyego News', style: TextStyle(color: AppColors.textPrimary)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryFilter(),
          Expanded(child: _buildNewsList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search news...',
          hintStyle: TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
        ),
        onSubmitted: (value) {
          context.read<NewsCubit>().searchArticles(value);
        },
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        final selected = state is NewsLoaded ? state.selectedCategory : 'all';

        return SizedBox(
          height: 44,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == selected;

              return ChoiceChip(
                label: Text(
                  category[0].toUpperCase() + category.substring(1),
                ),
                selected: isSelected,
                onSelected: (_) {
                  _searchController.clear();
                  context.read<NewsCubit>().fetchArticles(category: category);
                },
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNewsList() {
    return BlocBuilder<NewsCubit, NewsState>(
      builder: (context, state) {
        if (state is NewsLoading) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (state is NewsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message, style: TextStyle(color: AppColors.textPrimary)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context.read<NewsCubit>().fetchArticles(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is NewsLoaded) {
          if (state.articles.isEmpty) {
            return Center(
              child: Text(
                'No articles found',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.articles.length,
            itemBuilder: (context, index) {
              return _NewsCard(article: state.articles[index]);
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsArticle article;

  const _NewsCard({required this.article});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(article: article),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl != null)
              CachedNetworkImage(
                imageUrl: article.imageUrl!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  color: AppColors.background,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: AppColors.background,
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.headline,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.description,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        article.source,
                        style: TextStyle(color: AppColors.primary, fontSize: 12),
                      ),
                      const Spacer(),
                      Text(
                        '${article.publishedAt.hour}:${article.publishedAt.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}