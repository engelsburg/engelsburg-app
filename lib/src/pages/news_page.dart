import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/articles.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/services/db_service.dart';
import 'package:engelsburg_app/src/utils/html.dart';
import 'package:engelsburg_app/src/utils/random_string.dart';
import 'package:engelsburg_app/src/utils/time_ago.dart';
import 'package:engelsburg_app/src/widgets/error_box.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:octo_image/octo_image.dart';
import 'package:share_plus/share_plus.dart';

import 'post_detail_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with AutomaticKeepAliveClientMixin<NewsPage> {
  @override
  bool get wantKeepAlive => true;

  List<Widget> articles = [
    Center(
      child: CircularProgressIndicator(),
      heightFactor: 2,
    )
  ];

  int page = 0;
  bool isLoading = false;
  bool isError = false;

  //Bug: gets triggered twice onRefresh
  Future _loadArticles(bool refreshed) async {
    if (!isError && refreshed) {
      setState(() {
        articles = [
          Center(
            child: CircularProgressIndicator(),
            heightFactor: 2,
          )
        ];
        page = 0;
      });
      return;
    }
    if (isError && !refreshed) return;
    setState(() {
      isError = false;
      isLoading = true;
    });

    (await ApiService.getArticles(context, Paging(page, 20)))
        .handle<List<Article>>(
      context,
      parse: (json) => Articles.fromJson(json).articles,
      onSuccess: (articles) => {
        this.articles.insertAll(this.articles.length - 1,
            articles!.map((article) => _newsCard(article)).toList()),
      },
      onError: (error) {
        if (error.isNotFound) {
          articles.clear();
          articles.add(ErrorBox(text: 'Articles not found!'));
          setState(() {
            isError = true;
            isLoading = false;
          });
        }
      },
    );

    setState(() {
      page++;
      isLoading = false;
    });
  }

  @override
  void initState() {
    _loadArticles(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LazyLoadScrollView(
      isLoading: isLoading,
      scrollDirection: Axis.vertical,
      onEndOfPage: () => _loadArticles(false),
      child: RefreshIndicator(
        child: ListView.separated(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: articles.length,
          itemBuilder: (context, index) => articles[index],
          separatorBuilder: (context, index) => const Divider(height: 0),
        ),
        onRefresh: () => _loadArticles(true),
      ),
    );
  }

  Widget _newsCard(Article article) {
    final heroTagFeaturedMedia = RandomString.generate(16);
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: 500,
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PostDetailPage(
                    article: article,
                    heroTagFeaturedMedia: heroTagFeaturedMedia)));
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
                      tag: heroTagFeaturedMedia,
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
                              color:
                                  Theme.of(context).textTheme.caption!.color),
                        ),
                      Expanded(child: Container()),
                      IconButton(
                        constraints: const BoxConstraints(),
                        splashRadius: 24.0,
                        iconSize: 18.0,
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_outline),
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
}
