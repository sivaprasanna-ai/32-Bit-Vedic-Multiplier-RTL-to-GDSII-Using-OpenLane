module vedic_multiplier_16 (
    input  logic [15:0] a,
    input  logic [15:0] b,
    output logic [31:0] product
);

    logic [15:0] p0;
    logic [15:0] p1;
    logic [15:0] p2;
    logic [15:0] p3;

    logic [16:0] middle_sum;

    vedic_multiplier_8 u0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .product(p0)
    );

    vedic_multiplier_8 u1 (
        .a(a[15:8]),
        .b(b[7:0]),
        .product(p1)
    );

    vedic_multiplier_8 u2 (
        .a(a[7:0]),
        .b(b[15:8]),
        .product(p2)
    );

    vedic_multiplier_8 u3 (
        .a(a[15:8]),
        .b(b[15:8]),
        .product(p3)
    );

    assign middle_sum = {1'b0, p1} + {1'b0, p2};

    assign product =
          {16'b0, p0}
        + {7'b0, middle_sum, 8'b0}
        + {p3, 16'b0};

endmodule
