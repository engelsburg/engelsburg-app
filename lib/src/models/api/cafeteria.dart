class Cafeteria {
  Cafeteria({
    this.content,
    this.link,
    this.mediaUrl,
    this.blurHash,
  });

  final String? content;
  final String? link;
  final String? mediaUrl;
  final String? blurHash;

  factory Cafeteria.fromJson(Map<String, dynamic> json) => Cafeteria(
        content: json["content"],
        link: json["link"],
        mediaUrl: json["mediaURL"],
        blurHash: json["blurHash"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "link": link,
        "mediaURL": mediaUrl,
        "blurHash": blurHash,
      };
}
