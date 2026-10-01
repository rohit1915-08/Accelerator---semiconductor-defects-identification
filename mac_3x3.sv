module mac_3x3 #(
    parameter int WIDTH = 8
)(
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    en,
    
    // Pixels (Unsigned 0-255)
    input  logic [WIDTH-1:0]        p0, p1, p2, p3, p4, p5, p6, p7, p8,
    
    // Weights (Signed Two's Complement)
    input  logic signed [WIDTH-1:0] w0, w1, w2, w3, w4, w5, w6, w7, w8,
    
    // Output (Clamped back to standard 8-bit pixel format)
    output logic [WIDTH-1:0]        result 
);

    logic signed [31:0] sum;

    // Combinational Signed Math
    always_comb begin
        sum = ($signed({1'b0, p0}) * w0) + ($signed({1'b0, p1}) * w1) + ($signed({1'b0, p2}) * w2) +
              ($signed({1'b0, p3}) * w3) + ($signed({1'b0, p4}) * w4) + ($signed({1'b0, p5}) * w5) +
              ($signed({1'b0, p6}) * w6) + ($signed({1'b0, p7}) * w7) + ($signed({1'b0, p8}) * w8);
    end

    // Sequential Hardware Clamping Circuit
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= '0;
        end else if (en) begin
            if (sum < 0)       result <= 8'd0;       // Prevent Underflow
            else if (sum > 255) result <= 8'd255;     // Prevent Overflow
            else               result <= sum[7:0];   // Pass Valid DataS
        end
    end

endmodule