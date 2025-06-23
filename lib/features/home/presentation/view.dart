import 'package:flutter/material.dart';
import 'package:chess_snap/features/game/presentation/view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Widget? currentBody;

  final Map views = {"scrach": ChessGameView()};

  @override
  Widget build(BuildContext context) {
    return currentBody ?? buildAppHome();
  }

  Widget buildAppHome() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          buildAppDescription(screenWidth, screenHeight),
          const SizedBox(height: 20.0),
          buildCenteredButtons(screenWidth),
        ],
      ),
    );
  }

  // App description builder
  Widget buildAppDescription(double screenWidth, double screenHeight) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "ChessScan & Play: Transform Your Game!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Capture any chessboard, anywhere, and play instantly!\n"
            "Revolutionize how you practice and enjoy chess!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 20.0),
          Image.asset(
            "assets/images/home_pieces_bg.png",
            width: screenWidth * 0.8,
            height: screenHeight * 0.3,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  // Centered buttons builder
  Widget buildCenteredButtons(double screenWidth) {
    return Column(
      children: [
        buildTakePictureButton(screenWidth),
        const SizedBox(height: 20.0),
        buildImageFromGalleryButton(screenWidth),
        const SizedBox(height: 20.0),
        buildFromScratchButton(screenWidth),
      ],
    );
  }

  // Take picture button builder
  Widget buildTakePictureButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.6,
      height: 50,
      child: ElevatedButton(
        onPressed: goToTakeAPicture,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Take a picture", style: TextStyle(fontSize: 20)),
            SizedBox(width: 4.0),
            Icon(Icons.camera_alt, size: 20.0),
          ],
        ),
      ),
    );
  }

  // Image from gallery button builder
  Widget buildImageFromGalleryButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.7,
      height: 50,
      child: ElevatedButton(
        onPressed: goToImageFromGallery,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Image from gallery", style: TextStyle(fontSize: 20)),
            SizedBox(width: 4.0),
            Icon(Icons.image, size: 20.0),
          ],
        ),
      ),
    );
  }

  // From scratch button builder
  Widget buildFromScratchButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.7,
      height: 50,
      child: ElevatedButton(
        onPressed: goToFromScratch,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("From Scratch", style: TextStyle(fontSize: 20)),
            SizedBox(width: 4.0),
            Icon(Icons.edit, size: 20.0),
          ],
        ),
      ),
    );
  }

  // Navigate to take a picture function
  void goToTakeAPicture() {
    debugPrint("Navigating to take a picture...");
  }

  // Navigate to image from gallery function
  void goToImageFromGallery() {
    debugPrint("Navigating to image from gallery...");
  }

  // Navigate to gameplay function
  void goToFromScratch() {
    _goTo("scrach");
    debugPrint("Navigating to gameplay...");
  }

  void _goTo(String view) {
    setState(() {
      currentBody = views[view];
    });
  }
}
