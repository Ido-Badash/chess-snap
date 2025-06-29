import 'dart:io';

import 'package:chess_snap/features/home/home_main_view.dart';
import 'package:flutter/material.dart';
import 'package:chess_snap/features/game/game_view.dart';
import 'package:chess_snap/features/from_picture/take_a_pic_view.dart';

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
          child: HomeMainView(
            goToFromPicture: () {
              setState(() {
                overlayView = FromPictureView(onExit: clearOverlay);
              });
            },

            goToFromScratch: () => goToScrach(),
          ),
        ),
        // Overlay view (if any)
        if (overlayView != null)
          Positioned.fill(
            child: Container(
              color: Colors.white, // Semi-transparent background
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
