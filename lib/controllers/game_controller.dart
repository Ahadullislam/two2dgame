import 'dart:math';
import '../widgets/mode_selector.dart';

enum Player { x, o }

enum GameResult { ongoing, draw, xWin, oWin }

class GameController {
  List<String> board = List.filled(9, '');
  Player currentPlayer = Player.x;
  GameMode mode = GameMode.pvp;
  bool gameOver = false;
  GameResult result = GameResult.ongoing;
  List<int>? winLine;

  void reset({GameMode? newMode}) {
    board = List.filled(9, '');
    currentPlayer = Player.x;
    gameOver = false;
    result = GameResult.ongoing;
    winLine = null;
    if (newMode != null) mode = newMode;
  }

  bool makeMove(int idx) {
    if (board[idx].isNotEmpty || gameOver) return false;
    board[idx] = currentPlayer == Player.x ? 'X' : 'O';
    _checkGameOver();
    if (!gameOver) {
      currentPlayer = currentPlayer == Player.x ? Player.o : Player.x;
    }
    return true;
  }

  void _checkGameOver() {
    const lines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // cols
      [0, 4, 8], [2, 4, 6], // diags
    ];
    for (final line in lines) {
      final a = board[line[0]];
      final b = board[line[1]];
      final c = board[line[2]];
      if (a.isNotEmpty && a == b && b == c) {
        gameOver = true;
        result = a == 'X' ? GameResult.xWin : GameResult.oWin;
        winLine = line;
        return;
      }
    }
    if (!board.contains('')) {
      gameOver = true;
      result = GameResult.draw;
    }
  }

  int getRandomMove() {
    final empty = <int>[];
    for (int i = 0; i < 9; i++) {
      if (board[i].isEmpty) empty.add(i);
    }
    if (empty.isEmpty) return -1;
    return empty[Random().nextInt(empty.length)];
  }
}
