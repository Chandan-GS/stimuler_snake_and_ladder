import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:equatable/equatable.dart';

class SettingsState extends Equatable {
  final String player1Name;
  final String player2Name;

  const SettingsState({required this.player1Name, required this.player2Name});

  factory SettingsState.initial() => const SettingsState(
        player1Name: 'Player 1',
        player2Name: 'Player 2',
      );

  SettingsState copyWith({String? player1Name, String? player2Name}) {
    return SettingsState(
      player1Name: player1Name ?? this.player1Name,
      player2Name: player2Name ?? this.player2Name,
    );
  }

  @override
  List<Object?> get props => [player1Name, player2Name];
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState.initial());

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final p1 = prefs.getString('p1_name') ?? 'Player 1';
    final p2 = prefs.getString('p2_name') ?? 'Player 2';
    emit(SettingsState(player1Name: p1, player2Name: p2));
  }

  Future<void> saveSettings(String p1, String p2) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('p1_name', p1);
    await prefs.setString('p2_name', p2);
    emit(SettingsState(player1Name: p1, player2Name: p2));
  }
}
