import 'dart:math';

class BoardLayout {
  final Map<int, int> snakes;
  final Map<int, int> ladders;

  const BoardLayout({required this.snakes, required this.ladders});
}

const List<BoardLayout> kBoardLayouts = [
  // Layout 0: Classic
  BoardLayout(
    snakes: {99: 41, 89: 53, 76: 58, 66: 45, 54: 31, 43: 18, 40: 3, 27: 5},
    ladders: {
      2: 23,
      8: 34,
      20: 77,
      32: 68,
      41: 62,
      51: 67,
      63: 81,
      71: 91,
      78: 98,
    },
  ),
  // Layout 1: The Danger Zone
  BoardLayout(
    snakes: {98: 13, 92: 51, 83: 22, 69: 33, 59: 17, 46: 5, 41: 20, 31: 14},
    ladders: {4: 25, 12: 49, 21: 60, 36: 55, 43: 80, 52: 73, 61: 97, 75: 86},
  ),
  // Layout 2: Fast Track
  BoardLayout(
    snakes: {97: 78, 95: 56, 88: 24, 73: 15, 62: 19, 48: 9, 38: 2, 28: 10},
    ladders: {
      3: 39,
      11: 50,
      16: 44,
      25: 64,
      33: 74,
      45: 85,
      57: 96,
      65: 87,
      72: 90,
    },
  ),
];

const int kTotalCells = 100;

BoardLayout getRandomLayout() {
  final random = Random();
  return kBoardLayouts[random.nextInt(kBoardLayouts.length)];
}
