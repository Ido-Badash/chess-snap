import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chess_snap/core/api/chess_snap_api.dart';
import 'package:chess_snap/core/services/image_service.dart';
import 'package:chess_snap/core/utils/launch_url.dart';
import 'package:chess_snap/features/home/result_section.dart';
import 'package:chess_snap/features/home/main_content.dart';
import 'package:chess_snap/features/home/header_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  bool _isProcessing = false;
  String? _errorMessage;
  String? _selectedImagePath;
  String? _detectedFen;
  late AnimationController _floatingController;
  late Animation<double> _floatingAnimation;
  late AnimationController _resultController;
  late Animation<double> _resultSlideAnimation;

  @override
  void initState() {
    super.initState();
    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatingAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _resultController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // Change this line to use a curve that doesn't go beyond 0.0-1.0 range
    _resultSlideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _resultController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _floatingController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  String get lichessUrl => _detectedFen != null
      ? "https://lichess.org/editor/${Uri.encodeComponent(_detectedFen!)}"
      : "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF2193b0),
              Color(0xFF6dd5ed),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeaderSection(floatingAnimation: _floatingAnimation),
                  const SizedBox(height: 40),
                  MainContent(
                    selectedImagePath: _selectedImagePath,
                    errorMessage: _errorMessage,
                    isProcessing: _isProcessing,
                    detectedFen: _detectedFen,
                    onGalleryPressed: _onGalleryPressed,
                    onCameraPressed: _onCameraPressed,
                    onProcessImage: _processImage,
                    onRemoveImage: () => setState(() {
                      _selectedImagePath = null;
                    }),
                  ),
                  if (_detectedFen != null) ...[
                    const SizedBox(height: 30),
                    ResultSection(
                      resultSlideAnimation: _resultSlideAnimation,
                      detectedFen: _detectedFen!,
                      lichessUrl: lichessUrl,
                      onCopyToClipboard: _copyToClipboard,
                      onOpenInLichess: _openInLichess,
                      onResetForNewAnalysis: _resetForNewAnalysis,
                      onShowSnackBar: _showSnackBar,
                    ),
                  ],
                  const SizedBox(height: 40),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFeatureCard(
              icon: Icons.speed,
              title: "Fast",
              subtitle: "Quick analysis",
            ),
            _buildFeatureCard(
              icon: Icons.check_circle_outline,
              title: "Accurate",
              subtitle: "AI-powered",
            ),
            _buildFeatureCard(
              icon: Icons.play_arrow,
              title: "Play",
              subtitle: "With lichess.org",
            ),
          ],
        ),
        const SizedBox(height: 30),
        Container(
          width: 100,
          height: 4,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.transparent, Colors.white, Colors.transparent],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar("Copied to clipboard!", Icons.check);
  }

  Future<void> _openInLichess() async {
    try {
      await launchURL(lichessUrl);
    } catch (e) {
      _showSnackBar("Could not open Lichess", Icons.error, isError: true);
      _copyToClipboard(lichessUrl);
    }
  }

  void _resetForNewAnalysis() {
    setState(() {
      _selectedImagePath = null;
      _detectedFen = null;
      _errorMessage = null;
      _isProcessing = false;
    });
    _resultController.reset();
  }

  void _showSnackBar(String message, IconData icon, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _processImage() async {
    if (_selectedImagePath == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final bool isServerReachable = await ChessSnapApi.isServerReachable();
      if (!isServerReachable) {
        debugPrint("Server is not reachable");
        throw ChessSnapApiException(
          "Cannot connect to the chess recognition server.",
        );
      }

      final File imageFile = File(_selectedImagePath!);
      final String fen = await ChessSnapApi.getFenFromFile(imageFile);

      if (mounted) {
        setState(() {
          _detectedFen = fen;
        });
        _resultController.forward();
      }
    } on ChessSnapApiException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Unexpected error: $e';
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _onGalleryPressed() async {
    try {
      final String? imagePath = await ImageService.pickImageFromGallery();
      if (imagePath != null) {
        setState(() {
          _selectedImagePath = imagePath;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getPermissionErrorMessage(e.toString());
      });
    }
  }

  Future<void> _onCameraPressed() async {
    try {
      final String? imagePath = await ImageService.takePhoto();
      if (imagePath != null) {
        setState(() {
          _selectedImagePath = imagePath;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getPermissionErrorMessage(e.toString());
      });
    }
  }

  String _getPermissionErrorMessage(String error) {
    if (error.contains('Camera permission denied')) {
      return 'Camera permission is required to take photos. Please enable it in app settings.';
    } else if (error.contains('Storage permission denied')) {
      return 'Storage permission is required to access photos. Please enable it in app settings.';
    }
    return error;
  }
}
