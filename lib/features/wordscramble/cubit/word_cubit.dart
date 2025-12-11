import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/leaderboard.dart';
import 'dart:math';

class WordState extends Equatable {
  final String original;
  final String scrambled;
  final String input;
  final bool correct;
  final int index;

  const WordState({
    required this.original,
    required this.scrambled,
    required this.input,
    required this.correct,
    required this.index,
  });

  factory WordState.initial(String original, String scrambled, int index) =>
      WordState(original: original, scrambled: scrambled, input: '', correct: false, index: index);

  WordState copyWith({String? original, String? scrambled, String? input, bool? correct, int? index}) => WordState(
        original: original ?? this.original,
        scrambled: scrambled ?? this.scrambled,
        input: input ?? this.input,
        correct: correct ?? this.correct,
        index: index ?? this.index,
      );

  @override
  List<Object?> get props => [original, scrambled, input, correct, index];
}

class WordCubit extends Cubit<WordState> {
  DateTime? _startAt;
  WordCubit() : super(_first()) {
    _startAt = DateTime.now();
  }

  static const _words = [
    'apple', 'river', 'chair', 'phone', 'light', 'music', 'plane', 'green', 'smile', 'storm',
    'cloud', 'dance', 'brain', 'clear', 'quick', 'simple', 'garden', 'winter', 'summer', 'yellow'
  ];

  static List<String> get _pool =>
      _words.where((w) => w.length >= 4 && w.length <= 9).toList(growable: false);

  static WordState _first() {
    final idx = 0;
    final word = _pool[idx];
    return WordState.initial(word, _scramble(word), idx);
  }

  static String _scramble(String s) {
    if (s.length < 2) return s;
    final rand = Random();
    final chars = s.split('');
    for (int i = chars.length - 1; i > 0; i--) {
      final j = rand.nextInt(i + 1);
      final tmp = chars[i];
      chars[i] = chars[j];
      chars[j] = tmp;
    }
    final out = chars.join();
    if (out == s) {
      // ensure different from original by swapping first two letters
      if (chars.length >= 2) {
        final t = chars[0];
        chars[0] = chars[1];
        chars[1] = t;
      }
      return chars.join();
    }
    return out;
  }

  void updateInput(String value) {
    emit(state.copyWith(input: value, correct: false));
  }

  void submit() {
    final ok = state.input.trim().toLowerCase() == state.original.toLowerCase();
    emit(state.copyWith(correct: ok));
    if (ok) {
      LeaderboardModel().recordResult('Word Scramble', win: true);
      if (_startAt != null) {
        final seconds = DateTime.now().difference(_startAt!).inSeconds;
        LeaderboardModel().recordTime('Word Scramble', seconds);
      }
    }
  }

  void next() {
    final pool = _pool;
    final nextIdx = (state.index + 1) % pool.length;
    final word = pool[nextIdx];
    emit(WordState.initial(word, _scramble(word), nextIdx));
    _startAt = DateTime.now();
  }

  void skip() => next();
}
