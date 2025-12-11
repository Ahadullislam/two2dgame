import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/leaderboard.dart';

class RpsState extends Equatable {
  final String? playerChoice;
  final String? aiChoice;
  final String? result;

  const RpsState({this.playerChoice, this.aiChoice, this.result});

  RpsState copyWith({String? playerChoice, String? aiChoice, String? result}) {
    return RpsState(
      playerChoice: playerChoice,
      aiChoice: aiChoice,
      result: result,
    );
  }

  factory RpsState.initial() => const RpsState();

  @override
  List<Object?> get props => [playerChoice, aiChoice, result];
}

class RpsCubit extends Cubit<RpsState> {
  RpsCubit() : super(RpsState.initial());

  static const choices = ['Rock', 'Paper', 'Scissors'];

  void play(int idx) {
    final aiIdx = DateTime.now().millisecondsSinceEpoch % 3;
    final res = _determineResult(idx, aiIdx);
    emit(RpsState(
      playerChoice: choices[idx],
      aiChoice: choices[aiIdx],
      result: res,
    ));
    if (res == 'Draw!') {
      LeaderboardModel().recordResult('Rock–Paper–Scissors', draw: true);
    } else if (res == 'You Win!') {
      LeaderboardModel().recordResult('Rock–Paper–Scissors', win: true);
    } else if (res == 'AI Wins!') {
      LeaderboardModel().recordResult('Rock–Paper–Scissors');
    }
  }

  String _determineResult(int player, int ai) {
    if (player == ai) return 'Draw!';
    if ((player == 0 && ai == 2) || (player == 1 && ai == 0) || (player == 2 && ai == 1)) {
      return 'You Win!';
    }
    return 'AI Wins!';
  }

  void reset() => emit(RpsState.initial());
}
