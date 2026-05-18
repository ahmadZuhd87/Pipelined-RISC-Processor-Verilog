// Module to split a 32-bit instruction into its fields
module Split(
    input [31:0] Inst,
    output [5:0] OPCode,
    output [3:0] Rd,
    output [3:0] Rs,
    output [3:0] Rt,
    output [13:0] Imm
);

    assign OPCode = Inst[31:26];
    assign Rd     = Inst[25:22];
    assign Rs     = Inst[21:18];
    assign Rt     = Inst[17:14];
    assign Imm    = Inst[13:0];

endmodule


module Splitter_test;
    reg [31:0] Inst;
    wire [5:0] OPCode;
    wire [3:0] Rd, Rs, Rt;
    wire [13:0] Imm;

    Split SP(Inst, OPCode, Rd, Rs, Rt, Imm);

    initial begin
        Inst = 32'h14440005 ; 
        #10 $display("R-Type Instruction: %h", Inst);
        $display("Opcode: %b, Rd: %b, Rs: %b, Rt: %b, Imm: %b", OPCode, Rd, Rs, Rt, Imm);

        Inst = 32'h14803ffd;
        #10 $display("I-Type Instruction: %h", Inst);
        $display("Opcode: %b, Rd: %b, Rs: %b, Rt: %b, Imm: %b", OPCode, Rd, Rs, Rt, Imm);

        #10 $finish;
    end
endmodule

