import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../tictactoe/cubit/game_cubit.dart';

const neonBlue = Color(0xFF00F0FF);
const neonPink = Color(0xFFFF00E0);
const neonGreen = Color(0xFF39FF14);
const neonPurple = Color(0xFF9D00FF);

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Tic-Tac-Toe'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'New Game',
            onPressed: () => context.read<GameCubit>().reset(),
            color: neonGreen,
          ),
        ],
      ),
      body: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              _ModeSelector(
                mode: state.mode,
                onChanged: (m) => context.read<GameCubit>().reset(m),
              ),
              const SizedBox(height: 18),
              Text(
                state.gameOver
                    ? (state.result == GameResult.xWin
                        ? 'X Wins!'
                        : state.result == GameResult.oWin
                            ? 'O Wins!'
                            : 'Draw!')
                    : (state.currentPlayer == Player.x ? "X's Turn" : "O's Turn"),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 28,
                  color: state.gameOver
                      ? (state.result == GameResult.xWin
                          ? neonBlue
                          : state.result == GameResult.oWin
                              ? neonPink
                              : neonGreen)
                      : (state.currentPlayer == Player.x ? neonBlue : neonPink),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: _GameBoard(
                    board: state.board,
                    onCellTap: (i) => context.read<GameCubit>().onCellTap(i),
                    gameOver: state.gameOver,
                    winLine: state.winLine,
                  ),
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: state.gameOver
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: neonGreen.withOpacity(0.22),
                            foregroundColor: neonGreen,
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            shadowColor: neonGreen,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              letterSpacing: 1.5,
                            ),
                          ),
                          onPressed: () => context.read<GameCubit>().reset(),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                            child: Text('New Game'),
                          ),
                        ),
                      )
                    : const SizedBox(height: 64),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ModeSelector extends StatelessWidget {
  final GameMode mode;
  final ValueChanged<GameMode> onChanged;
  const _ModeSelector({required this.mode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [neonBlue.withOpacity(0.7), neonPink.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: neonBlue.withOpacity(0.18),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ModeButton(
            label: "Player vs Player",
            selected: mode == GameMode.pvp,
            neonColor: neonBlue,
            onTap: () => onChanged(GameMode.pvp),
          ),
          const SizedBox(width: 8),
          _ModeButton(
            label: "Player vs Computer",
            selected: mode == GameMode.pvc,
            neonColor: neonPink,
            onTap: () => onChanged(GameMode.pvc),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color neonColor;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.neonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: selected ? neonColor.withOpacity(0.22) : Colors.transparent,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: neonColor.withOpacity(0.7),
                    blurRadius: 22,
                    spreadRadius: 2,
                  ),
                ]
              : [],
          border: Border.all(
            color: neonColor,
            width: selected ? 2.5 : 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: neonColor,
            letterSpacing: 1.2,
            shadows: selected
                ? [
                    Shadow(blurRadius: 16, color: neonColor, offset: Offset(0, 0)),
                  ]
                : [],
          ),
        ),
      ),
    );
  }
}

class _GameBoard extends StatelessWidget {
  final List<String> board;
  final void Function(int) onCellTap;
  final bool gameOver;
  final List<int>? winLine;

  const _GameBoard({
    required this.board,
    required this.onCellTap,
    required this.gameOver,
    this.winLine,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [neonBlue.withOpacity(0.5), neonPink.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: neonBlue.withOpacity(0.2),
              blurRadius: 32,
              spreadRadius: 4,
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(18),
          itemCount: 9,
          itemBuilder: (context, idx) {
            final symbol = board[idx];
            final isWinCell = winLine?.contains(idx) ?? false;
            return GestureDetector(
              onTap: (!gameOver && symbol.isEmpty) ? () => onCellTap(idx) : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutExpo,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.black.withOpacity(0.24),
                  boxShadow: isWinCell
                      ? [
                          BoxShadow(
                            color: neonGreen.withOpacity(0.7),
                            blurRadius: 24,
                            spreadRadius: 2,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 10,
                          ),
                        ],
                  border: Border.all(
                    color: isWinCell ? neonGreen : Colors.white24,
                    width: isWinCell ? 3.5 : 1.5,
                  ),
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                    child: symbol.isEmpty
                        ? const SizedBox.shrink()
                        : _NeonSymbol(
                            symbol: symbol,
                            key: ValueKey(symbol + idx.toString()),
                          ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NeonSymbol extends StatelessWidget {
  final String symbol;
  const _NeonSymbol({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final color = symbol == 'X' ? neonBlue : neonPink;
    return Text(
      symbol,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 56,
        color: color,
        letterSpacing: 2.0,
        shadows: const [
          Shadow(blurRadius: 32, color: Colors.white24, offset: Offset(0, 0)),
        ],
      ),
    );
  }
}
