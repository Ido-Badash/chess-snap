import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class ChessGameView extends StatefulWidget {
  const ChessGameView({super.key});

  @override
  State<ChessGameView> createState() => _ChessGameViewState();
}

class _ChessGameViewState extends State<ChessGameView> {
  final ChessBoardController _controller = ChessBoardController();

  @override
  void initState() {
    super.initState();
    _controller.loadFen("4Q3/4Q3/4Q3/4Q3/8/8/6k1/4K3 w - - 0 1");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChessBoard(
          controller: _controller,
          boardColor: BoardColor.brown,
          boardOrientation: PlayerColor.white,
        ),
      ],
    );
  }
}
