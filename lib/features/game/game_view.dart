import 'dart:io'; // For file operations
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
  static const String defaultFen =
      "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1";
  List<String> gameHistory = [];
  static const String dbPath = "lib/features/game/game_history.txt";

  @override
  void initState() {
    super.initState();
    _controller.loadFen(widget.fen ?? defaultFen);

    // Init gameHistory
    _initializeHistory();

    // Add listener to track moves and save history
    _controller.addListener(() {
      saveFenToHistory();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _initializeHistory() async {
    final history = await getHistoryFromFile(dbPath);
    if (history != null) {
      gameHistory.addAll(history);
    }
    saveHistoryToFile(dbPath);
  }

  Future<List<String>?> getHistoryFromFile(String path) async {
    final File file = File(path);
    List<String>? contents;

    if (await file.exists()) {
      contents = await file.readAsLines();
      return contents.isNotEmpty ? contents : null;
    } else {
      return null;
    }
  }

  void saveFenToHistory() {
    // Only save if its a legal move
    if (_controller.game.history.isNotEmpty) {
      final fen = _controller.getFen();
      if (gameHistory.isEmpty || gameHistory.last != fen) {
        gameHistory.add(fen);
        saveHistoryToFile(dbPath);
      }
    }
  }

  Future<void> saveHistoryToFile(String path) async {
    try {
      final file = File(path);
      await file.writeAsString(gameHistory.join('\n'));
      debugPrint("Game history saved to ${file.path}");
    } catch (e) {
      debugPrint("Error saving game history: $e");
    }
  }

  void resetGame() {
    // Reset the board and save the reset state
    _controller.resetBoard();
    gameHistory = [];
    gameHistory.add(defaultFen);
    saveHistoryToFile(dbPath);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: widget.onExit ?? () => Navigator.of(context).pop(),
          ),
        ),
        ChessBoard(
          controller: _controller,
          boardColor: BoardColor.brown,
          boardOrientation: PlayerColor.white,
        ),
        buildLowerWidgets(),
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
              icon: const Icon(Icons.refresh),
              onPressed: resetGame, // Call resetGame when reset is pressed
            ),
            const Text("Reset"),
          ],
        ),
      ],
    );
  }
}
