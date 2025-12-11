import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/memory_card.dart';
import '../../../models/leaderboard.dart';

class MemoryState extends Equatable {
  final List<MemoryCard> deck;
  final int moves;
  final int seconds;
  final bool isBusy;
  final bool completed;

  const MemoryState({
    required this.deck,
    required this.moves,
    required this.seconds,
    required this.isBusy,
    required this.completed,
  });

  factory MemoryState.initial(List<MemoryCard> deck) => MemoryState(
        deck: deck,
        moves: 0,
        seconds: 0,
        isBusy: false,
        completed: false,
      );

  MemoryState copyWith({
    List<MemoryCard>? deck,
    int? moves,
    int? seconds,
    bool? isBusy,
    bool? completed,
  }) => MemoryState(
        deck: deck ?? this.deck,
        moves: moves ?? this.moves,
        seconds: seconds ?? this.seconds,
        isBusy: isBusy ?? this.isBusy,
        completed: completed ?? this.completed,
      );

  @override
  List<Object?> get props => [deck, moves, seconds, isBusy, completed];
}

class MemoryCubit extends Cubit<MemoryState> {
  Timer? _timer;
  MemoryCubit() : super(MemoryState.initial(_makeShuffledDeck()));

  static final _emojis = ['🍎','🍌','🍇','🍉','🍓','🍒','🍍','🥝'];

  static List<MemoryCard> _makeShuffledDeck() {
    final cards = <MemoryCard>[];
    int id = 0;
    for (final e in _emojis) {
      cards.add(MemoryCard(id: id++, emoji: e));
      cards.add(MemoryCard(id: id++, emoji: e));
    }
    cards.shuffle(Random());
    return cards;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(state.copyWith(seconds: state.seconds + 1));
    });
  }

  void reset() {
    _timer?.cancel();
    emit(MemoryState.initial(_makeShuffledDeck()));
  }

  Future<void> flip(int index) async {
    if (state.isBusy || state.completed) return;
    final card = state.deck[index];
    if (card.isMatched || card.isFlipped) return;

    // Start timer on first flip
    if (state.moves == 0 && state.seconds == 0 && !_hasAnyFlipped()) {
      _startTimer();
    }

    var deck = List<MemoryCard>.from(state.deck);
    deck[index] = deck[index].copyWith(isFlipped: true);

    final open = _openCards(deck);

    if (open.length == 2) {
      emit(state.copyWith(deck: deck, isBusy: true, moves: state.moves + 1));
      await Future.delayed(const Duration(milliseconds: 700));
      final a = deck[open[0]];
      final b = deck[open[1]];
      if (a.emoji == b.emoji) {
        deck[open[0]] = a.copyWith(isMatched: true);
        deck[open[1]] = b.copyWith(isMatched: true);
      } else {
        deck[open[0]] = a.copyWith(isFlipped: false);
        deck[open[1]] = b.copyWith(isFlipped: false);
      }
      final done = deck.every((c) => c.isMatched);
      if (done) {
        _timer?.cancel();
        // Record Memory Match completion as a win
        LeaderboardModel().recordResult('Memory Match', win: true);
        // Record best time in seconds
        LeaderboardModel().recordTime('Memory Match', state.seconds);
      }
      emit(state.copyWith(deck: deck, isBusy: false, completed: done));
    } else {
      emit(state.copyWith(deck: deck));
    }
  }

  bool _hasAnyFlipped() => state.deck.any((c) => c.isFlipped || c.isMatched);

  List<int> _openCards(List<MemoryCard> deck) {
    final idxs = <int>[];
    for (int i = 0; i < deck.length; i++) {
      if (deck[i].isFlipped && !deck[i].isMatched) idxs.add(i);
      if (idxs.length == 2) break;
    }
    return idxs;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
