import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

Future<void> launchURL(String url) async {
  try {
    final Uri uri = Uri.parse(url);

    if (kDebugMode) {
      debugPrint('Attempting to launch URL: $url');
    }

    // Check if the URL can be launched
    if (await canLaunchUrl(uri)) {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication, // Force external browser
      );

      if (!launched) {
        throw Exception('Failed to launch URL');
      }
    } else {
      throw Exception('Cannot launch this URL on this platform');
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('Error launching URL: $e');
    }
    rethrow;
  }
}
