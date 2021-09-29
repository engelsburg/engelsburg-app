import 'package:engelsburg_app/src/services/db_service.dart';

class Articles {
  Articles({
    this.articles = const [],
  });

  final List<Article> articles;

  factory Articles.fromJson(Map<String, dynamic> json) => Articles(
        articles: json["articles"] == null
            ? []
            : List<Article>.from(
                json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "articles": List<dynamic>.from(articles.map((x) => x.toMap())),
      };
}

class Article implements DatabaseModel {
  Article({
    this.articleId,
    this.date,
    this.link,
    this.title,
    this.content,
    this.contentHash,
    this.mediaUrl,
    this.blurHash,
    this.saved = false,
  });

  final int? articleId;
  final int? date;
  final String? link;
  final String? title;
  final String? content;
  final String? contentHash;
  final String? mediaUrl;
  final String? blurHash;
  bool saved;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
      articleId: json["articleId"],
      date: json["date"],
      link: json["link"],
      title: json["title"],
      content: json["content"],
      contentHash: json["contentHash"],
      mediaUrl: json["mediaUrl"],
      blurHash: json['blurHash'],
      saved: json["saved"] == 1);

  Map<String, dynamic> toMap() => {
        "articleId": articleId,
        "date": date,
        "link": link,
        "title": title,
        "content": content,
        "contentHash": contentHash,
        "mediaUrl": mediaUrl,
        "blurHash": blurHash,
        "saved": saved ? 1 : 0, //Sqflite doesn't support bool
      };

  Article setSaved(bool saved) {
    this.saved = saved;

    return this;
  }

  @override
  String tableName() {
    return "articles";
  }

  @override
  DatabaseModel parse(Map<String, dynamic> json) {
    return Article.fromJson(json);
  }
}
