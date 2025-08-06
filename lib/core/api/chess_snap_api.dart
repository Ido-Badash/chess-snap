import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ChessSnapApiException implements Exception {
  final String message;
  final int? statusCode;

  ChessSnapApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ChessSnapApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

class ChessSnapApi {
  static const Duration _timeout = Duration(seconds: 30);

  static Future<bool> isServerReachable(String url) async {
    if (url.isEmpty) return false;

    try {
      final response = await http
          .get(Uri.parse('$url/health'))
          .timeout(_timeout);

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        print('ChessSnapApi: Server unreachable: $e');
      }
      return false;
    }
  }

  static Future<String> getFenFromFile(
    File imageFile, {
    String? serverUrl,
  }) async {
    if (serverUrl != null && serverUrl.isNotEmpty) {
      return await _getFenFromLocalServer(imageFile, serverUrl);
    } else {
      // Use demo mode if no server URL is provided
      return _getDemoFen();
    }
  }

  static Future<String> _getFenFromLocalServer(
    File imageFile,
    String url,
  ) async {
    if (url.isEmpty) {
      throw ChessSnapApiException('Server URL is not available');
    }

    try {
      // Check if server is reachable first
      if (!await isServerReachable(url)) {
        throw ChessSnapApiException(
          'Server is not reachable. Please make sure the Python server is running.',
        );
      }

      final uri = Uri.parse('$url/detect');
      final request = http.MultipartRequest('POST', uri);

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      if (kDebugMode) {
        print('ChessSnapApi: Sending request to $uri');
      }

      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print('ChessSnapApi: Response status: ${response.statusCode}');
        print('ChessSnapApi: Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true) {
          final fen = data['fen'] as String?;
          if (fen != null && fen.isNotEmpty) {
            return fen;
          } else {
            throw ChessSnapApiException('Empty FEN received from server');
          }
        } else {
          final error = data['error'] ?? 'Unknown error occurred';
          throw ChessSnapApiException('Server error: $error');
        }
      } else {
        throw ChessSnapApiException(
          'Server returned error: ${response.statusCode} - ${response.body}',
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw ChessSnapApiException(
        'Request timeout - server took too long to respond',
      );
    } catch (e) {
      if (e is ChessSnapApiException) {
        rethrow;
      }
      throw ChessSnapApiException('Network error: $e');
    }
  }

  static String _getDemoFen() {
    // Demo FEN positions for mobile platforms
    final demoPositions = [
      'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1', // Starting position
      'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1', // 1.e4
      'rnbqkb1r/pppp1ppp/5n2/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 2 2', // 1.e4 e5 2.Nf3
      'r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 4 3', // Scotch opening
      'rnbqkb1r/ppp2ppp/4pn2/3p4/2PP4/8/PP2PPPP/RNBQKBNR w KQkq d6 0 4', // Queen's Gambit Declined
    ];

    // Return a random position from demo positions
    final randomIndex =
        DateTime.now().millisecondsSinceEpoch % demoPositions.length;
    final selectedFen = demoPositions[randomIndex];

    if (kDebugMode) {
      print('ChessSnapApi: Using demo FEN (mobile mode): $selectedFen');
    }

    return selectedFen;
  }

  static Future<String> getFenFromPath(
    String imagePath, {
    String? serverUrl,
  }) async {
    final file = File(imagePath);
    if (!file.existsSync()) {
      throw ChessSnapApiException('Image file does not exist: $imagePath');
    }
    return await getFenFromFile(file, serverUrl: serverUrl);
  }
}
