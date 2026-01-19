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
  static String? getInvitedUserName() {
    // Get the raw search string from the browser (includes the '?' if present)
    final search = html.window.location.search;

    if (search.isEmpty) {
      return null;
    }

    print('search: $search');

    // Remove the leading '?' if present
    final queryString = search.startsWith('?') ? search.substring(1) : search;

    if (queryString.isEmpty) {
      return null;
    }

    // Try parsing as standard query parameters first (key=value format)
    final uri = Uri.parse(html.window.location.href);
    final queryParams = uri.queryParameters;
    print('queryParams: $queryParams');

    if (queryParams.isNotEmpty) {
      // Get the first query parameter value
      final firstValue = queryParams.values.first;
      // URL decode it (handles %20 -> space, etc.)
      return Uri.decodeComponent(firstValue);
    }

    // If no key=value format, treat the entire query string as the value
    // This handles cases like "?kyaw" or "?kyaw%20kyaw"
    if (queryString.contains('=')) {
      // Has '=' but wasn't in queryParameters, try to parse manually
      final parts = queryString.split('=');
      if (parts.length > 1) {
        return Uri.decodeComponent(parts[1]);
      }
    } else {
      // No '=' sign, treat the whole query string as the value
      return Uri.decodeComponent(queryString);
    }

    return null;
  }

  /// Get both wedding ID and invited user name
  static Map<String, String?> getUrlData() {
    return {
      'weddingId': getWeddingId(),
      'invitedUserName': getInvitedUserName(),
    };
  }
}
