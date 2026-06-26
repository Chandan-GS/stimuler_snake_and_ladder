import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme.dart';
import '../../cubit/settings_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _p1Controller;
  late TextEditingController _p2Controller;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsCubit>().state;
    _p1Controller = TextEditingController(text: settings.player1Name);
    _p2Controller = TextEditingController(text: settings.player2Name);
  }

  @override
  void dispose() {
    _p1Controller.dispose();
    _p2Controller.dispose();
    super.dispose();
  }

  void _save() {
    final p1 = _p1Controller.text.trim().isEmpty ? 'Player 1' : _p1Controller.text.trim();
    final p2 = _p2Controller.text.trim().isEmpty ? 'Player 2' : _p2Controller.text.trim();
    context.read<SettingsCubit>().saveSettings(p1, p2);
    context.pop();
  }

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
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('Settings', style: AppTextStyles.headline2),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Player Configuration', style: AppTextStyles.bodyMuted),
                      const SizedBox(height: 24),
                      _buildPlayerInput(
                        'Player 1 Name',
                        _p1Controller,
                        AppColors.playerOneColor,
                      ),
                      const SizedBox(height: 16),
                      _buildPlayerInput(
                        'Player 2 Name',
                        _p2Controller,
                        AppColors.playerTwoColor,
                      ),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.safeZoneGold,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 8,
                        ),
                        onPressed: _save,
                        child: Text('Save Settings', style: AppTextStyles.button.copyWith(color: Colors.black)),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerInput(String label, TextEditingController controller, Color themeColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: controller,
            style: AppTextStyles.body,
            cursorColor: themeColor,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: AppTextStyles.bodyMuted,
              border: InputBorder.none,
              icon: Icon(Icons.person, color: themeColor),
            ),
          ),
        ),
      ),
    );
  }
}
