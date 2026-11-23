import 'package:url_launcher/url_launcher.dart';

/// Launches an external URI, returning false if it cannot be opened.
Future<bool> openExternal(Uri uri) async {
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
