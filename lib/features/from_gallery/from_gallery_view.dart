import 'package:flutter/material.dart';
import 'package:chess_snap/core/utils/empty_view.dart';

// User in gallery picking an image

// Gets the image and stores

// Puts the image in the chess scan python API

// Gets a String? that is a fen

// If the fen != null then go to a GameView with the fen it gave

// Else show the user an error that the image is not valid

class FromGalleryView extends StatelessWidget {
  final void Function()? onExit;

  const FromGalleryView({super.key, this.onExit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: EmptyView("From Gallery")),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: onExit ?? () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
