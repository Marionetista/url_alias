class AppMessages {
  static String urlAliasFailedToCreate(String error) =>
      'Failed to create URL alias: $error';
  static const String internetConnectionError = 'No internet connection';
  static const String httpError = 'HTTP error occurred';
  static String anErrorOccurred(String error) => 'An error occurred: $error';

  static const String close = 'Close';
  static const String writeYourFavoriteUrl = 'Write your favorite url!';
  static const String invalidUrl = 'Invalid URL';
  static const String pleaseWriteAnUrl = 'Please write an url';
  static const String shortUrlCopiedToClipboard =
      'Short URL copied to clipboard';
  static const String recentlyShortenedUrls = 'Recently shortened URLs';
  static const String aliases = 'Aliases';

  static String alias(String alias) => 'Alias: $alias';
  static String original(String original) => 'Original: $original';
  static String short(String short) => 'Short:$short';

  static String noAliasesCreatedYet =
      'No aliases created yet...\n Go on and create your shorten links!';
}
