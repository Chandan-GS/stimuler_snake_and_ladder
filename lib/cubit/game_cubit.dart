import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/constants.dart';
import 'game_state.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit() : super(_createInitialState());

  static GameState _createInitialState() {
    final layout = getRandomLayout();
    return GameState.initial(layout.snakes, layout.ladders);
  }

  final Random _rng = Random();
  Timer? _diceTimer;

  void rollDice() {
    if (state.phase != GamePhase.rolling || state.isRolling) return;

    emit(state.copyWith(isRolling: true, lastMoveResult: MoveResult.normal));
    int ticks = 0;
    _diceTimer = Timer.periodic(const Duration(milliseconds: 80), (t) {
      final newValue = _rng.nextInt(6) + 1;
      ticks++;
      emit(state.copyWith(diceValue: newValue));
      if (ticks >= 12) {
        t.cancel();
        emit(state.copyWith(isRolling: false));
        _applyMove();
      }
    });
  }

  void _applyMove() {
    int pos = state.currentPlayer == 1 ? state.player1Pos : state.player2Pos;

    if (pos == 0) {
      if (state.diceValue == 1 || state.diceValue == 6) {
        _setPos(1, MoveResult.normal, message: "Started adventure!");
        _endTurn();
      } else {
        emit(
          state.copyWith(
            message: "Need 1 or 6 to start!",
            lastMoveResult: MoveResult.normal,
          ),
        );
        _endTurn();
      }
      return;
    }

    int newPos = pos + state.diceValue;

    if (newPos > kTotalCells) {
      newPos = kTotalCells - (newPos - kTotalCells);
    }

    if (state.snakes.containsKey(newPos)) {
      final snakeTail = state.snakes[newPos]!;
      _setPos(
        newPos,
        MoveResult.snake,
        message: "🐍 Oops! Snake! Slide down...",
      );

      Future.delayed(const Duration(milliseconds: 700), () {
        _setPos(snakeTail, MoveResult.snake, message: "🐍 Slid to $snakeTail");
        _endTurn();
      });
    } else if (state.ladders.containsKey(newPos)) {
      final ladderTop = state.ladders[newPos]!;
      _setPos(newPos, MoveResult.ladder, message: "🪜 Ladder! Climb up...");

      Future.delayed(const Duration(milliseconds: 700), () {
        _setPos(
          ladderTop,
          MoveResult.ladder,
          message: "🪜 Climbed to $ladderTop",
        );
        _endTurn();
      });
    } else if (newPos == kTotalCells) {
      _setPos(
        newPos,
        MoveResult.win,
        message: "🎉 Player ${state.currentPlayer} wins!",
      );
      emit(
        state.copyWith(phase: GamePhase.gameOver, winner: state.currentPlayer),
      );
    } else {
      _setPos(newPos, MoveResult.normal, message: "Moved to $newPos");
      _endTurn();
    }
  }

  void _setPos(int pos, MoveResult result, {required String message}) {
    emit(
      state.copyWith(
        player1Pos: state.currentPlayer == 1 ? pos : state.player1Pos,
        player2Pos: state.currentPlayer == 2 ? pos : state.player2Pos,
        lastMoveResult: result,
        message: message,
      ),
    );
  }

  void _endTurn() {
    final nextPlayer = state.currentPlayer == 1 ? 2 : 1;
    emit(state.copyWith(phase: GamePhase.moving)); // Temporary wait phase

    Future.delayed(const Duration(milliseconds: 900), () {
      if (state.phase != GamePhase.gameOver) {
        emit(
          state.copyWith(
            currentPlayer: nextPlayer,
            phase: GamePhase.rolling,
            message: "Player $nextPlayer's turn — Roll the dice!",
          ),
        );
      }
    });
  }

  void resetGame() {
    _diceTimer?.cancel();
    emit(_createInitialState());
  }

  @override
  Future<void> close() {
    _diceTimer?.cancel();
    return super.close();
  }
}
