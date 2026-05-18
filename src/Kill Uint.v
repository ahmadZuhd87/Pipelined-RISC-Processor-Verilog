module Kill_Signal (
    input [5:0] Op,   // 6-bit Opcode
    input eq,         // A = 0
    input c,          // A > 0
    input b,          // A < 0
    output reg KILL
);

    reg path_a, path_b, path_c;
    reg w1, w2, w3;

    always @(*) begin
        // set all signals 0
        path_a = 0;
        path_b = 0;
        path_c = 0;
        w1 = 0;
        w2 = 0;
        w3 = 0;

        // Check Op code
        case (Op)
            6'b001010: path_a = eq; // BZ
            6'b001011: path_b = c;  // BGZ
            6'b001100: path_c = b;  // BLZ
            6'b001101: w1 = 1;      // JR
            6'b001110: w2 = 1;		// J
            6'b001111: w3 = 1;		// CLL
            default: ; // Do nothing
        endcase

        // Final kill signal
        KILL = path_a | path_b | path_c | w1 | w2 | w3;
    end

endmodule

// =========== Test Bench For Kil =============== //
module Kill_Signal_tb;

    reg [5:0] Op;
    reg eq, c, b;
    wire KILL;
	
    Kill_Signal uut (
        .Op(Op),
        .eq(eq),
        .c(c),
        .b(b),
        .KILL(KILL)
    );

    initial begin
        $display("Time | Op      | eq c b | KILL");
        $monitor("%4dns | %b | %b  %b %b |   %b", $time, Op, eq, c, b, KILL);

        // Default: all 0
        Op = 6'b000000; eq = 0; c = 0; b = 0; #10;

        // BZ
        Op = 6'b001010; eq = 1; c = 0; b = 0; #10;

        // BGZ
        Op = 6'b001011; eq = 0; c = 1; b = 0; #10;

        // BLZ
        Op = 6'b001100; eq = 0; c = 0; b = 1; #10;

        // JR 
        Op = 6'b001101; eq = 0; c = 0; b = 0; #10;

        // J
        Op = 6'b001110; eq = 0; c = 0; b = 0; #10;

        // CLL
        Op = 6'b001111; eq = 0; c = 0; b = 0; #10;

        // Check when all inputs are = 0 
        Op = 6'b000000; eq = 0; c = 0; b = 0; #10;

        $finish;
    end

endmodule
