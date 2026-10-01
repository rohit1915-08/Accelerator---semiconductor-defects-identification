`include "row_buffer.sv"
`include "mac_3x3.sv"

module accelerator_top #(
    parameter int WIDTH = 8,
    parameter int IMG_WIDTH = 8
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   en,
    input  logic [WIDTH-1:0]       pixel_in,
    
    // Kernel Weights (Now Signed)
    input  logic signed [WIDTH-1:0] w0, w1, w2,
    input  logic signed [WIDTH-1:0] w3, w4, w5,
    input  logic signed [WIDTH-1:0] w6, w7, w8,
    
    // Final Processed Pixel (Now 8-bit clamped)
    output logic [WIDTH-1:0]        pixel_out
);

    // Internal wires connecting memory to compute
    logic [WIDTH-1:0] p0, p1, p2, p3, p4, p5, p6, p7, p8;

    // 1. The Memory Funnel
    row_buffer #(
        .WIDTH(WIDTH), 
        .IMG_WIDTH(IMG_WIDTH)
    ) u_mem (
        .clk(clk), .rst_n(rst_n), .en(en), .pixel_in(pixel_in),
        .p0(p0), .p1(p1), .p2(p2),
        .p3(p3), .p4(p4), .p5(p5),
        .p6(p6), .p7(p7), .p8(p8)
    );

    // 2. The Compute Engine
    mac_3x3 #(.WIDTH(WIDTH)) u_compute (
        .clk(clk), .rst_n(rst_n), .en(en),
        .p0(p0), .p1(p1), .p2(p2),
        .p3(p3), .p4(p4), .p5(p5),
        .p6(p6), .p7(p7), .p8(p8),
        .w0(w0), .w1(w1), .w2(w2),
        .w3(w3), .w4(w4), .w5(w5),
        .w6(w6), .w7(w7), .w8(w8),
        .result(pixel_out)
    );

endmodule