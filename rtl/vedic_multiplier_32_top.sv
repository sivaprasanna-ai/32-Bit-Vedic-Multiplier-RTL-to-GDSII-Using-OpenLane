module vedic_multiplier_32_top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [63:0] product
);

    logic [31:0] a_reg;
    logic [31:0] b_reg;
    logic [63:0] mult_result;

    vedic_multiplier_32 u_multiplier (
        .a(a_reg),
        .b(b_reg),
        .product(mult_result)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg  <= 32'b0;
            b_reg  <= 32'b0;
            product <= 64'b0;
        end
        else begin
            a_reg  <= a;
            b_reg  <= b;
            product <= mult_result;
        end
    end

endmodule
