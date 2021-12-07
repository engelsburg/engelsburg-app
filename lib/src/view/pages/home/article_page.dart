import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/src/controller/article_controller.dart';
import 'package:engelsburg_app/src/models/api/articles.dart';
import 'package:engelsburg_app/src/utils/html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:octo_image/octo_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class ArticlePage extends StatefulWidget {
  final Article article;
  final String heroTagFeaturedMedia;
  const ArticlePage(
      {required this.article, required this.heroTagFeaturedMedia, Key? key})
      : super(key: key);

  @override
  _ArticlePageState createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  final _dateFormat = DateFormat('dd.MM.yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, widget.article.saved);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  ArticleController.updateArticleSaved(
                      context, widget.article, !widget.article.saved, true);
                });
              },
              icon: Icon(
                widget.article.saved
                    ? Icons.bookmark_outlined
                    : Icons.bookmark_border_outlined,
              ),
            ),
            if (widget.article.link != null)
              IconButton(
                  tooltip: AppLocalizations.of(context)!.openInBrowser,
                  onPressed: () =>
                      url_launcher.launch(widget.article.link as String),
                  icon: const Icon(Icons.open_in_new)),
            if (widget.article.link != null)
              IconButton(
                tooltip: AppLocalizations.of(context)!.share,
                onPressed: () {
                  Share.share(widget.article.link as String);
                },
                icon: const Icon(Icons.share),
              )
          ],
        ),
        body: ListView(
          children: [
            if (widget.article.mediaUrl != null)
              Hero(
                tag: widget.heroTagFeaturedMedia,
                child: CachedNetworkImage(
                    height: 250,
                    fit: BoxFit.cover,
                    imageUrl: widget.article.mediaUrl as String),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    HtmlUtil.unescape((widget.article.title).toString()),
                    style: const TextStyle(
                        fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                  if (widget.article.date != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 32.0),
                      child: Text(_dateFormat.format(
                          DateTime.fromMillisecondsSinceEpoch(
                              widget.article.date as int))),
                    ),
                  const Divider(height: 32.0),
                  HtmlWidget(
                    (widget.article.content).toString(),
                    webView: true,
                    webViewJs: true,
                    onTapUrl: (url) => url_launcher.launch(url),
                    onTapImage: (meta) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              insetPadding: const EdgeInsets.all(15),
                              backgroundColor: Colors.transparent,
                              child: Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: double.infinity,
                                    height: 500,
                                    child: OctoImage(
                                      image: CachedNetworkImageProvider(
                                          meta.sources.first.url),
                                      placeholderBuilder: meta.alt != null
                                          ? OctoPlaceholder.blurHash(
                                              meta.alt as String)
                                          : null,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    textStyle: const TextStyle(height: 1.5, fontSize: 18.0),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
