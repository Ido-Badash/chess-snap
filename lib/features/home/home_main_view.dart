import 'package:flutter/material.dart';

class HomeMainView extends StatelessWidget {
  final void Function()? goToFromPicture;
  final void Function()? goToFromScratch;

  const HomeMainView({super.key, this.goToFromPicture, this.goToFromScratch});

  @override
  Widget build(BuildContext context) {
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10.0),
          const Text(
            "Capture any chessboard, anywhere, and play!\n"
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
        buildFromPictureButton(screenWidth),
        const SizedBox(height: 20.0),
        buildFromScratchButton(screenWidth),
      ],
    );
  }

  // From picture button builder
  Widget buildFromPictureButton(double screenWidth) {
    return SizedBox(
      width: screenWidth * 0.6,
      height: 50,
      child: ElevatedButton(
        onPressed: goToFromPicture,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("From picture", style: TextStyle(fontSize: 20)),
            SizedBox(width: 4.0),
            Icon(Icons.camera_alt, size: 20.0),
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
}
