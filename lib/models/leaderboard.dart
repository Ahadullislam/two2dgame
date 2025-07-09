class LeaderboardEntry {
  final String game;
  int wins;
  int losses;
  int draws;

  LeaderboardEntry({required this.game, this.wins = 0, this.losses = 0, this.draws = 0});
}

class LeaderboardModel {
  static final LeaderboardModel _instance = LeaderboardModel._internal();
  factory LeaderboardModel() => _instance;
  LeaderboardModel._internal();

  final Map<String, LeaderboardEntry> _entries = {
    'Tic-Tac-Toe': LeaderboardEntry(game: 'Tic-Tac-Toe'),
    'Rock–Paper–Scissors': LeaderboardEntry(game: 'Rock–Paper–Scissors'),
  };

  List<LeaderboardEntry> get entries => _entries.values.toList();

  void recordResult(String game, {bool? win, bool? draw}) {
    final entry = _entries[game];
    if (entry == null) return;
    if (draw == true) {
      entry.draws++;
    } else if (win == true) {
      entry.wins++;
    } else {
      entry.losses++;
    }
  }

  void reset() {
    for (final entry in _entries.values) {
      entry.wins = 0;
      entry.losses = 0;
      entry.draws = 0;
    }
  }
}
