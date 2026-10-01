`include "pixel_window.sv"

module tb_pixel_window;
    
    // 1. Declare signals with names perfectly matching the module
    logic       clk;
    logic       rst_n;
    logic       en;
    logic [7:0] pixel_in;
    logic [7:0] p0, p1, p2;

    // 2. Instantiate using the Auto-Wiring shortcut (.*)
    pixel_window #(.DATA_WIDTH(8)) dut (.*); 

    // 3. Generate Clock
    always #5 clk = ~clk;

    // 4. Inject a stream of pixels
    initial begin
        $dumpfile("waves_window.vcd");
        $dumpvars(0, tb_pixel_window);
        
        // System reset
        clk = 0; rst_n = 0; en = 0; pixel_in = 0;
        #15 rst_n = 1; en = 1;

        // Stream a row of pixels (e.g., from an image)
        @(posedge clk); pixel_in = 8'd10;
        @(posedge clk); pixel_in = 8'd20;
        @(posedge clk); pixel_in = 8'd30;
        
        // By this clock cycle, p0=30, p1=20, p2=10 simultaneously!
        @(posedge clk); pixel_in = 8'd40;
        
        // Turn off enable to prove the data holds perfectly in place
        @(posedge clk); en = 0; pixel_in = 8'd99; 

        #20 $finish;
    end

endmodule