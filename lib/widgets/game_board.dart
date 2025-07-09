import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GameBoard extends StatelessWidget {
  final List<String> board;
  final void Function(int) onCellTap;
  final bool gameOver;
  final List<int>? winLine;

  const GameBoard({
    Key? key,
    required this.board,
    required this.onCellTap,
    required this.gameOver,
    this.winLine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final neonColors = [AppTheme.neonBlue, AppTheme.neonPink, AppTheme.neonGreen, AppTheme.neonPurple];
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [AppTheme.neonBlue.withOpacity(0.5), AppTheme.neonPink.withOpacity(0.4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.neonBlue.withOpacity(0.2),
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
                            color: AppTheme.neonGreen.withOpacity(0.7),
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
                    color: isWinCell ? AppTheme.neonGreen : Colors.white24,
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
  const _NeonSymbol({Key? key, required this.symbol}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = symbol == 'X' ? AppTheme.neonBlue : AppTheme.neonPink;
    return Text(
      symbol,
      style: TextStyle(

        fontWeight: FontWeight.w900,
        fontSize: 56,
        color: color,
        letterSpacing: 2.0,
        shadows: [
          Shadow(blurRadius: 32, color: color, offset: Offset(0, 0)),
          Shadow(blurRadius: 8, color: color.withOpacity(0.6), offset: Offset(0, 0)),
        ],
      ),
    );
  }
}
