`include "accelerator_top.sv"

module tb_accelerator_top;
    
    logic        clk;
    logic        rst_n;
    logic        en;
    logic [7:0]  pixel_in;
    logic [7:0]  w0, w1, w2, w3, w4, w5, w6, w7, w8;
    logic [19:0] pixel_out;

    accelerator_top #(.WIDTH(8), .IMG_WIDTH(8)) dut (.*);

    always #5 clk = ~clk;

    logic [7:0] memory_array [0:63]; // 8x8 image = 64 pixels
    integer file_out;

    initial begin
        // 1. Load the Python hex data into simulated RAM
        $readmemh("image_in.mem", memory_array);
        
        // 2. Open an output file for the processed pixels
        file_out = $fopen("image_out.mem", "w");
        
        clk = 0; rst_n = 0; en = 0; pixel_in = 0;
        
        // Load a standard Edge Detection / Sharpening Kernel
        w0=0; w1=1; w2=0;
        w3=1; w4=4; w5=1;
        w6=0; w7=1; w8=0;
        
        #15 rst_n = 1; en = 1;

        // 3. Stream the 64 image pixels into the hardware
        for (int i = 0; i < 64; i = i + 1) begin
            @(posedge clk);
            pixel_in = memory_array[i];
            
            // Wait for the 16-cycle pipeline delay before writing valid data
            if (i >= 16) $fdisplay(file_out, "%05x", pixel_out);
        end
        
        // 4. Flush the pipeline to capture the final rows
        pixel_in = 0;
        for (int i = 0; i < 16; i = i + 1) begin
            @(posedge clk);
            $fdisplay(file_out, "%05x", pixel_out);
        end

        $fclose(file_out);
        $finish;
    end

endmodule