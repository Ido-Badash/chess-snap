import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ChessSnapApi {
  static const String baseUrl =
      'http://localhost:5000'; // Change to your server URL
  static const Duration timeout = Duration(seconds: 30);

  /// Convert image file to FEN string
  static Future<String> getFenFromFile(File imageFile) async {
    try {
      // Read image file as bytes
      final Uint8List imageBytes = await imageFile.readAsBytes();

      // Convert to base64
      final String base64Image = base64Encode(imageBytes);

      return await _sendRequest(base64Image, 'base64');
    } catch (e) {
      throw ChessSnapApiException('Failed to process image file: $e');
    }
  }

  /// Convert image bytes to FEN string
  static Future<String> getFenFromBytes(Uint8List imageBytes) async {
    try {
      // Convert to base64
      final String base64Image = base64Encode(imageBytes);

      return await _sendRequest(base64Image, 'base64');
    } catch (e) {
      throw ChessSnapApiException('Failed to process image bytes: $e');
    }
  }

  /// Convert image from URL to FEN string
  static Future<String> getFenFromUrl(String imageUrl) async {
    try {
      return await _sendRequest(imageUrl, 'url');
    } catch (e) {
      throw ChessSnapApiException('Failed to process image URL: $e');
    }
  }

  /// Convert image from file path to FEN string
  static Future<String> getFenFromPath(String filePath) async {
    try {
      return await _sendRequest(filePath, 'file_path');
    } catch (e) {
      throw ChessSnapApiException('Failed to process image path: $e');
    }
  }

  /// Send request to the API
  static Future<String> _sendRequest(
    String imageInput,
    String imageType,
  ) async {
    try {
      final Map<String, dynamic> requestBody = {
        'image': imageInput,
        'image_type': imageType,
      };

      debugPrint('Sending request to: $baseUrl/get_fen');
      debugPrint('Request body: ${jsonEncode(requestBody)}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/get_fen'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(timeout);

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        if (responseData.containsKey('fen')) {
          return responseData['fen'] as String;
        } else {
          throw ChessSnapApiException('Invalid response format: missing FEN');
        }
      } else {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        final String errorMessage = errorData['error'] ?? 'Unknown error';
        throw ChessSnapApiException(
          'API Error (${response.statusCode}): $errorMessage',
        );
      }
    } on http.ClientException catch (e) {
      throw ChessSnapApiException('Network error: $e');
    } on FormatException catch (e) {
      throw ChessSnapApiException('Invalid JSON response: $e');
    } catch (e) {
      throw ChessSnapApiException('Unexpected error: $e');
    }
  }

  /// Check if the API server is reachable
  static Future<bool> isServerReachable() async {
    try {
      final response = await http
          .get(Uri.parse(baseUrl))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200 || response.statusCode == 404;
    } catch (e) {
      return false;
    }
  }
}

/// Custom exception for ChessSnap API errors
class ChessSnapApiException implements Exception {
  final String message;

  const ChessSnapApiException(this.message);

  @override
  String toString() => 'ChessSnapApiException: $message';
}
