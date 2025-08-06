import 'dart:io';
import 'package:process_run/shell.dart';
import 'package:flutter/foundation.dart';

class ServerManager {
  static Process? _serverProcess;
  static bool _isServerRunning = false;

  /// Start the Python server using the batch file
  static Future<bool> startServer() async {
    if (_isServerRunning) {
      debugPrint('Server is already running');
      return true;
    }

    try {
      debugPrint('Starting Python server...');
      
      // Get the path to the server directory
      // Prefer virtual environment version if available
      String serverPath;
      if (Platform.isWindows) {
        final venvPath = 'server\\start_server_venv.bat';
        final regularPath = 'server\\start_server.bat';
        
        // Check if virtual environment script exists
        final venvFile = File('${Directory.current.path}\\$venvPath');
        if (await venvFile.exists()) {
          serverPath = venvPath;
          debugPrint('Using virtual environment server');
        } else {
          serverPath = regularPath;
          debugPrint('Using regular server (no venv found)');
        }
      } else {
        // For future Linux/Mac support
        serverPath = 'server/start_server.sh';
      }

      // Start the server process
      if (Platform.isWindows) {
        _serverProcess = await Process.start(
          'cmd',
          ['/c', serverPath],
          workingDirectory: Directory.current.path,
          mode: ProcessStartMode.detached,
        );
      } else {
        // For Linux/Mac (future support)
        _serverProcess = await Process.start(
          'bash',
          [serverPath],
          workingDirectory: Directory.current.path,
          mode: ProcessStartMode.detached,
        );
      }      _isServerRunning = true;
      debugPrint(
        'Server started successfully with PID: ${_serverProcess?.pid}',
      );

      // Listen to server output for debugging
      _serverProcess?.stdout.listen((data) {
        debugPrint('Server: ${String.fromCharCodes(data)}');
      });

      _serverProcess?.stderr.listen((data) {
        debugPrint('Server Error: ${String.fromCharCodes(data)}');
      });

      // Wait a moment for server to start
      await Future.delayed(const Duration(seconds: 3));

      return true;
    } catch (e) {
      debugPrint('Failed to start server: $e');
      _isServerRunning = false;
      return false;
    }
  }

  /// Stop the Python server
  static Future<void> stopServer() async {
    if (!_isServerRunning || _serverProcess == null) {
      debugPrint('No server process to stop');
      return;
    }

    try {
      debugPrint('Stopping Python server...');

      if (Platform.isWindows) {
        // On Windows, kill the process tree to ensure Python process is also killed
        await Process.run('taskkill', [
          '/T',
          '/F',
          '/PID',
          '${_serverProcess!.pid}',
        ]);
      } else {
        // On Linux/Mac
        _serverProcess!.kill(ProcessSignal.sigterm);
      }

      _serverProcess = null;
      _isServerRunning = false;
      debugPrint('Server stopped successfully');
    } catch (e) {
      debugPrint('Error stopping server: $e');
      _serverProcess = null;
      _isServerRunning = false;
    }
  }

  /// Check if server is running
  static bool get isServerRunning => _isServerRunning;

  /// Get server PID if running
  static int? get serverPid => _serverProcess?.pid;

  /// Alternative method to start server using shell command
  static Future<bool> startServerWithShell() async {
    if (_isServerRunning) {
      debugPrint('Server is already running');
      return true;
    }

    try {
      debugPrint('Starting Python server with shell...');

      if (Platform.isWindows) {
        final result = await Shell().run('server\\start_server.bat');
        debugPrint('Server start result: $result');
      } else {
        final result = await Shell().run('bash server/start_server.sh');
        debugPrint('Server start result: $result');
      }

      _isServerRunning = true;
      await Future.delayed(const Duration(seconds: 3));
      return true;
    } catch (e) {
      debugPrint('Failed to start server with shell: $e');
      return false;
    }
  }

  /// Kill all Python processes (emergency stop)
  static Future<void> killAllPythonProcesses() async {
    try {
      if (Platform.isWindows) {
        await Process.run('taskkill', ['/F', '/IM', 'python.exe']);
        await Process.run('taskkill', ['/F', '/IM', 'python3.exe']);
      } else {
        await Process.run('pkill', ['-f', 'python']);
      }

      _serverProcess = null;
      _isServerRunning = false;
      debugPrint('All Python processes killed');
    } catch (e) {
      debugPrint('Error killing Python processes: $e');
    }
  }
}
