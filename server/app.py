import base64
import io

import numpy as np
from chess_positions import RecognitionPipeline
from flask import Flask, jsonify, request
from PIL import Image

pipeline = RecognitionPipeline()
app = Flask(__name__)


def decode_base64_image(base64_string):
    """
    Decode a base64 string to an image
    Supports both with and without data URL prefix (data:image/jpeg;base64,...)
    """
    try:
        # Remove data URL prefix if present
        if base64_string.startswith("data:image"):
            base64_string = base64_string.split(",")[1]

        # Decode base64 string
        image_data = base64.b64decode(base64_string)

        # Convert to PIL Image
        image = Image.open(io.BytesIO(image_data))

        # Convert PIL Image to numpy array for OpenCV
        image_array = np.array(image)

        # Convert RGB to BGR if needed (OpenCV uses BGR)
        if len(image_array.shape) == 3 and image_array.shape[2] == 3:
            image_array = image_array[:, :, ::-1]  # RGB to BGR

        return image_array  # Return numpy array instead of PIL Image

    except Exception as e:
        raise ValueError(f"Invalid base64 image data: {str(e)}")


@app.route("/get_fen", methods=["POST"])
def get_fen():
    try:
        data = request.json
        if "image" not in data:
            return jsonify({"error": "No image provided"}), 400

        image_input = data["image"]
        image_type = data.get("image_type", "base64")

        if not image_input:
            return jsonify({"error": "Empty image data"}), 400

        # Process image based on type
        if image_type == "base64":
            try:
                processed_image = decode_base64_image(image_input)
            except ValueError as e:
                return jsonify({"error": str(e)}), 400

        elif image_type == "file_path":
            try:
                # For file path, use cv2.imread directly
                import cv2

                processed_image = cv2.imread(image_input)
                if processed_image is None:
                    raise Exception("Could not read image file")
            except Exception as e:
                return jsonify({"error": f"Could not open image file: {str(e)}"}), 400

        elif image_type == "url":
            try:
                import cv2
                import numpy as np
                import requests

                response = requests.get(image_input)
                image_array = np.asarray(bytearray(response.content), dtype=np.uint8)
                processed_image = cv2.imdecode(image_array, cv2.IMREAD_COLOR)

            except Exception as e:
                return (
                    jsonify({"error": f"Could not download image from URL: {str(e)}"}),
                    400,
                )
        else:
            return (
                jsonify(
                    {
                        "error": f"Unsupported image_type: {image_type}. Use 'base64', 'file_path', or 'url'"
                    }
                ),
                400,
            )

        # Get FEN string from processed image
        fen_string = pipeline.image_to_fen(processed_image)

        return jsonify({"fen": fen_string}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
