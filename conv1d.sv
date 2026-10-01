`include "pixel_window.sv"

module conv1d #(
    parameter int WIDTH = 8
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   en,
    input  logic [WIDTH-1:0]       pixel_in,
    input  logic [WIDTH-1:0]       w0,       // Weight 0
    input  logic [WIDTH-1:0]       w1,       // Weight 1
    input  logic [WIDTH-1:0]       w2,       // Weight 2
    output logic [(WIDTH*2)+1:0]   result    // Expanded width for multiplication + addition
);

    // Internal wires to catch the data coming out of the pixel window
    logic [WIDTH-1:0] p0, p1, p2;

    // 1. Instantiate the Memory Funnel
    pixel_window #(.DATA_WIDTH(WIDTH)) u_window (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .pixel_in(pixel_in),
        .p0(p0),
        .p1(p1),
        .p2(p2)
    );

    // 2. The Compute Core (Parallel MAC Tree)
    // This executes all 3 multiplications and 2 additions instantly.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= '0;
        end else if (en) begin
            result <= (p0 * w0) + (p1 * w1) + (p2 * w2);
        end
    end

endmodule