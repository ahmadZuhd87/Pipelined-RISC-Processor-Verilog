module Hazard_CU(input MemR_Ex, EQ, C, B,input [1:0] ForwardA, ForwardB,input [5:0] Op,output reg stallSignal, killSignal);
	
	// Check Stall 
    Stall_Unit Stall(ForwardA, ForwardB, MemR_Ex , stallSignal);
  	
	// Check Kill ( BZ , BGZ , BLZ , J , JR , CALL)
    Kill_Signal KILL(Op, EQ, C, B, killSignal);
	
endmodule


// ================== Test Bench For Hazard ================== //
module Hazard_CU_tb;

    // Inputs
    reg MemR_Ex;
    reg EQ;
    reg C;
    reg B;
    reg [1:0] ForwardA;
    reg [1:0] ForwardB;
    reg [5:0] Op;

    // Outputs
    wire stallSignal;
    wire killSignal;

    // Connect the module under test
    Hazard_CU uut (
        .MemR_Ex(MemR_Ex),
        .EQ(EQ),
        .C(C),
        .B(B),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .Op(Op),
        .stallSignal(stallSignal),
        .killSignal(killSignal)
    );

	initial begin
	    // Print table header with spacing
	    $display("Time    | MEMR_EX | ForwardA | ForwardB | EQ | C  | B  |  Op   | Stall | Kill");
	    $display("--------|---------|----------|----------|----|----|----|--------|--------|------");
	
	    // Print values clearly and aligned
	    $monitor("%6t |   %1b     |   %2b     |   %2b     | %1b  | %1b  | %1b  | %06b |   %1b    |  %1b",
	             $time, MemR_Ex, ForwardA, ForwardB, EQ, C, B, Op, stallSignal, killSignal);
	
	    // Test 1: No stall, no kill
	    MemR_Ex = 0; ForwardA = 2'b00; ForwardB = 2'b00;
	    EQ = 0; C = 0; B = 0; Op = 6'b000000; #10;
	
	    // Test 2: Stall only
	    MemR_Ex = 1; ForwardA = 2'b01; ForwardB = 2'b00;
	    EQ = 0; C = 0; B = 0; Op = 6'b000000; #10;
	
	    // Test 3: Kill only
	    MemR_Ex = 0; ForwardA = 2'b00; ForwardB = 2'b00;
	    EQ = 1; C = 0; B = 1; Op = 6'b000100; #10;
	
	    // Test 4: Stall + Kill
	    MemR_Ex = 1; ForwardA = 2'b01; ForwardB = 2'b00;
	    EQ = 1; C = 1; B = 1; Op = 6'b001100; #10;
	
	    // Test 5: Normal case
	    MemR_Ex = 0; ForwardA = 2'b10; ForwardB = 2'b01;
	    EQ = 0; C = 0; B = 0; Op = 6'b001000; #10;
	
	    $finish;
	end


endmodule
