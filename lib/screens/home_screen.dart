import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/theme_cubit.dart';
import '../widgets/animated_particles_background.dart';
import '../utils/sound_player.dart';

const neonBlue = Color(0xFF00F0FF);
const neonPink = Color(0xFFFF00E0);
const neonGreen = Color(0xFF39FF14);
const neonPurple = Color(0xFF9D00FF);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('2D Game Hub'),
        actions: [
          IconButton(
            tooltip: 'Toggle theme',
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => context.read<ThemeCubit>().toggle(),
          ),
        ],
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          const AnimatedParticlesBackground(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text(
                  'Mini Game Hub',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 34,
                    color: neonBlue,
                    letterSpacing: 2.5,
                    shadows: [
                      Shadow(blurRadius: 18, color: neonBlue, offset: Offset(0, 0)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Choose a game',
                  style: TextStyle(
                    color: neonPink,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(blurRadius: 10, color: neonPink, offset: Offset(0, 0)),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 24,
                  runSpacing: 24,
                  children: [
                    _GameCard(
                      title: 'Tic-Tac-Toe',
                      icon: Icons.grid_3x3,
                      color: neonBlue,
                      onTap: () {
                        SoundPlayer.play('tap.mp3');
                        Navigator.pushNamed(context, '/tictactoe');
                      },
                    ),
                    _GameCard(
                      title: 'Rock–Paper–Scissors',
                      icon: Icons.sports_mma,
                      color: neonPink,
                      onTap: () {
                        SoundPlayer.play('tap.mp3');
                        Navigator.pushNamed(context, '/rps');
                      },
                    ),
                    _GameCard(
                      title: 'Word Scramble',
                      icon: Icons.spellcheck,
                      color: neonBlue,
                      onTap: () {
                        SoundPlayer.play('tap.mp3');
                        Navigator.pushNamed(context, '/wordscramble');
                      },
                    ),
                    _GameCard(
                      title: 'Memory Match',
                      icon: Icons.grid_view,
                      color: neonPurple,
                      onTap: () {
                        SoundPlayer.play('tap.mp3');
                        Navigator.pushNamed(context, '/memory');
                      },
                    ),
                    _GameCard(
                      title: 'Leaderboard',
                      icon: Icons.emoji_events,
                      color: neonGreen,
                      onTap: () {
                        SoundPlayer.play('tap.mp3');
                        Navigator.pushNamed(context, '/leaderboard');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Optional: Add more cards, leaderboard, profile, etc.
              ],
            ),
          ),
          )],
      ),
    );
  }
}

class _GameCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _GameCard({required this.title, required this.icon, required this.color, required this.onTap});

  @override
  State<_GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<_GameCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.08,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) => _controller.reverse();
  void _onTapCancel() => _controller.reverse();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 - _controller.value,
            child: child,
          );
        },
        child: Container(
          width: 150,
          height: 180,
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              colors: [widget.color.withOpacity(0.25), Colors.white10],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.5),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
            border: Border.all(
              color: widget.color,
              width: 2.5,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 54, color: widget.color),
              const SizedBox(height: 18),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: widget.color,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(blurRadius: 12, color: widget.color, offset: Offset(0, 0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
