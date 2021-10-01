import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/articles.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/services/db_service.dart';
import 'package:engelsburg_app/src/utils/html.dart';
import 'package:engelsburg_app/src/utils/random_string.dart';
import 'package:engelsburg_app/src/utils/time_ago.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:octo_image/octo_image.dart';
import 'package:share_plus/share_plus.dart';

import 'article_page.dart';

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
              physics: BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: articles.length + 1,
              itemBuilder: (context, index) {
                if (index == articles.length) {
                  return Center(
                    child: CircularProgressIndicator(),
                    heightFactor: 2,
                  );
                }

                return _articleCard(
                    context: context,
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
                  articles.forEach((article) {
                    if (unsavedArticles.contains(article.articleId))
                      article.saved = false;
                  });
                });
              }
            },
            child: Icon(Icons.bookmark_outlined),
          ),
          bottom: 20,
          right: 20,
        ),
      ],
    );
  }

  void _onSavedPressed(Article article) {
    setSaved(article, !article.saved);
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
      onSuccess: (articles) {
        articles!.forEach((newArticle) async {
          final article = (await DatabaseService.get<Article>(
            Article(),
            where: "articleId=?",
            whereArgs: [newArticle.articleId!],
          ));
          if (article == null) {
            DatabaseService.insert(newArticle);
          } else {
            DatabaseService.update(
              newArticle.setSaved(article.saved),
              where: "articleId=?",
              whereArgs: [article.articleId!],
            );
          }
        });
        this.articles.insertAll(
            this.articles.length == 0 ? 0 : this.articles.length - 1, articles);
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
                      padding: EdgeInsets.only(top: 30),
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
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemCount: data.length,
                  itemBuilder: (context, index) => _articleCard(
                    context: context,
                    article: data[index],
                    onSavedPressed: (article) {
                      data.remove(article);
                      setSaved(article, false);
                      unsavedArticles.add(article.articleId!);
                      setState(() {});
                    },
                  ),
                  separatorBuilder: (context, index) =>
                      const Divider(height: 0),
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}

void setSaved(Article article, bool saved) {
  DatabaseService.update(
    article.setSaved(saved),
    where: "articleId=?",
    whereArgs: [article.articleId!],
  );
}

Widget _articleCard({
  required BuildContext context,
  required Article article,
  required void Function(Article article) onSavedPressed,
  void Function(bool saved)? afterPop,
}) {
  final newsCardId = RandomString.generate(16);

  return Align(
    alignment: Alignment.topCenter,
    child: SizedBox(
      width: 500,
      child: InkWell(
        onTap: () async {
          final saved = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ArticlePage(
                      article: article, heroTagFeaturedMedia: newsCardId)));
          if (saved is bool && afterPop != null) afterPop(saved);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (article.mediaUrl != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Hero(
                    tag: newsCardId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: OctoImage(
                        image: CachedNetworkImageProvider(
                            article.mediaUrl as String),
                        placeholderBuilder: article.blurHash != null
                            ? OctoPlaceholder.blurHash(
                                article.blurHash as String,
                              )
                            : null,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              Text(
                HtmlUtil.unescape(article.title.toString()),
                style: const TextStyle(fontSize: 20.0),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (article.date != null)
                      Text(
                        TimeAgo.fromDate(DateTime.fromMillisecondsSinceEpoch(
                            article.date as int)),
                        style: TextStyle(
                            color: Theme.of(context).textTheme.caption!.color),
                      ),
                    Expanded(child: Container()),
                    IconButton(
                      constraints: const BoxConstraints(),
                      splashRadius: 24.0,
                      iconSize: 18.0,
                      onPressed: () => onSavedPressed(article),
                      icon: Icon(article.saved
                          ? Icons.bookmark_outlined
                          : Icons.bookmark_border_outlined),
                      padding: EdgeInsets.zero,
                    ),
                    if (article.link != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 24.0),
                        child: IconButton(
                          constraints: const BoxConstraints(),
                          splashRadius: 24.0,
                          iconSize: 18.0,
                          onPressed: () {
                            Share.share(article.link as String);
                          },
                          icon: const Icon(Icons.share_outlined),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
