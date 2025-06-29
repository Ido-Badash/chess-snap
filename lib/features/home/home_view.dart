import 'dart:io';

import 'package:chess_snap/features/home/home_main_view.dart';
import 'package:flutter/material.dart';
import 'package:chess_snap/features/game/game_view.dart';
import 'package:chess_snap/features/from_picture/from_picture_view.dart';

enum HomeBody { main, fromPicture, fromScratch }

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeBody currentBody = HomeBody.main;
  String? gameFen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildCurrentBody());
  }

  Widget _buildCurrentBody() {
    switch (currentBody) {
      case HomeBody.fromPicture:
        return FromPictureView(
          onExit: () {
            setState(() {
              currentBody = HomeBody.main;
            });
          },
        );
      case HomeBody.fromScratch:
        return GameView(
          fen: gameFen,
          onExit: () {
            setState(() {
              currentBody = HomeBody.main;
            });
          },
        );
      case HomeBody.main:
        // Default case for HomeMainView
        return HomeMainView(
          goToFromPicture: () {
            setState(() {
              currentBody = HomeBody.fromPicture;
            });
          },
          goToFromScratch: () => goToScratch(),
        );
    }
  }

  Future<void> goToScratch() async {
    final String? lastFen = await getLastFenFromDB(
      "lib/features/game/game_history.txt",
    );
    setState(() {
      gameFen = lastFen;
      currentBody = HomeBody.fromScratch;
    });
  }

  Future<String?> getLastFenFromDB(String path) async {
    final file = File(path);
    if (await file.exists()) {
      final contents = await file.readAsLines();
      return contents.isNotEmpty ? contents.last : null;
    }
    return null;
  }
}
