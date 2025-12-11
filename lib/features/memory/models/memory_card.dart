class MemoryCard {
  final int id;
  final String emoji;
  final bool isFlipped;
  final bool isMatched;

  const MemoryCard({
    required this.id,
    required this.emoji,
    this.isFlipped = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({bool? isFlipped, bool? isMatched}) => MemoryCard(
        id: id,
        emoji: emoji,
        isFlipped: isFlipped ?? this.isFlipped,
        isMatched: isMatched ?? this.isMatched,
      );
}
