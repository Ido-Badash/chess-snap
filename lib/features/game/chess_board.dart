import 'package:flutter/material.dart';
import 'package:simple_chess_board/simple_chess_board.dart';

class GameChessBoard extends StatefulWidget {
  final String? fen;

  const GameChessBoard({super.key, this.fen});

  @override
  State<GameChessBoard> createState() => _GameChessBoardState();
}

class _GameChessBoardState extends State<GameChessBoard> {
  String? _selectedSquare;
  List<String> _possibleMoves = [];

  @override
  Widget build(BuildContext context) {
    return SimpleChessBoard(
      fen:
          widget.fen ??
          "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
      onMove: ({required move}) {
        // Clear selection after move
        setState(() {
          _selectedSquare = null;
          _possibleMoves = [];
        });
      },
      onPromotionCommited: ({required moveDone, required pieceType}) {},
      onTap: ({required cellCoordinate}) => _handleSquareTap(cellCoordinate),
      chessBoardColors: ChessBoardColors(),
      // cellHighlights defines the highlight colors for board squares; you can customize these as needed.
      cellHighlights: {
        "white": Colors.white, // Highlight color for white squares
        "brown": Colors.brown, // Highlight color for brown squares
      },
      whitePlayerType: PlayerType.human,
      blackPlayerType: PlayerType.human,
      onPromote: () async => null,
    );
  }

  void _handleSquareTap(String square) {
    if (_selectedSquare == null) {
      // First tap - select piece
      setState(() {
        _selectedSquare = square;
        _possibleMoves = _getPossibleMoves(square);
      });
    } else if (_possibleMoves.contains(square)) {
      // Move piece to the tapped square
      setState(() {
        _selectedSquare = null;
        _possibleMoves = [];
      });
    } else {
      // Clear selection
      setState(() {
        _selectedSquare = null;
        _possibleMoves = [];
      });
    }
  }

  List<String> _getPossibleMoves(String square) {
    // This is a simplified version - implement actual chess moves here
    // For now, returning knight moves as an example
    final file = square[0];
    final rank = int.parse(square[1]);
    final fileCode = file.codeUnitAt(0);

    return [
      if (fileCode > 'a'.codeUnitAt(0) + 1 && rank < 7)
        '${String.fromCharCode(fileCode - 2)}${rank + 1}', // L-shape
      if (fileCode > 'a'.codeUnitAt(0) + 1 && rank > 2)
        '${String.fromCharCode(fileCode - 2)}${rank - 1}',
      if (fileCode < 'h'.codeUnitAt(0) - 1 && rank < 7)
        '${String.fromCharCode(fileCode + 2)}${rank + 1}',
      if (fileCode < 'h'.codeUnitAt(0) - 1 && rank > 2)
        '${String.fromCharCode(fileCode + 2)}${rank - 1}',
      if (fileCode > 'a'.codeUnitAt(0) && rank < 6)
        '${String.fromCharCode(fileCode - 1)}${rank + 2}',
      if (fileCode < 'h'.codeUnitAt(0) && rank < 6)
        '${String.fromCharCode(fileCode + 1)}${rank + 2}',
      if (fileCode > 'a'.codeUnitAt(0) && rank > 3)
        '${String.fromCharCode(fileCode - 1)}${rank - 2}',
      if (fileCode < 'h'.codeUnitAt(0) && rank > 3)
        '${String.fromCharCode(fileCode + 1)}${rank - 2}',
    ];
  }
}
