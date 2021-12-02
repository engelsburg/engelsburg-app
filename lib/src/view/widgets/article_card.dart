import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/src/models/api/articles.dart';
import 'package:engelsburg_app/src/utils/html.dart';
import 'package:engelsburg_app/src/utils/string_utils.dart';
import 'package:engelsburg_app/src/utils/time_ago.dart';
import 'package:engelsburg_app/src/view/pages/home/article_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:share_plus/share_plus.dart';

class ArticleCard extends StatefulWidget {
  final Article article;
  final Function(Article article) onSavedPressed;
  final Function(bool saved)? afterPop;

  const ArticleCard(
      {Key? key,
      required this.article,
      required this.onSavedPressed,
      this.afterPop})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _ArticleCardState();
}

class _ArticleCardState extends State<ArticleCard> {
  @override
  Widget build(BuildContext context) {
    final newsCardId = StringUtils.random(16);

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
                        article: widget.article,
                        heroTagFeaturedMedia: newsCardId)));
            if (saved is bool && widget.afterPop != null) {
              widget.afterPop!(saved);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.article.mediaUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Hero(
                      tag: newsCardId,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: OctoImage(
                          image: CachedNetworkImageProvider(
                              widget.article.mediaUrl as String),
                          placeholderBuilder: widget.article.blurHash != null
                              ? OctoPlaceholder.blurHash(
                                  widget.article.blurHash as String,
                                )
                              : null,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                Text(
                  HtmlUtil.unescape(widget.article.title.toString()),
                  style: const TextStyle(fontSize: 20.0),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.article.date != null)
                        Text(
                          TimeAgo.fromDate(DateTime.fromMillisecondsSinceEpoch(
                              widget.article.date as int)),
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.caption!.color),
                        ),
                      Expanded(child: Container()),
                      IconButton(
                        constraints: const BoxConstraints(),
                        splashRadius: 24.0,
                        iconSize: 18.0,
                        onPressed: () => widget.onSavedPressed(widget.article),
                        icon: Icon(widget.article.saved
                            ? Icons.bookmark_outlined
                            : Icons.bookmark_border_outlined),
                        padding: EdgeInsets.zero,
                      ),
                      if (widget.article.link != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 24.0),
                          child: IconButton(
                            constraints: const BoxConstraints(),
                            splashRadius: 24.0,
                            iconSize: 18.0,
                            onPressed: () {
                              Share.share(widget.article.link as String);
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
