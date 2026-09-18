module vedic_multiplier_4 (
    input  logic [3:0] a,
    input  logic [3:0] b,
    output logic [7:0] product
);

    logic [3:0] p0;
    logic [3:0] p1;
    logic [3:0] p2;
    logic [3:0] p3;

    logic [4:0] middle_sum;

    vedic_multiplier_2 u0 (
        .a(a[1:0]),
        .b(b[1:0]),
        .product(p0)
    );

    vedic_multiplier_2 u1 (
        .a(a[3:2]),
        .b(b[1:0]),
        .product(p1)
    );

    vedic_multiplier_2 u2 (
        .a(a[1:0]),
        .b(b[3:2]),
        .product(p2)
    );

    vedic_multiplier_2 u3 (
        .a(a[3:2]),
        .b(b[3:2]),
        .product(p3)
    );

    assign middle_sum = {1'b0, p1} + {1'b0, p2};

    assign product =
          {4'b0000, p0}
        + {1'b0, middle_sum, 2'b00}
        + {p3, 4'b0000};

endmodule
