# 🐍 Jungle Snakes & Ladders 🪜

A premium, custom-themed Snakes & Ladders game built with Flutter. The application has been fully refactored to use a scalable, modular architecture and a beautiful custom-painted jungle aesthetic.

## ✨ Features

- **Jungle Theme:** A cohesive visual aesthetic utilizing moss and canopy greens, safe-zone gold, and modern typography (`CinzelDecorative` & `Outfit` via Google Fonts).
- **Custom Splash Screen:** A beautiful `CustomPainter`-driven splash screen featuring animated vines and leaves swaying in the jungle breeze.
- **Robust Architecture:** Complete modularization separating the UI from business logic.
- **State Management:** Powered by `flutter_bloc` (Cubit). 
  - `GameCubit` handles dice mechanics, moving pawns, and snake/ladder evaluations.
  - `SettingsCubit` manages persistent player configurations.
- **Settings & Persistence:** Players can set custom names (e.g. "Alice" vs "Bob"), seamlessly persisted across app reloads via `shared_preferences`.
- **Game Mechanics:** 
  - Players must roll a **1** or a **6** to exit the starting position (Sq 0).
  - Smooth delayed animations when climbing ladders or sliding down snakes.
  - No layout jumps or jitter during dice rolls.

## 📁 Project Structure

```text
lib/
├── core/
│   ├── constants.dart       # Snake/Ladder board mappings (kSnakes, kLadders)
│   └── theme.dart           # AppColors and AppTextStyles
├── cubit/
│   ├── game_cubit.dart      # Core game logic and dice rolling mechanics
│   ├── game_state.dart      # Immutable GameState configuration
│   └── settings_cubit.dart  # Player name persistence
├── ui/
│   ├── screens/
│   │   ├── game_screen.dart     # Main board UI and player HUD
│   │   ├── settings_screen.dart # Player configuration screen
│   │   └── splash_screen.dart   # Custom painted loading screen
│   └── widgets/
│       ├── board_widget.dart    # CustomPainter drawing the board and pawns
│       ├── dice_widget.dart     # CustomPainter drawing the dice face
│       └── player_card.dart     # UI component showing player turn and stats
└── main.dart                # App entry point, Router (go_router) and BlocProviders
```

## 🚀 Getting Started

1. **Prerequisites**: Make sure you have the [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the App**:
   ```bash
   flutter run
   ```

## 🎨 Architecture & UI Patterns

This app entirely abandons standard generic widgets in favor of heavily customized elements:
- `CustomPainter` is extensively used for rendering the board's dynamic grid, the intricate snake bodies, and the wooden ladders. 
- The `go_router` package provides declarative, modern navigation between the Splash Screen, Game, and Settings.
- `AnimatedSwitcher` and `AnimatedContainer` are used to add smooth transitions to player turns and game messages, avoiding jarring screen updates.

## 🛠 Built With

- [Flutter](https://flutter.dev/) - Framework
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - State Management
- [go_router](https://pub.dev/packages/go_router) - Routing
- [shared_preferences](https://pub.dev/packages/shared_preferences) - Local Persistence
- [google_fonts](https://pub.dev/packages/google_fonts) - Typography
# stimuler_snake_and_ladder
