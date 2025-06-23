import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class GameChessBoard extends StatefulWidget {
  final String? fen;

  const GameChessBoard({super.key, this.fen});

  @override
  State<GameChessBoard> createState() => _GameChessBoardState();
}

class _GameChessBoardState extends State<GameChessBoard> {
  final ChessBoardController _controller = ChessBoardController();

  @override
  void initState() {
    super.initState();
    _controller.loadFen(
      widget.fen ?? "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChessBoard(
      controller: _controller,
      boardColor: BoardColor.brown,
      boardOrientation: PlayerColor.white,
    );
  }
}
