module MainControl (
  input  Round2,
  input wire [5:0] Op,        // Opcode
  input wire stall,
  output reg [1:0] RegDst,
  output reg RegWr,
  output reg [1:0] AluOp,
  output reg [1:0] ALUSrc,
  output reg MemRd,
  output reg MemWr,
  output reg Source,
  output reg [1:0] WBdata,
  output reg ExtOp
);
  always @(*) begin
    // Default values
    RegDst   = 2'b00;
    RegWr    = 0;
    AluOp    = 2'b00;
    ALUSrc   = 2'b00;
    MemRd    = 0;
    MemWr    = 0;
    Source   = 0;
    WBdata   = 2'b00;
    ExtOp    = 1;

    if (!stall) begin
        if (Round2 == 0) begin
            case (Op)
                6'b000000: begin // OR
                    RegDst = 2'b00;
                    RegWr  = 1;
                    Source = 1;
                    ALUSrc = 2'b00;
                    WBdata = 2'b00;
                    AluOp  = 2'b00;
                    ExtOp  = 0;
                    MemRd  = 0;
                    MemWr  = 0;
                end

                6'b000001: begin // ADD
                    RegDst = 2'b00;
                    RegWr  = 1;
                    Source = 1;
                    ALUSrc = 2'b00;
                    WBdata = 2'b00;
                    AluOp  = 2'b01;
                    ExtOp  = 0;
                    MemRd  = 0;
                    MemWr  = 0;
                end

                6'b000010: begin // SUB
                    RegDst = 2'b00;
                    RegWr  = 1;
                    Source = 1;
                    ALUSrc = 2'b00;
                    WBdata = 2'b00;
                    AluOp  = 2'b10;
                    ExtOp  = 0;
                    MemRd  = 0;
                    MemWr  = 0;
                end

                6'b000011: begin // CMP
                    RegDst = 2'b00;
                    RegWr  = 1;
                    Source = 1;
                    ALUSrc = 2'b00;
                    WBdata = 2'b00;
                    AluOp  = 2'b11;
                    ExtOp  = 0;
                    MemRd  = 0;
                    MemWr  = 0;
                end

                6'b000100: begin // ORI
                    RegDst = 2'b00;
                    RegWr  = 1;
                    Source = 1;
                    ALUSrc = 2'b01;
                    WBdata = 2'b00;
                    AluOp  = 2'b00;
                    ExtOp  = 1;
                    MemRd  = 0;
                    MemWr  = 0;
                end

                6'b000101: begin // ADDI
                    RegDst = 2'b00;
                    RegWr  = 1;
                    Source = 1;
                    ALUSrc = 2'b01;
                    WBdata = 2'b00;
                    AluOp  = 2'b01;
                    ExtOp  = 1;
                    MemRd  = 0;
                    MemWr  = 0;
                end

                6'b000110: begin // LW
                    RegDst = 2'b00;
                    RegWr  = 1;
                    Source = 1;
                    ALUSrc = 2'b01;
                    WBdata = 2'b01;
                    AluOp  = 2'b01;
                    ExtOp  = 1;
                    MemRd  = 1;
                    MemWr  = 0;
                end

                6'b000111: begin // SW
                    RegDst = 2'b00;
                    RegWr  = 0;
                    Source = 0;
                    ALUSrc = 2'b01;
                    WBdata = 2'b00;
                    AluOp  = 2'b01;
                    ExtOp  = 1;
                    MemRd  = 0;
                    MemWr  = 1;
                end

                6'b001000: begin // LDW (Round 1)
                    RegDst = 2'b00;
                    RegWr  = 1;
                    ALUSrc = 2'b01;
                    MemWr  = 0;
                    AluOp  = 2'b01;
                    ExtOp  = 1;
                    MemRd  = 1;
                    WBdata = 2'b01;
                    Source = 1;
                end

                6'b001001: begin // SDW (Round 1)
                    Source = 0;
                    RegDst = 2'b00;
                    RegWr  = 0;
                    ALUSrc = 2'b01;
                    WBdata = 2'b00;
                    MemRd  = 0;
                    AluOp  = 2'b01;
                    ExtOp  = 1;
                    MemWr  = 1;
                end

                6'b001010, // BZ
                6'b001011, // BGZ
                6'b001100: begin // BLZ
                    Source = 0;
                    RegDst = 2'b00;
                    RegWr  = 0;
                    ALUSrc = 2'b10;
                    WBdata = 2'b00;
                    MemRd  = 0;
                    AluOp  = 2'b11;
                    ExtOp  = 0;
                    MemWr  = 0;
                end

                6'b001101: begin // JR
                    Source = 0;
                    RegDst = 2'b00;
                    RegWr  = 0;
                    ALUSrc = 2'b00;
                    WBdata = 2'b00;
                    MemRd  = 0;
                    AluOp  = 2'b00;
                    ExtOp  = 0;
                    MemWr  = 0;
                end

                6'b001110: begin // J
                    Source = 0;
                    RegDst = 2'b00;
                    RegWr  = 0;
                    ALUSrc = 2'b00;
                    WBdata = 2'b00;
                    MemRd  = 0;
                    AluOp  = 2'b00;
                    ExtOp  = 0;
                    MemWr  = 0;
                end

                6'b001111: begin // CLL
                    Source = 0;
                    RegDst = 2'b01;
                    RegWr  = 1;
                    ALUSrc = 2'b00;
                    WBdata = 2'b10;
                    MemRd  = 0;
                    AluOp  = 2'b00;
                    ExtOp  = 0;
                    MemWr  = 0;
                end
                default: ; // No operation
            endcase
        end else begin  // Round2 == 1
            case (Op)
                6'b001000: begin // LDW (Round 2)
                    Source = 0;
                    RegDst = 2'b10;
                    RegWr  = 1;
                    ALUSrc = 2'b11;
                    WBdata = 2'b01;
                    MemRd  = 1;
                    AluOp  = 2'b01;
                    ExtOp  = 1;
                    MemWr  = 0;
                end

                6'b001001: begin // SDW (Round 2)
                    Source = 0;
                    RegDst = 2'b10;
                    RegWr  = 0;
                    ALUSrc = 2'b11;
                    WBdata = 2'b00;
                    MemRd  = 0;
                    AluOp  = 2'b01;
                    ExtOp  = 1;
                    MemWr  = 1;
                end

                default: ; // No operation
            endcase
        end
    end else begin
        // if (stall == 1), output safe defaults
        Source = 0;
        RegDst = 2'b00;
        RegWr  = 0;
        ALUSrc = 2'b00;
        WBdata = 2'b00;
        MemRd  = 0;
        AluOp  = 2'b00;
        ExtOp  = 0;
        MemWr  = 0;
    end
end

endmodule




//=============================================================================================================//  
//==========================================ALU CONTROL UNIT===================================================//	  
module alu_cu (
    input  [5:0] opcode,    
    output reg [2:0] ALUCtr    
);

always @(*) begin
  case (opcode)
    6'd0:  ALUCtr = 3'b000; // OR
    6'd1:  ALUCtr = 3'b001; // ADD	 
	6'd2:  ALUCtr = 3'b010; // SUB
    6'd3:  ALUCtr = 3'b011; // CMP 
	6'd4:  ALUCtr = 3'b000; // ORI
	6'd5:  ALUCtr = 3'b001; // ADDI
	6'd6:  ALUCtr = 3'b001;	// LW
	6'd7:  ALUCtr = 3'b001;	// SW
    6'd8:  ALUCtr = 3'b001; // LWD -> ADD for address calculation
    6'd9:  ALUCtr = 3'b001; // SWD -> ADD for address calculation
    default: ALUCtr = 3'bxxx; // default/fallback
  endcase
end

endmodule

`timescale 1ns/1ps

module MainControl_tb;

  // Inputs
  reg [5:0] Op;
  reg Round2;
  reg stall;

  // Outputs
  wire [1:0] RegDst;
  wire RegWr;
  wire [1:0] AluOp;
  wire [1:0] ALUSrc;
  wire MemRd;
  wire MemWr;
  wire Source;
  wire [1:0] WBdata;
  wire ExtOp;

  // Instantiate the Unit Under Test (UUT)
  MainControl uut (
    .Op(Op),
    .Round2(Round2),
    .stall(stall),
    .RegDst(RegDst),
    .RegWr(RegWr),
    .AluOp(AluOp),
    .ALUSrc(ALUSrc),
    .MemRd(MemRd),
    .MemWr(MemWr),
    .Source(Source),
    .WBdata(WBdata),
    .ExtOp(ExtOp)
  );

  // Task for displaying signals
  task print_signals;
    begin
      $display("Time=%0t | Op=%b | Round2=%b | stall=%b || RegDst=%b | RegWr=%b | AluOp=%b | ALUSrc=%b | MemRd=%b | MemWr=%b | Source=%b | WBdata=%b | ExtOp=%b",
        $time, Op, Round2, stall, RegDst, RegWr, AluOp, ALUSrc, MemRd, MemWr, Source, WBdata, ExtOp);
    end
  endtask

  initial begin
    $display("----- MainControl Testbench -----");
    // Test: Normal instruction without stall
    stall = 0;
    Round2 = 0;

    // Test ADD
    Op = 6'b000001;
    #10; print_signals();

    // Test LW
    Op = 6'b000110;
    #10; print_signals();

    // Test SW
    Op = 6'b000111;
    #10; print_signals();

    // Test LDW (Round 1)
    Op = 6'b001000;
    #10; print_signals();

    // Test SDW (Round 1)
    Op = 6'b001001;
    #10; print_signals();

    // Round2 = 1
    Round2 = 1;

    // Test LDW (Round 2)
    Op = 6'b001000;
    #10; print_signals();

    // Test Branch instruction BZ
    Op = 6'b001010;
    #10; print_signals();

    // Test Jump instruction J
    Op = 6'b001110;
    #10; print_signals();

    // Test stall = 1 (should zero out all outputs)
    stall = 1;
    Op = 6'b000001;
    Round2 = 0;
    #10; print_signals();

    $display("----- Test Finished -----");
    $stop;
  end

endmodule


module PCcontrol(
    input [5:0] opcode,
    output reg [2:0] Pcs
);

// Determine the PC selection signal (Pcs) based on the opcode
    always @(*) begin
        case (opcode)
            6'ha: Pcs = 3'b001; // BZ
            6'hb: Pcs = 3'b010; // BGZ
            6'hc: Pcs = 3'b011; // BLZ

            6'hd: Pcs = 3'b100; // JR
            6'he: Pcs = 3'b101; // J
            6'hf: Pcs = 3'b110; // CLL
            6'h08:  Pcs = 3'b111; // LDW
            6'h09:  Pcs = 3'b111; // SDW
            default: Pcs = 3'b000;
        endcase
    end
endmodule	 




`timescale 1ns/1ps

module PCcontrol_tb;

    reg  [5:0] opcode;
    wire [2:0] Pcs;

    PCcontrol dut (
        .opcode(opcode),
        .Pcs(Pcs)
    );

    task test_case(input [5:0] code, input [2:0] expected);
        begin
            opcode = code;
            #1;
            if (Pcs !== expected)
                $display("FAIL: opcode=%d expected=%b got=%b", code, expected, Pcs);
            else
                $display("PASS: opcode=%d -> Pcs=%b", code, Pcs);
        end
    endtask

    initial begin
        $display("Testing PCcontrol");

        test_case(6'd10, 3'b001); // BZ
        test_case(6'd11, 3'b010); // BGZ
        test_case(6'd12, 3'b011); // BLZ
        test_case(6'd13, 3'b100); // JR
        test_case(6'd14, 3'b101); // J
        test_case(6'd15, 3'b110); // CLL
        test_case(6'd8 , 3'b111); // LDW
        test_case(6'd9 , 3'b111); // SDW

        test_case(6'd0 , 3'b000); // default
        test_case(6'd20, 3'b000); // default

        $finish;
    end

endmodule
