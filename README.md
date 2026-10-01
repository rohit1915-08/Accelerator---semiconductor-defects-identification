# SystemVerilog Hardware Accelerator for Semiconductor Defect Inspection

This repository contains a SystemVerilog-based hardware accelerator designed for real-time spatial image processing, specifically targeted at detecting microscopic anomalies and defects on semiconductor wafers. The architecture utilizes a systolic Multiply-Accumulate (MAC) array and 2D line buffers to parallelize spatial convolutions, bypassing sequential CPU processing to achieve a throughput of 1 pixel per clock cycle.

## Background & Motivation: Darkfield Inspection and Motion Blur

During semiconductor inspection, a camera is mounted directly above the wafer (at a 90-degree angle) while a laser illuminates the surface from an inclined angle. Since a flawless silicon wafer acts like a perfect mirror, it reflects the light away, resulting in a pitch-black background in the camera feed. However, if there is a microscopic dust particle or structural defect, the uneven surface scatters the light in all directions. A portion of this scattered light enters the overhead camera lens, appearing as a bright white spot against the dark background.

Because wafers are scanned at very high speeds, the camera feed suffers from motion blur, causing these bright defect spots to appear out-of-focus. Relying on a standard CPU to sharpen these images sequentially is too slow for real-time, high-speed scanning. To overcome this bottleneck, this project introduces a custom SystemVerilog hardware accelerator. By leveraging parallel processing, the accelerator instantly deblurs and sharpens the defect images in real-time, enabling the system to accurately measure the exact shape and size of the anomalies.

## Repository Structure

The project implements a complete software-to-silicon pipeline, integrating Python for data preparation and SystemVerilog for RTL design.

### 1. Hardware RTL (SystemVerilog)
*   **`accelerator_top.sv`**[cite: 3]: The top-level module integrating the memory interfaces and the convolution datapath.
*   **`mac_3x3.sv`**[cite: 3]: The core 3x3 systolic MAC array computing the spatial convolution for the kernel.
*   **`row_buffer.sv`**[cite: 3]: SRAM/FIFO-based line buffers to store image rows, enabling spatial processing without an external frame buffer.
*   **`pixel_window.sv`**[cite: 3]: Generates the sliding 2D pixel window required for the MAC operations.
*   **`conv1d.sv`**[cite: 3]: Handles 1D convolution operations within the pipeline.

### 2. Software Pipeline & Data Preparation (Python)
*   **`generate_256.py`** & **`generate_mem.py`**[cite: 3]: Python scripts that read the input image (`input_wafer.png`[cite: 3]) and convert the pixel data into hexadecimal memory files (`image_in_256.mem`, `image_in.mem`[cite: 3]) for the RTL testbench.
*   **`reconstruct_256.py`** & **`reconstruct_image.py`**[cite: 3]: Scripts that take the simulated hardware output (`image_out_256.mem`, `image_out.mem`[cite: 3]) and reconstruct it into the final visual output (`output_wafer_restored.png`[cite: 3]).

### 3. Verification & Testbenches
*   **`tb_accelerator_top.sv`** & **`tb_conv1d.sv`**[cite: 3]: Bit-accurate testbenches to validate the RTL modules.
*   The environment generates various simulation output files (e.g., `sim_top.out`, `sim_256.out`, `sim_window.out`, `sim_buffer.out`, `sim_conv.out`, `sim_adder.out`[cite: 3]) which can be analyzed using open-source tools like Icarus Verilog and GTKWave.

## Workflow

1.  **Pre-processing**: Run `generate_256.py`[cite: 3] to convert the test image into `.mem` files.
2.  **RTL Simulation**: Compile and run the testbenches (e.g., `tb_accelerator_top.sv`[cite: 3]) using Icarus Verilog or Verilator. The hardware processes the stream and writes to the output `.mem` files.
3.  **Post-processing**: Run `reconstruct_256.py`[cite: 3] to convert the output memory files back into an image format to visually verify the deblurring and defect highlighting.