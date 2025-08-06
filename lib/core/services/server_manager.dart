import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ServerManager {
  static Process? _serverProcess;
  static bool _isServerRunning = false;
  static String? _serverUrl;
  static late final String _platformInfo;
  static late final bool _isDesktop;
  static late final bool _canRunLocalServer;

  static bool get isServerRunning => _isServerRunning;
  static String? get serverUrl => _serverUrl;
  static String get platformInfo => _platformInfo;
  static bool get isDesktop => _isDesktop;
  static bool get canRunLocalServer => _canRunLocalServer;

  static void initialize() {
    // Determine platform info
    if (kIsWeb) {
      _platformInfo = 'Web';
      _isDesktop = false;
      _canRunLocalServer = false;
    } else if (Platform.isWindows) {
      _platformInfo = 'Windows';
      _isDesktop = true;
      _canRunLocalServer = true;
    } else if (Platform.isMacOS) {
      _platformInfo = 'macOS';
      _isDesktop = true;
      _canRunLocalServer = true;
    } else if (Platform.isLinux) {
      _platformInfo = 'Linux';
      _isDesktop = true;
      _canRunLocalServer = true;
    } else if (Platform.isAndroid) {
      _platformInfo = 'Android';
      _isDesktop = false;
      _canRunLocalServer = false;
    } else if (Platform.isIOS) {
      _platformInfo = 'iOS';
      _isDesktop = false;
      _canRunLocalServer = false;
    } else {
      _platformInfo = 'Unknown';
      _isDesktop = false;
      _canRunLocalServer = false;
    }

    // Set default server URL based on platform
    if (_canRunLocalServer) {
      _serverUrl = 'http://localhost:5000';
    } else {
      // For mobile platforms, we'll use demo mode
      _serverUrl = null;
    }
  }

  static Future<bool> startServer() async {
    if (!_canRunLocalServer) {
      if (kDebugMode) {
        print('ServerManager: Cannot run local server on $_platformInfo. Using demo mode.');
      }
      _isServerRunning = false;
      return false;
    }

    if (_isServerRunning) {
      if (kDebugMode) {
        print('ServerManager: Server is already running');
      }
      return true;
    }

    try {
      if (kDebugMode) {
        print('ServerManager: Starting server on $_platformInfo...');
      }

      // Check if server is already running
      if (await _checkServerHealth()) {
        _isServerRunning = true;
        if (kDebugMode) {
          print('ServerManager: Server was already running externally');
        }
        return true;
      }

      // Try to start the server
      
      // Get the server directory path
      final currentDir = Directory.current.path;
      final serverDir = '$currentDir${Platform.pathSeparator}server';
      
      if (!Directory(serverDir).existsSync()) {
        if (kDebugMode) {
          print('ServerManager: Server directory not found: $serverDir');
        }
        return false;
      }

      // Choose the appropriate startup script
      String startScript;
      if (Platform.isWindows) {
        // Check for virtual environment script first
        final venvScript = '$serverDir${Platform.pathSeparator}start_server_venv.bat';
        final regularScript = '$serverDir${Platform.pathSeparator}start_server.bat';
        
        if (File(venvScript).existsSync()) {
          startScript = venvScript;
        } else if (File(regularScript).existsSync()) {
          startScript = regularScript;
        } else {
          if (kDebugMode) {
            print('ServerManager: No startup script found in $serverDir');
          }
          return false;
        }
      } else {
        // Unix-like systems (macOS, Linux)
        final venvScript = '$serverDir${Platform.pathSeparator}start_server_venv.sh';
        final regularScript = '$serverDir${Platform.pathSeparator}start_server.sh';
        
        if (File(venvScript).existsSync()) {
          startScript = venvScript;
        } else if (File(regularScript).existsSync()) {
          startScript = regularScript;
        } else {
          if (kDebugMode) {
            print('ServerManager: No startup script found in $serverDir');
          }
          return false;
        }
      }

      if (kDebugMode) {
        print('ServerManager: Using startup script: $startScript');
      }

      // Start the server process
      if (Platform.isWindows) {
        _serverProcess = await Process.start(
          'cmd',
          ['/c', startScript],
          workingDirectory: serverDir,
        );
      } else {
        _serverProcess = await Process.start(
          'bash',
          [startScript],
          workingDirectory: serverDir,
        );
      }

      // Listen to process output for debugging
      if (kDebugMode) {
        _serverProcess!.stdout.transform(utf8.decoder).listen((data) {
          print('ServerManager stdout: $data');
        });
        _serverProcess!.stderr.transform(utf8.decoder).listen((data) {
          print('ServerManager stderr: $data');
        });
      }
      
      // Give the server more time to start
      await Future.delayed(const Duration(seconds: 8));
      
      // Check if server started successfully
      if (await _checkServerHealth()) {
        _isServerRunning = true;
        if (kDebugMode) {
          print('ServerManager: Server started successfully');
        }
        return true;
      } else {
        if (kDebugMode) {
          print('ServerManager: Server failed to start or health check failed');
        }
        await stopServer();
        return false;
      }

    } catch (e) {
      if (kDebugMode) {
        print('ServerManager: Error starting server: $e');
      }
      await stopServer();
      return false;
    }
  }

  static Future<void> stopServer() async {
    if (!_canRunLocalServer) {
      return;
    }

    try {
      if (_serverProcess != null) {
        if (kDebugMode) {
          print('ServerManager: Stopping server process...');
        }
        _serverProcess!.kill();
        _serverProcess = null;
      }

      // Also try to stop via system command for cleanup
      if (Platform.isWindows) {
        try {
          await Process.run('taskkill', ['/F', '/IM', 'python.exe']);
        } catch (e) {
          // Ignore errors as process might not exist
        }
      }

      _isServerRunning = false;
      if (kDebugMode) {
        print('ServerManager: Server stopped');
      }
    } catch (e) {
      if (kDebugMode) {
        print('ServerManager: Error stopping server: $e');
      }
    }
  }

  static Future<bool> _checkServerHealth() async {
    if (_serverUrl == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$_serverUrl/health'),
      ).timeout(const Duration(seconds: 5));
      
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> checkServerStatus() async {
    if (!_canRunLocalServer) {
      _isServerRunning = false;
      return false;
    }

    final isHealthy = await _checkServerHealth();
    _isServerRunning = isHealthy;
    return isHealthy;
  }

  static Future<void> dispose() async {
    await stopServer();
  }
}
