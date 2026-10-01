import numpy as np
import cv2

img_size = 256
img = np.zeros((img_size, img_size), dtype=np.uint8)

# Create a bright semiconductor defect and severely blur it
cv2.circle(img, (128, 128), 40, (200), -1)
blurry_img = cv2.GaussianBlur(img, (5, 5), 0)

# Save the visual image for your pitch deck
cv2.imwrite("input_wafer.png", blurry_img)

# Export exactly 65,536 pixels to the SystemVerilog hex file
with open("image_in_256.mem", "w") as f:
    for row in blurry_img:
        for pixel in row:
            f.write(f"{pixel:02X}\n")

print("Exported input_wafer.png and image_in_256.mem")