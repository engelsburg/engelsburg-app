import 'package:cached_network_image/cached_network_image.dart';
import 'package:engelsburg_app/src/constants/app_constants.dart';
import 'package:engelsburg_app/src/models/engelsburg_api/articles.dart';
import 'package:engelsburg_app/src/utils/html.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class PostDetailPage extends StatefulWidget {
  final Article article;
  final String heroTagFeaturedMedia;
  const PostDetailPage(
      {required this.article, required this.heroTagFeaturedMedia, Key? key})
      : super(key: key);

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final _dateFormat = DateFormat('dd.MM.yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (widget.article.link != null)
            IconButton(
                tooltip: AppConstants.openInBrowser,
                onPressed: () =>
                    url_launcher.launch(widget.article.link as String),
                icon: const Icon(Icons.open_in_new)),
          if (widget.article.link != null)
            IconButton(
              tooltip: AppConstants.share,
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
                  textStyle: const TextStyle(height: 1.5, fontSize: 18.0),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
