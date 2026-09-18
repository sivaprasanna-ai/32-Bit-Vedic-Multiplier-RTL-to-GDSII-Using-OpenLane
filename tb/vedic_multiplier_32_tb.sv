`timescale 1ns/1ps

module vedic_multiplier_32_tb;

    logic        clk;
    logic        rst_n;
    logic [31:0] a;
    logic [31:0] b;
    logic [63:0] product;

    vedic_multiplier_32_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .a(a),
        .b(b),
        .product(product)
    );

    always #5 clk = ~clk;

    task automatic check_result(
        input logic [31:0] x,
        input logic [31:0] y
    );

        logic [63:0] expected;

        begin
            a = x;
            b = y;

            @(posedge clk);
            #1;

            expected = x * y;

            @(posedge clk);
            #1;

            if (product !== expected) begin
                $display(
                    "ERROR: %h * %h = %h, expected %h",
                    x, y, product, expected
                );
                $fatal;
            end
            else begin
                $display(
                    "PASS: %h * %h = %h",
                    x, y, product
                );
            end
        end

    endtask

    initial begin
	$dumpfile("vedic_multiplier.vcd");
	$dumpvars(0, vedic_multiplier_32_tb);
        clk = 1'b0;
        rst_n = 1'b0;
        a = 32'b0;
        b = 32'b0;

        repeat (2) @(posedge clk);

        rst_n = 1'b1;

        check_result(32'd9, 32'd9);
        check_result(32'd10, 32'd24);
        check_result(32'd85, 32'd99);
        check_result(32'd256, 32'd356);
        check_result(32'd2084, 32'd4098);
        check_result(32'hFFFFFFFF, 32'd9);
        check_result(32'h12345678, 32'h0000FFFF);
        check_result(32'hAAAAAAAA, 32'h55555555);

        $display("====================================");
        $display("32-bit Vedic multiplier TEST PASSED");
        $display("====================================");

        $finish;
    end

endmodule
