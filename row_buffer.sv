module row_buffer #(
    parameter int WIDTH = 8,
    parameter int IMG_WIDTH = 8 // Width of the image in pixels
)(
    input  logic                   clk,
    input  logic                   rst_n,
    input  logic                   en,
    input  logic [WIDTH-1:0]       pixel_in,
    
    // The 3x3 Pixel Window Output
    output logic [WIDTH-1:0]       p0, p1, p2, // Top row (Oldest)
    output logic [WIDTH-1:0]       p3, p4, p5, // Middle row
    output logic [WIDTH-1:0]       p6, p7, p8  // Bottom row (Newest)
);

    // Memory to hold two full rows of the image
    logic [WIDTH-1:0] line_buf_1 [0:IMG_WIDTH-1];
    logic [WIDTH-1:0] line_buf_2 [0:IMG_WIDTH-1];

    integer i;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p0 <= '0; p1 <= '0; p2 <= '0;
            p3 <= '0; p4 <= '0; p5 <= '0;
            p6 <= '0; p7 <= '0; p8 <= '0;
            for (i = 0; i < IMG_WIDTH; i = i + 1) begin
                line_buf_1[i] <= '0;
                line_buf_2[i] <= '0;
            end
        end else if (en) begin
            // 1. Shift the newest pixels through the bottom row
            p8 <= pixel_in;
            p7 <= p8;
            p6 <= p7;

            // 2. Feed the newest pixel into Line Buffer 1
            line_buf_1[0] <= pixel_in;
            for (i = 1; i < IMG_WIDTH; i = i + 1) begin
                line_buf_1[i] <= line_buf_1[i-1];
            end

            // 3. Spillage from Line Buffer 1 goes to the middle row and Line Buffer 2
            p5 <= line_buf_1[IMG_WIDTH-1];
            p4 <= p5;
            p3 <= p4;
            
            line_buf_2[0] <= line_buf_1[IMG_WIDTH-1];
            for (i = 1; i < IMG_WIDTH; i = i + 1) begin
                line_buf_2[i] <= line_buf_2[i-1];
            end

            // 4. Spillage from Line Buffer 2 goes to the top row
            p2 <= line_buf_2[IMG_WIDTH-1];
            p1 <= p2;
            p0 <= p1;
        end
    end

endmodule