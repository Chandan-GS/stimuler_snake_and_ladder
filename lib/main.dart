import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/theme.dart';
import 'cubit/game_cubit.dart';
import 'cubit/settings_cubit.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/game_screen.dart';
import 'ui/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final settingsCubit = SettingsCubit();
  await settingsCubit.loadSettings();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: settingsCubit),
        BlocProvider<GameCubit>(create: (context) => GameCubit()),
      ],
      child: const SnakesAndLaddersApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);

class SnakesAndLaddersApp extends StatelessWidget {
  const SnakesAndLaddersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Jungle Snakes & Ladders',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.mossGreen,
          secondary: AppColors.safeZoneGold,
        ),
      ),
      routerConfig: _router,
    );
  }
}
