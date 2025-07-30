from io import BytesIO
from pathlib import Path

import chess
import cv2
import numpy as np
import requests
from chesscog import ChessRecognizer


class RecognitionPipeline:
    def __init__(self, classifiers_folder: Path = Path("chesscog/models")):
        self.recognizer = ChessRecognizer(classifiers_folder)

    def image_to_fen(
        self, image, turn_white=True, camera_white=True, visualise=False
    ) -> str:
        """
        Converts a chessboard image to a FEN string.

        Args:
            image: Path, URL, bytes, or numpy array representing the chessboard image.
            turn_white (bool): True if it's white's turn, False for black.
            camera_white (bool): True if the camera is on white's side.

        Returns:
            str: FEN string representing the board position.
        """

        img = None

        if isinstance(image, np.ndarray):
            img = image
        elif isinstance(image, (bytes, bytearray)):
            img = cv2.imdecode(np.frombuffer(image, np.uint8), cv2.IMREAD_COLOR)
        elif isinstance(image, str):
            if image.startswith("http://") or image.startswith("https://"):
                resp = requests.get(image)
                resp.raise_for_status()
                img = cv2.imdecode(
                    np.frombuffer(resp.content, np.uint8), cv2.IMREAD_COLOR
                )
            else:
                img = cv2.imread(image)
        elif hasattr(image, "read"):  # file-like object
            img = cv2.imdecode(np.frombuffer(image.read(), np.uint8), cv2.IMREAD_COLOR)
        else:
            raise ValueError("Unsupported image type")

        if img is None:
            raise FileNotFoundError("Could not load image from input")
        img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

        board, *_ = self.recognizer.predict(
            img,
            chess.WHITE if turn_white else chess.BLACK,
            camera_is_white_side=camera_white,
            visualise=visualise,
        )

        board = self.recognizer._flip_board_horizontally(board)
        return board.board_fen()
