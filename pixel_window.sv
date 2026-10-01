module pixel_window #(
    parameter int DATA_WIDTH = 8
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  en,       // Halts the shift if memory is empty
    input  logic [DATA_WIDTH-1:0] pixel_in, // Single pixel coming from memory
    output logic [DATA_WIDTH-1:0] p0,       // Newest pixel
    output logic [DATA_WIDTH-1:0] p1,       // Middle pixel
    output logic [DATA_WIDTH-1:0] p2        // Oldest pixel
);

    // This creates a physical 3-stage hardware pipeline.
    // Every clock cycle, the data shifts one step to the right.
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p0 <= '0;
            p1 <= '0;
            p2 <= '0;
        end else if (en) begin
            p0 <= pixel_in; // Load the newest pixel
            p1 <= p0;       // Shift p0 into p1
            p2 <= p1;       // Shift p1 into p2
        end
    end

endmodule