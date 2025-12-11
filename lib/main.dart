import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'features/tictactoe/view/game_screen.dart' as ttt;
import 'features/rps/view/rps_screen.dart' as rps;
import 'features/memory/view/memory_screen.dart' as memory;
import 'features/tictactoe/cubit/game_cubit.dart';
import 'features/rps/cubit/rps_cubit.dart';
import 'features/memory/cubit/memory_cubit.dart';
import 'features/wordscramble/view/word_screen.dart' as ws;
import 'features/wordscramble/cubit/word_cubit.dart';
import 'cubit/theme_cubit.dart';

void main() {
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        return MaterialApp(
          title: 'Tic-Tac-Toe Futuristic',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: mode,
          home: const HomeScreen(),
          routes: {
            '/tictactoe': (context) => BlocProvider(
                  create: (_) => GameCubit(),
                  child: const ttt.GameScreen(),
                ),
            '/rps': (context) => BlocProvider(
                  create: (_) => RpsCubit(),
                  child: const rps.RPSScreen(),
                ),
            '/memory': (context) => BlocProvider(
                  create: (_) => MemoryCubit(),
                  child: const memory.MemoryScreen(),
                ),
            '/wordscramble': (context) => BlocProvider(
                  create: (_) => WordCubit(),
                  child: const ws.WordScreen(),
                ),
            '/leaderboard': (context) => const LeaderboardScreen(),
          },
        );
      },
    );
  }
}
