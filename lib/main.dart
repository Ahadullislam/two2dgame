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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic-Tac-Toe Futuristic',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
