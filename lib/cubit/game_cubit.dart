import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/leaderboard.dart';

enum GameMode { pvp, pvc }
enum Player { x, o }
enum GameResult { ongoing, draw, xWin, oWin }

class GameState extends Equatable {
  final GameMode mode;
  final List<String> board;
  final Player currentPlayer;
  final bool gameOver;
  final GameResult result;
  final List<int>? winLine;

  const GameState({
    required this.mode,
    required this.board,
    required this.currentPlayer,
    required this.gameOver,
    required this.result,
    required this.winLine,
  });

  factory GameState.initial([GameMode mode = GameMode.pvp]) => GameState(
        mode: mode,
        board: List.filled(9, ''),
        currentPlayer: Player.x,
        gameOver: false,
        result: GameResult.ongoing,
        winLine: null,
      );

  GameState copyWith({
    GameMode? mode,
    List<String>? board,
    Player? currentPlayer,
    bool? gameOver,
    GameResult? result,
    List<int>? winLine,
  }) {
    return GameState(
      mode: mode ?? this.mode,
      board: board ?? this.board,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      gameOver: gameOver ?? this.gameOver,
      result: result ?? this.result,
      winLine: winLine,
    );
  }

  @override
  List<Object?> get props => [mode, board, currentPlayer, gameOver, result, winLine];
}

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(GameState.initial());

  void reset([GameMode? mode]) {
    emit(GameState.initial(mode ?? state.mode));
  }

  Future<void> onCellTap(int idx) async {
    if (state.board[idx].isNotEmpty || state.gameOver) return;

    final newBoard = List<String>.from(state.board);
    newBoard[idx] = state.currentPlayer == Player.x ? 'X' : 'O';

    final evaluated = _evaluate(newBoard);
    if (evaluated.gameOver) {
      emit(state.copyWith(
        board: newBoard,
        gameOver: true,
        result: evaluated.result,
        winLine: evaluated.winLine,
      ));
      // Record result for PVC mode only (player=X, AI=O)
      if (state.mode == GameMode.pvc) {
        if (evaluated.result == GameResult.draw) {
          LeaderboardModel().recordResult('Tic-Tac-Toe', draw: true);
        } else if (evaluated.result == GameResult.xWin) {
          LeaderboardModel().recordResult('Tic-Tac-Toe', win: true);
        } else if (evaluated.result == GameResult.oWin) {
          LeaderboardModel().recordResult('Tic-Tac-Toe');
        }
      }
      return;
    }

    final nextPlayer = state.currentPlayer == Player.x ? Player.o : Player.x;
    emit(state.copyWith(board: newBoard, currentPlayer: nextPlayer, winLine: null));

    if (state.mode == GameMode.pvc && nextPlayer == Player.o) {
      await Future.delayed(const Duration(milliseconds: 350));
      final aiMove = _getRandomMove(newBoard);
      if (aiMove != -1) {
        final aiBoard = List<String>.from(newBoard);
        aiBoard[aiMove] = 'O';
        final aiEval = _evaluate(aiBoard);
        if (aiEval.gameOver) {
          emit(state.copyWith(
            board: aiBoard,
            gameOver: true,
            result: aiEval.result,
            winLine: aiEval.winLine,
          ));
          // Record result for PVC mode (AI just moved as O)
          if (state.mode == GameMode.pvc) {
            if (aiEval.result == GameResult.draw) {
              LeaderboardModel().recordResult('Tic-Tac-Toe', draw: true);
            } else if (aiEval.result == GameResult.xWin) {
              LeaderboardModel().recordResult('Tic-Tac-Toe', win: true);
            } else if (aiEval.result == GameResult.oWin) {
              LeaderboardModel().recordResult('Tic-Tac-Toe');
            }
          }
        } else {
          emit(state.copyWith(
            board: aiBoard,
            currentPlayer: Player.x,
            winLine: null,
          ));
        }
      }
    }
  }

  _Eval _evaluate(List<String> board) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (final line in lines) {
      final a = board[line[0]];
      final b = board[line[1]];
      final c = board[line[2]];
      if (a.isNotEmpty && a == b && b == c) {
        return _Eval(true, a == 'X' ? GameResult.xWin : GameResult.oWin, line);
      }
    }
    if (!board.contains('')) {
      return _Eval(true, GameResult.draw, null);
    }
    return _Eval(false, GameResult.ongoing, null);
  }

  int _getRandomMove(List<String> board) {
    final empty = <int>[];
    for (int i = 0; i < 9; i++) {
      if (board[i].isEmpty) empty.add(i);
    }
    if (empty.isEmpty) return -1;
    return empty[DateTime.now().millisecondsSinceEpoch % empty.length];
  }
}

class _Eval {
  final bool gameOver;
  final GameResult result;
  final List<int>? winLine;
  _Eval(this.gameOver, this.result, this.winLine);
}
