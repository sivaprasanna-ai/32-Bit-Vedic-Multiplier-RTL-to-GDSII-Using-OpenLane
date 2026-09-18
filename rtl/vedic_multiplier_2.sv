module vedic_multiplier_2 (
    input  logic [1:0] a,
    input  logic [1:0] b,
    output logic [3:0] product
);

    logic [3:0] pp0;
    logic [3:0] pp1;

    assign pp0 = {2'b00, (a & {2{b[0]}})};
    assign pp1 = {1'b0, (a & {2{b[1]}}), 1'b0};

    assign product = pp0 + pp1;

endmodule
