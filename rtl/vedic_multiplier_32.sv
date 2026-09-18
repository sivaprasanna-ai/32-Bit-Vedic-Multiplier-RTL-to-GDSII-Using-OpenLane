module vedic_multiplier_32 (
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [63:0] product
);

    logic [31:0] p0;
    logic [31:0] p1;
    logic [31:0] p2;
    logic [31:0] p3;

    logic [32:0] middle_sum;

    vedic_multiplier_16 u0 (
        .a(a[15:0]),
        .b(b[15:0]),
        .product(p0)
    );

    vedic_multiplier_16 u1 (
        .a(a[31:16]),
        .b(b[15:0]),
        .product(p1)
    );

    vedic_multiplier_16 u2 (
        .a(a[15:0]),
        .b(b[31:16]),
        .product(p2)
    );

    vedic_multiplier_16 u3 (
        .a(a[31:16]),
        .b(b[31:16]),
        .product(p3)
    );

    assign middle_sum = {1'b0, p1} + {1'b0, p2};

    assign product =
          {32'b0, p0}
        + {15'b0, middle_sum, 16'b0}
        + {p3, 32'b0};

endmodule
