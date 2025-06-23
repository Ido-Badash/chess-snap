import 'package:chess_snap/features/home/game_view.dart';
import 'package:chess_snap/features/home/home_main_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Widget? currentBody;

  @override
  Widget build(BuildContext context) {
    return currentBody ?? buildHomeMainView();
  }

  Widget buildHomeMainView() {
    return HomeMainView(
      goToTakeAPicture: goToTakeAPicture,
      goToImageFromGallery: goToImageFromGallery,
      goToFromScratch: goToFromScratch,
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
    setState(() {
      currentBody = GameView(
        onExit: () {
          setState(() {
            currentBody = buildHomeMainView();
          });
        },
      );
    });
    debugPrint("Navigating to gameplay...");
  }
}
