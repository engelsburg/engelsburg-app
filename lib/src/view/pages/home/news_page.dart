import 'dart:collection';

import 'package:engelsburg_app/src/controller/article_controller.dart';
import 'package:engelsburg_app/src/models/api/articles.dart';
import 'package:engelsburg_app/src/services/db_service.dart';
import 'package:engelsburg_app/src/view/widgets/article_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin<NewsPage> {
  @override
  bool get wantKeepAlive => true;
  late final ArticleController articleController;

  @override
  void initState() {
    super.initState();
    articleController = ArticleController(
      setStateCallback: setState,
      offset: 150,
    );
    articleController.init(context);
  }

  @override
  void dispose() {
    super.dispose();
    articleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var articles = articleController.articles;

    return Stack(
      children: [
        RefreshIndicator(
          child: ListView.separated(
            controller: articleController.scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              if (articles.length - 1 == index) {
                articleController.builtAllArticles = true;
              }
              return ArticleCard(
                  article: articles[index],
                  onSavedPressed: (article) {
                    ArticleController.updateArticleSaved(
                        context, article, !article.saved, true);
                    setState(() {});
                  },
                  afterPop: (saved) {
                    articles[index].saved = saved;
                    setState(() {});
                  });
            },
            separatorBuilder: (context, index) => const Divider(height: 0),
          ),
          onRefresh: () async {
            await articleController.refresh(context);
          },
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
                      ArticleController.updateArticleSaved(
                          context, article, false, true);
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
