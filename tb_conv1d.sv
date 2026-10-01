`include "conv1d.sv"

module tb_conv1d;
    
    logic        clk;
    logic        rst_n;
    logic        en;
    logic [7:0]  pixel_in;
    logic [7:0]  w0, w1, w2;
    logic [17:0] result;

    // Instantiate using Auto-Wiring (.*)
    conv1d #(.WIDTH(8)) dut (.*);

    // Generate Clock
    always #5 clk = ~clk;

    // Inject stimulus
    initial begin
        $dumpfile("waves_conv1d.vcd");
        $dumpvars(0, tb_conv1d);
        
        // System reset & load kernel weights [1, 2, 1]
        clk = 0; rst_n = 0; en = 0; pixel_in = 0;
        w0 = 8'd1; w1 = 8'd2; w2 = 8'd1;
        
        #15 rst_n = 1; en = 1;

        // Stream a row of pixels with a sudden spike
        @(posedge clk); pixel_in = 8'd10;
        @(posedge clk); pixel_in = 8'd10;
        @(posedge clk); pixel_in = 8'd50; // Spike hits
        @(posedge clk); pixel_in = 8'd50; 
        @(posedge clk); pixel_in = 8'd10; // Back to normal
        @(posedge clk); pixel_in = 8'd10;
        
        // Flush the pipeline
        @(posedge clk); pixel_in = 8'd0;
        @(posedge clk); pixel_in = 8'd0;

        #30 $finish;
    end

endmodule