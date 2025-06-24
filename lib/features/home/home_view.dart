import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chess_snap/features/from_gallery/from_gallery_view.dart';
import 'package:chess_snap/features/game/game_view.dart';
import 'package:chess_snap/features/take_a_picture/take_a_pic_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Widget? overlayView; // Tracks the currently active overlay view

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main home view with buttons
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    overlayView = TakeAPicView(onExit: clearOverlay);
                  });
                },
                child: const Text("Take a Picture"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    overlayView = FromGalleryView(onExit: clearOverlay);
                  });
                },
                child: const Text("Image from Gallery"),
              ),
              ElevatedButton(
                onPressed: () => goToScrach(),
                child: const Text("From Scratch"),
              ),
            ],
          ),
        ),
        // Overlay view (if any)
        if (overlayView != null)
          Positioned.fill(
            child: Container(
              color: Colors.white.withAlpha(227), // Semi-transparent background
              child: overlayView,
            ),
          ),
      ],
    );
  }

  Future<void> goToScrach() async {
    final String? lastFen = await getLastFenFromDB(
      "lib/features/game/game_history.txt",
    );
    setState(() {
      overlayView = GameView(onExit: clearOverlay, fen: lastFen);
    });
  }

  Future<String?> getLastFenFromDB(String path) async {
    final File file = File(path);
    List<String>? contents;

    if (await file.exists()) {
      contents = await file.readAsLines();
      return contents.isNotEmpty ? contents.last : null;
    } else {
      return null;
    }
  }

  // Clears the overlay view and returns to the main home view
  void clearOverlay() {
    setState(() {
      overlayView = null;
    });
  }
}
