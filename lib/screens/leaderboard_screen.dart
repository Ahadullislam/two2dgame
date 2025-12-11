import 'package:flutter/material.dart';
import '../models/leaderboard.dart';

const neonBlue = Color(0xFF00F0FF);
const neonPink = Color(0xFFFF00E0);
const neonGreen = Color(0xFF39FF14);
const neonPurple = Color(0xFF9D00FF);

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = LeaderboardModel().entries;
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset Leaderboard',
            onPressed: () {
              LeaderboardModel().reset();
              (context as Element).markNeedsBuild();
            },
            color: neonPink,
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [neonBlue.withOpacity(0.12), neonPink.withOpacity(0.09)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: neonBlue.withOpacity(0.18),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: neonBlue,
              width: 2.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Stats',
                style: TextStyle(
                  color: neonBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  letterSpacing: 2.0,
                  shadows: [Shadow(blurRadius: 12, color: neonBlue)],
                ),
              ),
              const SizedBox(height: 18),
              ...entries.map((entry) => _LeaderboardRow(entry: entry)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  const _LeaderboardRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            entry.game,
            style: TextStyle(
              color: neonPink,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              shadows: [Shadow(blurRadius: 8, color: neonPink)],
            ),
          ),
          Row(
            children: [
              _StatBox(label: 'Wins', value: entry.wins, color: neonGreen),
              const SizedBox(width: 10),
              _StatBox(label: 'Losses', value: entry.losses, color: neonPink),
              const SizedBox(width: 10),
              _StatBox(label: 'Draws', value: entry.draws, color: neonBlue),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.14),
        border: Border.all(color: color, width: 1.4),
        boxShadow: [BoxShadow(color: color.withOpacity(0.17), blurRadius: 6)],
      ),
      child: Column(
        children: [
          Text('$value', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
