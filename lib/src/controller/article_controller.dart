import 'package:engelsburg_app/src/models/api/articles.dart';
import 'package:engelsburg_app/src/models/provider/auth.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/services/db_service.dart';
import 'package:engelsburg_app/src/services/delayed_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ArticleController {
  final int offset;
  void Function(VoidCallback fn) setStateCallback;

  ScrollController? _scrollController;
  int _page = 0;
  bool _loading = false;
  bool _toLoad = true;
  List<Article> _articles = [];

  ArticleController({this.offset = 20, required this.setStateCallback});

  ScrollController? get scrollController => _scrollController;
  List<Article> get articles => _articles;
  set builtAllArticles(bool value) =>
      _loading = !value; //Set to true after all articles are built

  Future<void> init(BuildContext context) async {
    if (scrollController != null) return;
    _scrollController = ScrollController()
      ..addListener(() => _loadMore(context));

    await _request(context);

    _page++;
    setStateCallback(() {});
  }

  Future<void> _loadMore(BuildContext context) async {
    if (_loading) return; //Is already loading
    if (!_toLoad) return; //No more articles
    _loading = true;
    if (_scrollController!.position.extentAfter <= offset) {
      await _request(context);
      _page++;
    }

    setStateCallback(() {});
  }

  Future<void> refresh(BuildContext context) async {
    _articles.clear();
    setStateCallback(() {});
    _page = 0;
    await _request(context);

    setStateCallback(() {});
  }

  Future<void> _request(BuildContext context) async {
    await (await ApiService.getArticles(context, Paging(_page, 20)))
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
            updateArticleSaved(context, newArticle, article.saved, false);
          }
        }

        articles.removeWhere((element) => _articles.contains(element));
        _articles.addAll(articles);
        _articles.sort((a1, a2) => (a1.date! > a2.date!) ? -1 : 1);
      },
      onError: (error) async {
        if (error.isNotFound && error.extra == "article") {
          _toLoad = false;
          return;
        }

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

  static void updateArticleSaved(
      BuildContext context, Article article, bool saved, bool updateToServer) {
    DatabaseService.update(
      article.setSaved(saved),
      where: "articleId=?",
      whereArgs: [article.articleId!],
    );
    if (updateToServer && context.read<AuthModel>().isVerified) {
      DelayedRequests.add("saved_article_" + article.articleId.toString(),
          () => ApiService.saveArticle(article.articleId!, saved));
    }
  }
}
