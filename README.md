# 🐍 Jungle Snakes & Ladders 🪜

A premium, visually stunning 2.5D Snakes and Ladders game built with Flutter and the BLoC pattern. This project features beautiful glassmorphism UI, dynamic board generation, and complex custom painting to bring the classic board game to life with a fresh jungle theme!

## ✨ Features

- **Beautiful 2.5D UI**: Fully custom-painted game board with 3D pawns, depth-shadowed ladders, and realistic snakes.
- **Glassmorphism & Gradients**: Uses deep radial gradients and frosted glass panels for a premium aesthetic.
- **Dynamic Board Layouts**: The game randomly selects from multiple different configurations of snakes and ladders (Classic, Danger Zone, Fast Track) every time you play, keeping the adventure fresh!
- **Smooth Animations**: Animated bouncy dice, pulsing player turn cards, and a magical jungle splash screen with floating fireflies.
- **Responsive Layout**: Fully optimized for both Portrait and Landscape orientations, scaling seamlessly to tablets and different screen sizes.
- **Robust Architecture**: Built with `flutter_bloc` for clean separation of game logic and UI state.

## 🛠 Tech Stack

- **Framework**: Flutter
- **State Management**: flutter_bloc / cubit
- **Graphics**: `CustomPainter` API for advanced vector graphics (board, paths, snakes, ladders, pawns).
- **Routing**: `go_router` for seamless navigation.

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (latest stable version)
- Dart SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Chandan-GS/stimuler_snake_and_ladder.git
   cd stimuler_snake_and_ladder
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 🎮 How to Play
1. **Configure Players**: Click the gear icon on the top right to set custom player names.
2. **Start the Game**: You must roll a **1** or a **6** to enter the board (Square 1).
3. **Climb & Slide**: Land on the bottom of a ladder to climb up. Land on a snake's head to slide down.
4. **Winning**: Be the first player to reach exactly Square 100!

---
*Built with ❤️ using Flutter.*
