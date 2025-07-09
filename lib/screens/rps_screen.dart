import 'package:flutter/material.dart';

const neonBlue = Color(0xFF00F0FF);
const neonPink = Color(0xFFFF00E0);
const neonGreen = Color(0xFF39FF14);
const neonPurple = Color(0xFF9D00FF);

class RPSScreen extends StatefulWidget {
  const RPSScreen({Key? key}) : super(key: key);

  @override
  State<RPSScreen> createState() => _RPSScreenState();
}

class _RPSScreenState extends State<RPSScreen> {
  String? _playerChoice;
  String? _aiChoice;
  String? _result;

  static const choices = ['Rock', 'Paper', 'Scissors'];
  static const icons = [Icons.pan_tool, Icons.description, Icons.content_cut];
  static const colors = [neonBlue, neonPink, neonGreen];

  void _play(int idx) {
    final aiIdx = (DateTime.now().millisecondsSinceEpoch % 3);
    setState(() {
      _playerChoice = choices[idx];
      _aiChoice = choices[aiIdx];
      _result = _determineResult(idx, aiIdx);
    });
  }

  String _determineResult(int player, int ai) {
    if (player == ai) return 'Draw!';
    if ((player == 0 && ai == 2) || (player == 1 && ai == 0) || (player == 2 && ai == 1)) {
      return 'You Win!';
    }
    return 'AI Wins!';
  }

  void _reset() {
    setState(() {
      _playerChoice = null;
      _aiChoice = null;
      _result = null;
    });
  }

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
            onPressed: _reset,
            color: neonGreen,
          ),
        ],
      ),
      body: Column(
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
              label: choices[i],
              color: colors[i],
              selected: _playerChoice == choices[i],
              onTap: () => _play(i),
            )),
          ),
          const SizedBox(height: 40),
          if (_playerChoice != null && _aiChoice != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // User's choice icon
                  AnimatedScale(
                    scale: 1.25,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.elasticOut,
                    child: _ChoiceDisplay(
                      icon: icons[choices.indexOf(_playerChoice!)],
                      label: _playerChoice!,
                      color: colors[choices.indexOf(_playerChoice!)],
                      isUser: true,
                    ),
                  ),
                  const SizedBox(width: 22),
                  // Animated result text
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                    child: Text(
                      _result ?? '',
                      key: ValueKey(_result),
                      style: TextStyle(
                        color: _result == 'You Win!' ? neonGreen : (_result == 'Draw!' ? neonBlue : neonPink),
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        letterSpacing: 2.0,
                        shadows: [Shadow(blurRadius: 14, color: neonGreen)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 22),
                  // AI's choice icon
                  _ChoiceDisplay(
                    icon: icons[choices.indexOf(_aiChoice!)],
                    label: _aiChoice!,
                    color: colors[choices.indexOf(_aiChoice!)],
                    isUser: false,
                  ),
                ],
              ),
            ),
        ],
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
