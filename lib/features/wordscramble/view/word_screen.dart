import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/word_cubit.dart';

const neonBlue = Color(0xFF00F0FF);
const neonPink = Color(0xFFFF00E0);
const neonGreen = Color(0xFF39FF14);

class WordScreen extends StatelessWidget {
  const WordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Word Scramble'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'New Word',
            onPressed: () => context.read<WordCubit>().next(),
            color: neonGreen,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<WordCubit, WordState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  'Unscramble the word:',
                  style: TextStyle(color: neonBlue, fontWeight: FontWeight.bold, fontSize: 20, shadows: [Shadow(blurRadius: 8, color: neonBlue)]),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: neonPink.withOpacity(0.12),
                    border: Border.all(color: neonPink, width: 2),
                  ),
                  child: Text(
                    state.scrambled.toUpperCase(),
                    style: TextStyle(color: neonPink, fontWeight: FontWeight.w800, fontSize: 28, letterSpacing: 6),
                  ),
                ),
                const SizedBox(height: 26),
                TextField(
                  enabled: !state.correct,
                  onChanged: (v) => context.read<WordCubit>().updateInput(v),
                  decoration: InputDecoration(
                    hintText: 'Type your guess...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: state.correct ? null : () => context.read<WordCubit>().submit(),
                      icon: const Icon(Icons.check),
                      label: const Text('Submit'),
                      style: ElevatedButton.styleFrom(backgroundColor: neonGreen.withOpacity(0.2), foregroundColor: neonGreen),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: state.correct ? null : () => context.read<WordCubit>().skip(),
                      icon: const Icon(Icons.skip_next),
                      label: const Text('Skip'),
                      style: OutlinedButton.styleFrom(foregroundColor: neonBlue, side: BorderSide(color: neonBlue)),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: state.correct
                      ? Text(
                          'Correct! The word was "${state.original}"',
                          key: const ValueKey('ok'),
                          style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold, fontSize: 18),
                        )
                      : const SizedBox.shrink(),
                ),
                if (state.correct) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.read<WordCubit>().next(),
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Next Word'),
                        style: ElevatedButton.styleFrom(backgroundColor: neonBlue.withOpacity(0.2), foregroundColor: neonBlue),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Exit'),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.white70, side: const BorderSide(color: Colors.white38)),
                      ),
                    ],
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
