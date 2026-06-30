class StringUtils {
  StringUtils._();

  static int wordCount(String text) {
    final normalized = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized.isEmpty) return 0;
    return normalized.split(' ').length;
  }

  static int readingTimeMinutes(String text) {
    final words = wordCount(text);
    final minutes = (words / 180).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  static String snippet(String text, {int length = 110}) {
    if (text.length <= length) return text;
    return '${text.substring(0, length).trim()}…';
  }
}
