import 'dart:io';

import 'package:chess_snap/features/home/home_main_view.dart';
import 'package:flutter/material.dart';
import 'package:chess_snap/features/from_picture_view.dart';

enum HomeBody { main, fromPicture }

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
      case HomeBody.main:
        // Default case for HomeMainView
        return HomeMainView(
          goToFromPicture: () {
            setState(() {
              currentBody = HomeBody.fromPicture;
            });
          },
        );
    }
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
