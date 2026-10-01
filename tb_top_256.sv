`include "accelerator_top.sv"

module tb_top_256;
    logic        clk, rst_n, en;
    logic [7:0]  pixel_in;
    logic signed [7:0] w0, w1, w2, w3, w4, w5, w6, w7, w8; // Changed to signed
    logic [7:0]  pixel_out; // Changed to 8-bit

    accelerator_top #(.WIDTH(8), .IMG_WIDTH(256)) dut (.*);

    always #5 clk = ~clk;

    logic [7:0] memory_array [0:65535]; 
    integer file_out;

    initial begin
        $readmemh("image_in_256.mem", memory_array);
        file_out = $fopen("image_out_256.mem", "w");
        
        clk = 0; rst_n = 0; en = 0; pixel_in = 0;
        
        //True High-Pass Deblurring Kernel
        w0=0;  w1=-1; w2=0;
        w3=-1; w4=5;  w5=-1;
        w6=0;  w7=-1; w8=0;
        
        #15 rst_n = 1; en = 1;

        for (int i = 0; i < 65536; i = i + 1) begin
            @(posedge clk);
            pixel_in = memory_array[i];
            if (i >= 512) $fdisplay(file_out, "%02x", pixel_out); // Updated to %02x
        end
        
        pixel_in = 0;
        for (int i = 0; i < 512; i = i + 1) begin
            @(posedge clk);
            $fdisplay(file_out, "%02x", pixel_out); // Updated to %02x
        end

        $fclose(file_out);
        $finish;
    end
endmodule