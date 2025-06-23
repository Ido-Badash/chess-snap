import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class GameView extends StatefulWidget {
  final String? fen;
  final void Function()? onExit;

  const GameView({super.key, this.fen, this.onExit});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
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
    return Column(
      children: [
        buildUpperWidgets(),
        Expanded(
          child: ChessBoard(
            controller: _controller,
            boardColor: BoardColor.brown,
            boardOrientation: PlayerColor.white,
          ),
        ),
        buildLowerWidgets(),
      ],
    );
  }

  Row buildUpperWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(onPressed: widget.onExit, icon: Icon(Icons.arrow_back)),
      ],
    );
  }

  Row buildLowerWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            IconButton(
              icon: Icon(Icons.undo),
              onPressed: () {
                _controller.undoMove(); //! DOSENT WORK
              },
            ),
            const Text("Undo"),
          ],
        ),
        SizedBox(width: 24),
        Column(
          children: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                _controller.resetBoard();
              },
            ),
            const Text("Reset"),
          ],
        ),
      ],
    );
  }
}
