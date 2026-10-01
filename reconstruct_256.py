import numpy as np
import cv2

# Read the hardware hex output
with open("image_out_256.mem", "r") as f:
    hex_data = f.read().splitlines()

# Convert back to decimal integers
decimal_data = [int(val, 16) for val in hex_data]

# Reshape into 256x256 matrix
processed_matrix = np.array(decimal_data).reshape((256, 256))

# CRITICAL FIX: Force the array to standard 8-bit unsigned integers
# so OpenCV knows 255 means 100% white.
processed_matrix = processed_matrix.astype(np.uint8)

# Save the final hardware-processed image
cv2.imwrite("output_wafer_restored.png", processed_matrix)
print("Saved output_wafer_restored.png. Compare it to input_wafer.png!")