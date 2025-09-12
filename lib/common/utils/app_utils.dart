class AppUtils {
  static bool isValidUrl(String text) {
    final uri = Uri.tryParse(text);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }
}
