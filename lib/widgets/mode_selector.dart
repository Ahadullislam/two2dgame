import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum GameMode { pvp, pvc }

class ModeSelector extends StatelessWidget {
  final GameMode mode;
  final ValueChanged<GameMode> onChanged;
  const ModeSelector({Key? key, required this.mode, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [AppTheme.neonBlue.withOpacity(0.7), AppTheme.neonPink.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.neonBlue.withOpacity(0.18),
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
            neonColor: AppTheme.neonBlue,
            onTap: () => onChanged(GameMode.pvp),
          ),
          const SizedBox(width: 8),
          _ModeButton(
            label: "Player vs Computer",
            selected: mode == GameMode.pvc,
            neonColor: AppTheme.neonPink,
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
