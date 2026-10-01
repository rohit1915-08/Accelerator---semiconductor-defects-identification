import numpy as np

# 1. Read the hardware output file
with open("image_out.mem", "r") as f:
    hex_data = f.read().splitlines()

# 2. Convert hexadecimal strings back to decimal integers
decimal_data = [int(val, 16) for val in hex_data]

# 3. Reshape the 64 pixels back into an 8x8 spatial grid
processed_image = np.array(decimal_data).reshape((8, 8))

# 4. Display the result
print("--- Hardware Processed Image Matrix ---")
print(processed_image)