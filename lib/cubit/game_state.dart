import 'package:equatable/equatable.dart';

enum GamePhase { rolling, moving, gameOver }
enum MoveResult { normal, ladder, snake, win }

class GameState extends Equatable {
  final int player1Pos;
  final int player2Pos;
  final int currentPlayer;
  final int diceValue;
  final bool isRolling;
  final GamePhase phase;
  final String message;
  final int? winner;
  final MoveResult lastMoveResult;
  final Map<int, int> snakes;
  final Map<int, int> ladders;

  const GameState({
    required this.player1Pos,
    required this.player2Pos,
    required this.currentPlayer,
    required this.diceValue,
    required this.isRolling,
    required this.phase,
    required this.message,
    required this.snakes,
    required this.ladders,
    this.winner,
    this.lastMoveResult = MoveResult.normal,
  });

  factory GameState.initial(Map<int, int> snakes, Map<int, int> ladders) {
    return GameState(
      player1Pos: 0,
      player2Pos: 0,
      currentPlayer: 1,
      diceValue: 1,
      isRolling: false,
      phase: GamePhase.rolling,
      message: "Player 1's turn!",
      snakes: snakes,
      ladders: ladders,
    );
  }

  GameState copyWith({
    int? player1Pos,
    int? player2Pos,
    int? currentPlayer,
    int? diceValue,
    bool? isRolling,
    GamePhase? phase,
    String? message,
    int? winner,
    MoveResult? lastMoveResult,
    Map<int, int>? snakes,
    Map<int, int>? ladders,
  }) {
    return GameState(
      player1Pos: player1Pos ?? this.player1Pos,
      player2Pos: player2Pos ?? this.player2Pos,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      diceValue: diceValue ?? this.diceValue,
      isRolling: isRolling ?? this.isRolling,
      phase: phase ?? this.phase,
      message: message ?? this.message,
      winner: winner ?? this.winner,
      lastMoveResult: lastMoveResult ?? this.lastMoveResult,
      snakes: snakes ?? this.snakes,
      ladders: ladders ?? this.ladders,
    );
  }

  @override
  List<Object?> get props => [
        player1Pos,
        player2Pos,
        currentPlayer,
        diceValue,
        isRolling,
        phase,
        message,
        winner,
        lastMoveResult,
        snakes,
        ladders,
      ];
}
