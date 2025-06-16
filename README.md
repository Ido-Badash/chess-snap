# ChessSnap ♟️📸

ChessSnap is a cross-platform Flutter app (mobile & web) designed for chess enthusiasts who want to seamlessly bridge physical and digital play.

## Project Vision

**ChessSnap** lets you snap a photo of a real chessboard, instantly recreates the position in the app, and allows you to play from there—solo or with friends. Multiplayer is built around easy sharing via link or code, with LAN-based connections for smooth, private games. A flexible theming system, future AI integration, and an open database for tracking matches are all part of the roadmap.

---

## Features

- **Image-to-Board Conversion**
  - Take a photo of a chessboard and recreate it virtually in the app.
  - (Powered by a custom image analysis backend, handled by a project partner.)

- **Play from Any Position**
  - Start playing from any scanned board position.
  - Play solo or against another player.

- **Multiplayer Support**
  - Invite friends via link or code.
  - Multiplayer games run over LAN for privacy and low latency.
  - Option to play offline.

- **Themes**
  - Customize your experience with a variety of board and piece themes.

- **Match Database (Planned)**
  - Track your games and progress with a free, open database.

- **AI Opponent (Future)**
  - Play against a computer opponent.

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- A device or emulator for testing (iOS, Android, or Web)

### Installation

```bash
git clone https://github.com/Ido-Badash/chess-snap.git
cd chess-snap
flutter pub get
flutter run
```

### Usage

1. Launch ChessSnap on your device or browser.
2. Tap the camera icon to snap a photo of your chessboard.
3. Review the detected position and start your game.
4. To play with friends, share your game link or code.
5. Explore themes and customize your board.

---

## Development Notes

- **Image recognition** is handled by a custom AI backend (external to this repo).
- **Multiplayer** is LAN-based; remote play is not supported (yet).
- **Theming** is designed for easy extensibility.

---

## Contributing

Contributions are welcome! To get started:

1. Fork the repo.
2. Create a new branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add feature"`
4. Push to your branch: `git push origin feature/your-feature`
5. Open a Pull Request.

---

## License

MIT License (see [LICENSE](LICENSE) for details)

---

## Roadmap

### Phase 1: Core Game (MVP)
- [ ] **Flutter Foundation**
  - [ ] Set up multi-platform project structure (mobile + web)
  - [ ] Add theme system (light/dark/classic/modern)
  - [ ] Implement basic chess board UI with `flutter_chess` or custom renderer
  
- [ ] **Image Integration**
  - [ ] Connect to partner's image-to-board API (HTTP/RPC)
  - [ ] Build camera capture screen (`camera` package)
  - [ ] Add photo cropping/confirmation flow

- [ ] **Basic Gameplay**
  - [ ] Implement move validation
  - [ ] Add undo/redo functionality
  - [ ] Local game state persistence (`hive`)

### Phase 2: Multiplayer
- [ ] **LAN Play**
  - [ ] Socket-based networking (`web_socket_channel`)
  - [ ] Device discovery on local network (`mdns`)
  
- [ ] **Invite System**
  - [ ] Generate shareable links/codes
  - [ ] Join via QR code (`qr_code_scanner`)

### Phase 3: Polish & Extras
- [ ] **UI/UX**
  - [ ] Animations for piece moves
  - [ ] Sound effects
  - [ ] Tutorial/onboarding flow

- [ ] **Advanced Features**
  - [ ] Game history/replay
  - [ ] PGN export/import
  - [ ] Simple AI bot (optional)

### Phase 4: Deployment
- [ ] **Web**
  - [ ] Optimize for Chrome/Firefox
  - [ ] Deploy to Firebase Hosting
  
- [ ] **Mobile**
  - [ ] Release TestFlight/Play Store Beta
  - [ ] App Store submission

---

## Acknowledgments

- Flutter
- Open source chess libraries and databases
- UI and DB by Ido Badash
- Photo to board by David Ortish

