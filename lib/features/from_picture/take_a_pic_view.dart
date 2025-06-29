import 'package:flutter/material.dart';
import 'package:chess_snap/core/utils/empty_view.dart';


/* 
* - Steps -

1. User decided to take a picture or from gallery

2. User taking an image / picks from gallery

3. Gets the image and stores

4. Puts the image in the chess scan python API

5. Gets a String? that is a fen

6. If the fen != null then go to a GameView with the fen it gave

7. Else show the user an error that the image is not valid

*/

class FromPictureView extends StatelessWidget {
  final void Function()? onExit;

  const FromPictureView({super.key, this.onExit});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(child: EmptyView("From A picture")),
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
