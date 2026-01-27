import 'package:web/web.dart' as html;

/// Service to parse URL parameters and path segments
class UrlService {
  /// Get the wedding ID from the URL path
  /// Example: mingalaroo.com/12 -> returns "12"
  static String? getWeddingId() {
    final uri = Uri.parse(html.window.location.href);
    final path = uri.path;

    // Remove leading and trailing slashes, then split
    final cleanPath = path.replaceAll(RegExp(r'^/|/$'), '');

    if (cleanPath.isEmpty) {
      return null;
    }

    // Get the first path segment
    final segments = cleanPath.split('/');
    final firstSegment = segments.first.trim();

    return firstSegment.isNotEmpty ? firstSegment : null;
  }

  /// Get the invited user name from URL query parameters
  /// Example: mingalaroo.com/12?kyaw%20kyaw -> returns "kyaw kyaw"
  /// Example: mingalaroo.com/12?kyaw -> returns "kyaw"
  /// The query parameter name can be anything, we'll use the first one
  static List<String> getInvitedUserName() {
    // Get the raw search string from the browser (includes the '?' if present)
    final search = html.window.location.search;

    if (search.isEmpty) {
      return [];
    }
    // Remove the leading '?' if present
    final queryString = search.startsWith('?') ? search.substring(1) : search;

    if (queryString.isEmpty) {
      return [];
    }

    // Try parsing as standard query parameters first (key=value format)
    final uri = Uri.parse(html.window.location.href);
    final queryParams = uri.queryParameters;

    if (queryParams.isNotEmpty) {
      // Get the first query parameter value
      final firstValue = queryParams['guest'] ?? "Guest";
      // URL decode it (handles %20 -> space, etc.)
      final decoded = Uri.decodeComponent(firstValue);
      // Replace hyphens with spaces and capitalize each word
      final words = decoded
          .replaceAll('-', ' ')
          .split(' ')
          .where((word) => word.isNotEmpty)
          .map(
            (word) => word.isEmpty
                ? word
                : word[0].toUpperCase() + word.substring(1).toLowerCase(),
          )
          .join(' ');

      final originalName = decoded
          .replaceAll('-', ' ')
          .split(' ')
          .where((word) => word.isNotEmpty)
          .map(
            (word) =>
                word.isEmpty ? word : word[0] + word.substring(1).toLowerCase(),
          )
          .join(' ');

      return [
        words,
        originalName,
      ];
    }

    return [];
  }

  /// Get both wedding ID and invited user name
  static Map<String, String?> getUrlData() {
    final invitedNames = getInvitedUserName();
    return {
      'weddingId': getWeddingId(),
      'invitedUserName': invitedNames.isNotEmpty ? invitedNames[0] : null,
      'originalName': invitedNames.length > 1 ? invitedNames[1] : null,
    };
  }
}
