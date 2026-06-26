import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../cubit/game_cubit.dart';
import '../../cubit/game_state.dart';
import '../../cubit/settings_cubit.dart';
import '../widgets/board_widget.dart';
import '../widgets/dice_widget.dart';
import '../widgets/player_card.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xFF2D6A4F),
              AppColors.backgroundDark,
            ],
            center: Alignment.center,
            radius: 1.2,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: BlocBuilder<GameCubit, GameState>(
                        builder: (context, state) {
                          return BoardWidget(state: state);
                        },
                      ),
                    ),
                  ),
                ),
              ),
              _buildBottomPanel(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
      child: Row(
        children: [
          Text(
            '🐍 Snakes & Ladders',
            style: AppTextStyles.headline2.copyWith(
              color: AppColors.safeZoneGold,
              fontSize: 20,
              shadows: [
                const Shadow(color: Colors.black54, offset: Offset(1, 1), blurRadius: 4),
              ]
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: () => context.read<GameCubit>().resetGame(),
            tooltip: 'New Game',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.jungleGreen.withValues(alpha: 0.4),
            border: Border(
              top: BorderSide(color: AppColors.mossGreen.withValues(alpha: 0.3), width: 1.5),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
          child: BlocBuilder<GameCubit, GameState>(
            builder: (context, state) {
              final settings = context.watch<SettingsCubit>().state;
              
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: PlayerCard(
                          playerNum: 1,
                          playerName: settings.player1Name,
                          pos: state.player1Pos,
                          isActive: state.currentPlayer == 1 && state.phase != GamePhase.gameOver,
                          color: AppColors.playerOneColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: state.phase == GamePhase.rolling && !state.isRolling
                            ? () => context.read<GameCubit>().rollDice()
                            : null,
                        child: DiceWidget(
                          value: state.diceValue,
                          rolling: state.isRolling,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PlayerCard(
                          playerNum: 2,
                          playerName: settings.player2Name,
                          pos: state.player2Pos,
                          isActive: state.currentPlayer == 2 && state.phase != GamePhase.gameOver,
                          color: AppColors.playerTwoColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 48,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        state.message,
                        key: ValueKey(state.message),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          shadows: [
                            const Shadow(color: Colors.black87, offset: Offset(1, 1), blurRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (state.phase == GamePhase.gameOver)
                    Column(
                      children: [
                        Text(
                          '🏆 ${state.winner == 1 ? settings.player1Name : settings.player2Name} Wins!',
                          style: AppTextStyles.headline2.copyWith(color: AppColors.safeZoneGold),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context.read<GameCubit>().resetGame(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.safeZoneGold,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            'Play Again',
                            style: AppTextStyles.button.copyWith(color: Colors.black),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (state.isRolling || state.phase == GamePhase.moving) 
                            ? null 
                            : () => context.read<GameCubit>().rollDice(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: state.currentPlayer == 1
                              ? AppColors.playerOneColor
                              : AppColors.playerTwoColor,
                          disabledBackgroundColor: Colors.white24,
                          disabledForegroundColor: Colors.white54,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: state.isRolling ? 0 : 8,
                        ),
                        child: Text(
                          state.isRolling
                              ? 'Rolling...'
                              : (state.phase == GamePhase.moving 
                                  ? 'Moving...' 
                                  : '${state.currentPlayer == 1 ? settings.player1Name : settings.player2Name} — Roll Dice 🎲'),
                          style: AppTextStyles.button,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
