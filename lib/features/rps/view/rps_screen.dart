import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../rps/cubit/rps_cubit.dart';

const neonBlue = Color(0xFF00F0FF);
const neonPink = Color(0xFFFF00E0);
const neonGreen = Color(0xFF39FF14);
const neonPurple = Color(0xFF9D00FF);

class RPSScreen extends StatelessWidget {
  const RPSScreen({super.key});

  static const icons = [Icons.pan_tool, Icons.description, Icons.content_cut];
  static const colors = [neonBlue, neonPink, neonGreen];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181A20),
      appBar: AppBar(
        title: const Text('Rock–Paper–Scissors'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset',
            onPressed: () => context.read<RpsCubit>().reset(),
            color: neonGreen,
          ),
        ],
      ),
      body: BlocBuilder<RpsCubit, RpsState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose your move:',
                style: TextStyle(
                  color: neonPink,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  letterSpacing: 1.2,
                  shadows: [Shadow(blurRadius: 8, color: neonPink)],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) => _ChoiceButton(
                      icon: icons[i],
                      label: RpsCubit.choices[i],
                      color: colors[i],
                      selected: state.playerChoice == RpsCubit.choices[i],
                      onTap: () => context.read<RpsCubit>().play(i),
                    )),
              ),
              const SizedBox(height: 40),
              if (state.playerChoice != null && state.aiChoice != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AnimatedScale(
                        scale: 1.25,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.elasticOut,
                        child: _ChoiceDisplay(
                          icon: icons[RpsCubit.choices.indexOf(state.playerChoice!)],
                          label: state.playerChoice!,
                          color: colors[RpsCubit.choices.indexOf(state.playerChoice!)],
                          isUser: true,
                        ),
                      ),
                      const SizedBox(width: 22),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                        child: Text(
                          state.result ?? '',
                          key: ValueKey(state.result),
                          style: TextStyle(
                            color: state.result == 'You Win!'
                                ? neonGreen
                                : (state.result == 'Draw!' ? neonBlue : neonPink),
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            letterSpacing: 2.0,
                            shadows: [Shadow(blurRadius: 14, color: neonGreen)],
                          ),
                        ),
                      ),
                      const SizedBox(width: 22),
                      _ChoiceDisplay(
                        icon: icons[RpsCubit.choices.indexOf(state.aiChoice!)],
                        label: state.aiChoice!,
                        color: colors[RpsCubit.choices.indexOf(state.aiChoice!)],
                        isUser: false,
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ChoiceDisplay extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isUser;
  const _ChoiceDisplay({required this.icon, required this.label, required this.color, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [color.withOpacity(0.28), Colors.white10],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
            border: Border.all(
              color: color,
              width: 2.4,
            ),
          ),
          child: Icon(icon, size: 36, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          isUser ? 'You' : 'AI',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
            shadows: [Shadow(blurRadius: 8, color: color)],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;
  const _ChoiceButton({required this.icon, required this.label, required this.color, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 88,
        height: 110,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.25), Colors.white10],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
          border: Border.all(
            color: color,
            width: selected ? 3.2 : 1.6,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 38, color: color),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: color,
                letterSpacing: 1.1,
                shadows: [Shadow(blurRadius: 8, color: color)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
