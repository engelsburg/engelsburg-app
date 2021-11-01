import 'dart:collection';

import 'package:engelsburg_app/src/models/engelsburg_api/articles.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/services/db_service.dart';
import 'package:engelsburg_app/src/widgets/article_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin<NewsPage> {
  @override
  bool get wantKeepAlive => true;

  List<Article> articles = [];

  int page = 0;
  bool isLoading = false;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    _loadArticles(false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Stack(
      children: [
        LazyLoadScrollView(
          isLoading: isLoading,
          scrollDirection: Axis.vertical,
          onEndOfPage: () => _loadArticles(false),
          child: RefreshIndicator(
            child: ListView.separated(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: articles.length + 1,
              itemBuilder: (context, index) {
                if (index == articles.length) {
                  return const Center(
                    child: CircularProgressIndicator(),
                    heightFactor: 2,
                  );
                }

                return ArticleCard(
                    article: articles[index],
                    onSavedPressed: _onSavedPressed,
                    afterPop: (saved) {
                      setState(() {
                        articles[index].saved = saved;
                      });
                    });
              },
              separatorBuilder: (context, index) => const Divider(height: 0),
            ),
            onRefresh: () => _loadArticles(true),
          ),
        ),
        Positioned(
          child: FloatingActionButton(
            onPressed: () async {
              final unsavedArticles =
                  await Navigator.pushNamed(context, "/savedArticles");
              if (unsavedArticles is Set<int>) {
                setState(() {
                  for (var article in articles) {
                    if (unsavedArticles.contains(article.articleId)) {
                      article.saved = false;
                    }
                  }
                });
              }
            },
            child: const Icon(Icons.bookmark_outlined),
          ),
          bottom: 20,
          right: 20,
        ),
      ],
    );
  }

  void _onSavedPressed(Article article) {
    updateArticleSaved(article, !article.saved);
    setState(() {});
  }

  //Bug: gets triggered twice onRefresh
  Future _loadArticles(bool refreshed) async {
    if (isError && !refreshed) return; //On list end but there was an error
    setState(() => isLoading = true);
    isError = false;
    if (refreshed) {
      articles.clear();
      page = 0;
    }

    await _getArticles();

    page++;
    setState(() => isLoading = false);
  }

  Future _getArticles() async {
    (await ApiService.getArticles(context, Paging(page, 20)))
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
            DatabaseService.update(
              newArticle.setSaved(article.saved),
              where: "articleId=?",
              whereArgs: [article.articleId!],
            );
          }
        }

        this.articles.insertAll(
            this.articles.isEmpty ? 0 : this.articles.length - 1, articles);
      },
      onError: (error) async {
        articles = (await DatabaseService.getAll<Article>(
          Article(),
          orderBy: "date DESC",
        ));
        ApiService.show(
            context, AppLocalizations.of(context)!.unexpectedErrorMessage);
        isLoading = false;
        setState(() => isError = true);
      },
    );
  }
}

class SavedArticlesPage extends StatefulWidget {
  const SavedArticlesPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SavedArticlePageState();
}

class _SavedArticlePageState extends State<SavedArticlesPage> with RouteAware {
  Set<int> unsavedArticles = HashSet();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, unsavedArticles);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.savedArticles),
        ),
        body: FutureBuilder(
            future: DatabaseService.getAll<Article>(
              Article(),
              where: "saved=?",
              orderBy: "date DESC",
              whereArgs: [1],
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List<Article>;

                if (data.isEmpty) {
                  return Align(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        AppLocalizations.of(context)!.noArticlesSaved,
                        textScaleFactor: 1.2,
                        style: TextStyle(
                          color: DefaultTextStyle.of(context)
                              .style
                              .color!
                              .withOpacity(3 / 4),
                        ),
                      ),
                    ),
                    alignment: Alignment.topCenter,
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) => ArticleCard(
                    article: data[index],
                    onSavedPressed: (article) {
                      data.remove(article);
                      updateArticleSaved(article, false);
                      unsavedArticles.add(article.articleId!);
                      setState(() {});
                    },
                    afterPop: (saved) {
                      if (!saved) setState(() => data.remove(data[index]));
                    },
                  ),
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

void updateArticleSaved(Article article, bool saved) {
  DatabaseService.update(
    article.setSaved(saved),
    where: "articleId=?",
    whereArgs: [article.articleId!],
  );
}
