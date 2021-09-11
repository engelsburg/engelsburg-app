import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/articles.dart';
import 'package:engelsburg_app/src/models/result.dart';
import 'package:engelsburg_app/src/services/api_service.dart';
import 'package:engelsburg_app/src/utils/html.dart';
import 'package:engelsburg_app/src/utils/random_string.dart';
import 'package:engelsburg_app/src/utils/time_ago.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Result>(
      future: ApiService.getArticles(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!.handle<List<Article>>(
              (json) => Articles.fromJson(json).articles, (error) {
            if (error.isNotFound()) {
              return ApiError.errorBox('Articles not found!');
            }
          }, (articles) {
            return ListView.separated(
                itemBuilder: (context, index) {
                  final article = articles[index];
                  return _newsCard(article);
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: 0);
                },
                itemCount: articles.length);
          });
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
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
