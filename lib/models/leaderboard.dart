class LeaderboardEntry {
  final String game;
  int wins;
  int losses;
  int draws;
  int? bestTimeSeconds; // lower is better; null means no record yet

  LeaderboardEntry({
    required this.game,
    this.wins = 0,
    this.losses = 0,
    this.draws = 0,
    this.bestTimeSeconds,
  });
}

class LeaderboardModel {
  static final LeaderboardModel _instance = LeaderboardModel._internal();
  factory LeaderboardModel() => _instance;
  LeaderboardModel._internal();

  final Map<String, LeaderboardEntry> _entries = {
    'Tic-Tac-Toe': LeaderboardEntry(game: 'Tic-Tac-Toe'),
    'Rock–Paper–Scissors': LeaderboardEntry(game: 'Rock–Paper–Scissors'),
    'Memory Match': LeaderboardEntry(game: 'Memory Match'),
    'Word Scramble': LeaderboardEntry(game: 'Word Scramble'),
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

  void recordTime(String game, int seconds) {
    final entry = _entries[game];
    if (entry == null) return;
    if (seconds < 0) return;
    if (entry.bestTimeSeconds == null || seconds < entry.bestTimeSeconds!) {
      entry.bestTimeSeconds = seconds;
    }
  }

  void reset() {
    for (final entry in _entries.values) {
      entry.wins = 0;
      entry.losses = 0;
      entry.draws = 0;
      entry.bestTimeSeconds = null;
    }
  }
}
