`include "row_buffer.sv"

module tb_row_buffer;
    
    logic       clk;
    logic       rst_n;
    logic       en;
    logic [7:0] pixel_in;
    
    logic [7:0] p0, p1, p2;
    logic [7:0] p3, p4, p5;
    logic [7:0] p6, p7, p8;

    // Instantiate buffer with a tiny 8-pixel image width
    row_buffer #(.WIDTH(8), .IMG_WIDTH(8)) dut (.*);

    // Generate Clock
    always #5 clk = ~clk;

    // Inject stimulus
    initial begin
        $dumpfile("waves_row_buffer.vcd");
        $dumpvars(0, tb_row_buffer);
        
        clk = 0; rst_n = 0; en = 0; pixel_in = 0;
        
        #15 rst_n = 1; en = 1;

        // Stream 24 pixels (3 full rows of an 8x8 image)
        for (int i = 1; i <= 24; i = i + 1) begin
            @(posedge clk);
            pixel_in = 8'(i);
        end
        
        // Wait a few cycles to watch the last pixels flush through
        @(posedge clk); en = 0;
        #30 $finish;
    end

endmodule