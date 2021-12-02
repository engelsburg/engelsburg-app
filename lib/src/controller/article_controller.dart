import 'package:engelsburg_app/src/models/api/articles.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/services/db_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArticleController {
  final int offset;
  void Function(VoidCallback fn) setStateCallback;

  ScrollController? _scrollController;
  int _page = 0;
  bool _loading = false;
  List<Article> _articles = [];

  ArticleController({this.offset = 20, required this.setStateCallback});

  ScrollController? get scrollController => _scrollController;
  List<Article> get articles => _articles;

  Future<void> init(BuildContext context) async {
    if (scrollController != null) return;
    _scrollController = ScrollController()
      ..addListener(() => _loadMore(context));

    await _request(context);
    setStateCallback(() {});
    _page++;
  }

  Future<void> _loadMore(BuildContext context) async {
    if (_loading) return;
    _loading = true;
    if (_scrollController!.position.extentAfter <= offset) {
      await _request(context);
      _page++;
    }

    setStateCallback(() {});
    _loading = false;
  }

  Future<void> refresh(BuildContext context) async {
    if (_loading) return;
    _loading = true;
    _articles.clear();
    _page = 0;
    await _request(context);

    setStateCallback(() {});
    _loading = false;
  }

  Future<void> _request(BuildContext context) async {
    (await ApiService.getArticles(context, Paging(_page, 20)))
        .handle<List<Article>>(
      context,
      parse: (json) => Articles.fromJson(json).articles,
      onSuccess: (articles) async {
        for (var newArticle in articles!) {
          final article = await DatabaseService.get<Article>(
            Article(),
            where: "articleId=?",
            whereArgs: [newArticle.articleId!],
          );

          if (article == null) {
            DatabaseService.insert(newArticle);
          } else {
            updateArticleSaved(newArticle, article.saved);
          }
        }

        _articles.insertAll(0, articles);
        _articles.sort((a1, a2) => (a1.date! > a2.date!) ? -1 : 1);
      },
      onError: (error) async {
        _articles = (await DatabaseService.getAll<Article>(
          Article(),
          orderBy: "date DESC",
        ));
        ApiService.show(
            context, AppLocalizations.of(context)!.unexpectedErrorMessage);
      },
    );
  }

  void dispose() {
    _scrollController?.dispose();
  }

  static void updateArticleSaved(Article article, bool saved) {
    DatabaseService.update(
      article.setSaved(saved),
      where: "articleId=?",
      whereArgs: [article.articleId!],
    );
  }
}
