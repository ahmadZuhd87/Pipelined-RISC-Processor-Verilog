module Stall_Unit(
    input [1:0] ForwardA,
    input [1:0] ForwardB,
    input MemR_Ex,
    output reg Stall_Signal
);

	always @(*) begin
	    if (MemR_Ex == 1 && (ForwardA == 2'b01 || ForwardB == 2'b01))
	        Stall_Signal = 1;
	    else
	        Stall_Signal = 0;
	end

endmodule
	

// =================== Test Bench For Stall ====================== //
`timescale 1ns / 1ps

module Stall_Unit_tb;

    // Inputs
    reg [1:0] ForwardA;
    reg [1:0] ForwardB;
    reg MemR_Ex;

    // Output
    wire Stall_Signal;

    // Connect the test module (Unit Under Test)
    Stall_Unit uut (
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .MemR_Ex(MemR_Ex),
        .Stall_Signal(Stall_Signal)
    );

    initial begin
        $display("Time\tMemR_Ex\tForwardA\tForwardB\tStall_Signal");
        $monitor("%0t\t%b\t%b\t\t%b\t\t%b", $time, MemR_Ex, ForwardA, ForwardB, Stall_Signal);

        // Test 1: No memory read, no dependency
        MemR_Ex = 0; ForwardA = 2'b00; ForwardB = 2'b00; #10;

        // Test 2: Memory read, but no dependency
        MemR_Ex = 1; ForwardA = 2'b00; ForwardB = 2'b00; #10;

        // Test 3: Memory read and ForwardA is 01 => stall = 1
        MemR_Ex = 1; ForwardA = 2'b01; ForwardB = 2'b00; #10;

        // Test 4: Memory read and ForwardB is 01 => stall = 1
        MemR_Ex = 1; ForwardA = 2'b00; ForwardB = 2'b01; #10;

        // Test 5: Memory read and both ForwardA and ForwardB are 01 ? stall = 1
        MemR_Ex = 1; ForwardA = 2'b01; ForwardB = 2'b01; #10;

        // Test 6: Memory read, but dependency is not 01 => stall = 0
        MemR_Ex = 1; ForwardA = 2'b10; ForwardB = 2'b00; #10;

        // Test 7: No memory read, but dependency exists => stall = 0
        MemR_Ex = 0; ForwardA = 2'b01; ForwardB = 2'b01; #10;

        $finish; // End the test
    end

endmodule
