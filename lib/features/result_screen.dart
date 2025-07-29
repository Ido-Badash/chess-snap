import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chess_snap/core/utils/launch_url.dart';

class ResultScreen extends StatelessWidget {
  final String fen;

  const ResultScreen({super.key, required this.fen});

  @override
  Widget build(BuildContext context) {
    final String lichessUrl = "https://lichess.org/editor/$fen";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chess Position Detected"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success icon
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),

            // Success message
            const Text(
              "Chess position successfully detected!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // FEN display
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "FEN String:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    fen,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => _copyToClipboard(context, fen),
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text("Copy"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Action buttons
            Column(
              children: [
                // Open in Lichess button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openInLichess(context, lichessUrl),
                    icon: const Icon(Icons.open_in_browser),
                    label: const Text(
                      "Open in Lichess",
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // URL display and copy
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Lichess Editor URL:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        lichessUrl,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => _copyToClipboard(context, lichessUrl),
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text("Copy URL"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Copied to clipboard!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _openInLichess(BuildContext context, String url) async {
    try {
      await launchURL(url);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not open browser: $e"),
            backgroundColor: Colors.red,
          ),
        );
        // Fallback: copy URL to clipboard
        _copyToClipboard(context, url);
      }
    }
  }
}
