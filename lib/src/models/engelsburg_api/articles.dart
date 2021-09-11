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
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };
}

class Article {
  Article({
    this.date,
    this.link,
    this.title,
    this.content,
    this.mediaUrl,
    this.blurHash,
  });

  final int? date;
  final String? link;
  final String? title;
  final String? content;
  final String? mediaUrl;
  final String? blurHash;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        date: json["date"],
        link: json["link"],
        title: json["title"],
        content: json["content"],
        mediaUrl: json["mediaUrl"],
        blurHash: json['blurHash'],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "link": link,
        "title": title,
        "content": content,
        "mediaUrl": mediaUrl,
        "blurHash": blurHash,
      };
}
