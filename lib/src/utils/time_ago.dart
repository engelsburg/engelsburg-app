class TimeAgo {
  static String fromDate(DateTime date) {
    final currentDate = DateTime.now();
    final difference = currentDate.difference(date);

    if ((difference.inDays / 365).floor() >= 2) {
      return 'vor ${(difference.inDays / 365).floor()} Jahren';
    } else if ((difference.inDays / 365).floor() >= 1) {
      return 'vor 1 Jahr';
    } else if ((difference.inDays / 30).floor() >= 2) {
      return 'vor ${(difference.inDays / 30).floor()} Monaten';
    } else if ((difference.inDays / 30).floor() >= 1) {
      return 'vor 1 Monat';
    } else if ((difference.inDays / 7).floor() >= 2) {
      return 'vor ${(difference.inDays / 7).floor()} Wochen';
    } else if ((difference.inDays / 7).floor() >= 1) {
      return 'vor 1 Woche';
    } else if (difference.inDays >= 2) {
      return 'vor ${difference.inDays} Tagen';
    } else if (difference.inDays >= 1) {
      return 'vor 1 Tag';
    } else if (difference.inHours >= 2) {
      return 'vor ${difference.inHours} Stunden';
    } else if (difference.inHours >= 1) {
      return 'vor 1 Stunde';
    } else if (difference.inMinutes >= 2) {
      return 'vor ${difference.inMinutes} Minuten';
    } else if (difference.inMinutes >= 1) {
      return 'vor 1 Minute';
    } else if (difference.inSeconds >= 2) {
      return 'vor ${difference.inSeconds} Sekunden';
    } else {
      return 'vor 1 Sekunde';
    }
  }
}
