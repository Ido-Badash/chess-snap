# ChessSnap

ChessSnap is a cross-platform Flutter application that lets you convert a real chessboard (via a photo) into a playable digital board. Play from scanned positions, solo or with friends, using a lichess.

---

## Features

- **Image-to-Board Conversion**  
  Snap a photo of a chessboard and the app recreates the position digitally (requires a backend server for image analysis).
- **Play from Any Position**  
  Start playing from any scanned board position, solo or with another player.
  [with lichess](https://lichess.org).

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

if u get a server error, go to server/app.py and run the file.

---

## Contributing

Contributions are welcome! To get started:

1. Fork the repo.
2. Create a new branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m "Add feature"`
4. Push to your branch: `git push origin feature/your-feature`
5. Open a Pull Request.

you might have to use poetry lock and install on server/chess_positions/chesscog.

---

## License

MIT License (see [LICENSE](LICENSE) for details)

---

## Acknowledgments

- Flutter
- Open source chess libraries and databases
- UI and DB by Ido Badash
- Photo-to-board backend by David Ortish
