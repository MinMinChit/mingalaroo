import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://aexphrsxtzpiltwjhcdt.supabase.co';
  static const String supabaseAnonKey =
      'sb_publishable_1nIgoLuQc7H7Y2KyNZYByA_0SLziKHE';

  static SupabaseClient? _client;

  /// Initialize Supabase client
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  /// Get Supabase client instance
  static SupabaseClient get client {
    if (_client == null) {
      throw Exception(
        'Supabase not initialized. Call SupabaseService.initialize() first.',
      );
    }
    return _client!;
  }

  /// Update RSVP attendance state
  ///
  /// [generatedLink] - The generated link (e.g., "mingalaroo.com/12/guest-name")
  /// [guestName] - The guest name to verify
  /// [attendanceState] - Either 'attending' or 'not_attending'
  /// [guestCount] - Guest count (default: "0")
  static Future<Map<String, dynamic>?> updateRSVP({
    required String guestName,
    required String attendanceState,
    String guestCount = '0',
  }) async {
    try {
      // Decode URL-encoded guest name
      // First replace '+' with spaces (URL encoding uses + for spaces in query strings)
      // Then decode percent-encoded characters (handles %20 -> space, etc.)
      final decodedGuestName = Uri.decodeComponent(
        guestName.replaceAll('+', ' '),
      );

      print(decodedGuestName);

      final response = await client
          .from('invited_users')
          .update({
            'attendance_state': attendanceState,
            'guest_count': guestCount,
          })
          .eq('guest_name', decodedGuestName)
          .select()
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error updating RSVP: $e');
      rethrow;
    }
  }
}
