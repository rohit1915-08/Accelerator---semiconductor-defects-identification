import numpy as np

# 1. Generate a synthetic 8x8 "degraded" image
# In a full project, you would load a real image using cv2 or PIL here
img_width = 8
img_height = 8
pixel_data = np.zeros((img_height, img_width), dtype=np.uint8)

# Create a "defect" (a bright spot) with blurry edges
pixel_data[3:5, 3:5] = 200  # Core of the defect
pixel_data[2:6, 2:6] += 50  # Blurry degradation around it

# 2. Export to SystemVerilog Hex Memory File (.mem)
with open("image_in.mem", "w") as f:
    for row in pixel_data:
        for pixel in row:
            # Format as 2-digit Hexadecimal (e.g., 255 -> FF)
            f.write(f"{pixel:02X}\n")

print("Successfully generated image_in.mem!")