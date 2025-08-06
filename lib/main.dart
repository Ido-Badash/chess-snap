import 'package:flutter/material.dart';
import 'features/app.dart';
import 'core/services/server_manager.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize ServerManager first
  ServerManager.initialize();
  
  // Start the Python API server
  debugPrint("Starting ChessSnap application...");
  final serverStarted = await ServerManager.startServer();
  
  if (serverStarted) {
    debugPrint("Python server started successfully");
  } else {
    debugPrint("Failed to start Python server - app will continue without backend");
  }

  // Run the Flutter app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChessSnap",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const ChessSnap(),
    );
  }
}
