module vedic_multiplier_8 (
    input  logic [7:0] a,
    input  logic [7:0] b,
    output logic [15:0] product
);

    logic [7:0] p0;
    logic [7:0] p1;
    logic [7:0] p2;
    logic [7:0] p3;

    logic [8:0] middle_sum;

    vedic_multiplier_4 u0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .product(p0)
    );

    vedic_multiplier_4 u1 (
        .a(a[7:4]),
        .b(b[3:0]),
        .product(p1)
    );

    vedic_multiplier_4 u2 (
        .a(a[3:0]),
        .b(b[7:4]),
        .product(p2)
    );

    vedic_multiplier_4 u3 (
        .a(a[7:4]),
        .b(b[7:4]),
        .product(p3)
    );

    assign middle_sum = {1'b0, p1} + {1'b0, p2};

    assign product =
          {8'b00000000, p0}
        + {3'b000, middle_sum, 4'b0000}
        + {p3, 8'b00000000};

endmodule
