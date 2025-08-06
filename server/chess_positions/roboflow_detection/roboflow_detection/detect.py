from inference_sdk import InferenceHTTPClient
import cv2
import json

# Connect to Roboflow
client = InferenceHTTPClient(
    api_url="https://serverless.roboflow.com",
    api_key="WXL3JqIbXHe3onBW1kfQ"
)

def get_chess_pieces(image_path, show=False):
    print(f"Processing image: {image_path}")
    # Load image
    image = cv2.imread(image_path)

    # Run inference
    result = client.infer(image_path, model_id="getchess-vmhoj/1")

    # Optional visualization
    if show:
        for prediction in result["predictions"]:
            x = int(prediction["x"])
            y = int(prediction["y"])
            width = int(prediction["width"])
            height = int(prediction["height"])
            class_name = prediction["class"]
            confidence = prediction["confidence"]

            x1 = int(x - width / 2)
            y1 = int(y - height / 2)
            x2 = int(x + width / 2)
            y2 = int(y + height / 2)

            cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)
            label = f"{class_name} ({confidence:.2f})"
            cv2.putText(image, label, (x1, y1 - 10),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)
            bottom_center_x = x
            bottom_center_y = y + height / 2
            cv2.circle(image, (int(bottom_center_x), int(bottom_center_y)), 5, (0, 0, 255), -1)

        cv2.imshow("Bounding Boxes", image)
        cv2.waitKey(0)
        cv2.destroyAllWindows()

    return result

if __name__ == "__main__":
    # Example usage
    image_path = r"C:\chessPositions\0174.png"
    get_chess_pieces(image_path, show=True)