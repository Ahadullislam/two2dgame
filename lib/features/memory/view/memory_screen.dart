import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/memory_cubit.dart';
import '../models/memory_card.dart';

const neonBlue = Color(0xFF00F0FF);
const neonPink = Color(0xFFFF00E0);
const neonGreen = Color(0xFF39FF14);
const neonPurple = Color(0xFF9D00FF);

class MemoryScreen extends StatelessWidget {
  const MemoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Memory Match'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'New Game',
            onPressed: () => context.read<MemoryCubit>().reset(),
            color: neonGreen,
          ),
        ],
      ),
      body: BlocBuilder<MemoryCubit, MemoryState>(
        builder: (context, state) {
          return Column(
            children: [
              const SizedBox(height: 16),
              _StatsBar(moves: state.moves, seconds: state.seconds, completed: state.completed),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: state.deck.length,
                    itemBuilder: (context, i) => _MemoryCardTile(
                      card: state.deck[i],
                      onTap: () => context.read<MemoryCubit>().flip(i),
                      lock: state.isBusy,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final int moves;
  final int seconds;
  final bool completed;
  const _StatsBar({required this.moves, required this.seconds, required this.completed});

  @override
  Widget build(BuildContext context) {
    String mm = (seconds ~/ 60).toString().padLeft(2, '0');
    String ss = (seconds % 60).toString().padLeft(2, '0');
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _chip(icon: Icons.timer, label: '$mm:$ss', color: neonBlue),
        const SizedBox(width: 10),
        _chip(icon: Icons.touch_app, label: '$moves moves', color: neonPink),
        const SizedBox(width: 10),
        _chip(icon: completed ? Icons.check_circle : Icons.sports_esports, label: completed ? 'Completed' : 'Playing', color: neonGreen),
      ],
    );
  }

  Widget _chip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withOpacity(0.16),
        border: Border.all(color: color, width: 1.6),
        boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _MemoryCardTile extends StatelessWidget {
  final MemoryCard card;
  final VoidCallback onTap;
  final bool lock;
  const _MemoryCardTile({required this.card, required this.onTap, required this.lock});

  @override
  Widget build(BuildContext context) {
    final color = card.isMatched ? neonGreen : (card.isFlipped ? neonBlue : Colors.white24);
    return GestureDetector(
      onTap: (!lock && !card.isMatched && !card.isFlipped) ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black.withOpacity(0.24),
          border: Border.all(color: color, width: 2.0),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.35), blurRadius: 12, spreadRadius: 1),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
            child: card.isFlipped || card.isMatched
                ? Text(
                    card.emoji,
                    key: ValueKey('${card.id}-open'),
                    style: const TextStyle(fontSize: 28),
                  )
                : Icon(Icons.question_mark, key: ValueKey('${card.id}-closed'), color: Colors.white38),
          ),
        ),
      ),
    );
  }
}
