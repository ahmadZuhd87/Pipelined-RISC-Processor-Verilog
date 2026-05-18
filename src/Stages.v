module Fetch_stage (
	input [5:0] Op_from_Decode,
    input wire CLK,
	input wire reset,
	input KILL,stall,
	input G_ZERO_D, L_ZERO_D , ZERO_D,
	input [31:0] Rs_add,
	input [13:0] Imm,
    output reg [31:0] InstrF,  // The fetched instruction
    output reg [31:0] PC
); 

	wire [2:0] Pcs;
    reg [31:0] PC_N;
	// Instruction memory instance
    wire [31:0] instr_mem_out;
	
    Instruction_mem Inst_mem (PC , instr_mem_out);
	
	wire [5:0] OP1 = instr_mem_out[31:26];
	always @(*) begin 
		// Check Odd Rd 
		if(instr_mem_out[22] == 1 && (OP1 == 9 || OP1 == 8))begin
			InstrF = 32'h0FFFFFFF;
			$display("Time = %0t ,Inst = %h with Rd = %d",$time,instr_mem_out,instr_mem_out[25:22]);
		end
	else begin
    	InstrF = instr_mem_out;
	end
	
	end
	wire match_any; 


    // Individual match conditions
    wire match_0a;
	assign match_0a = (OP1 == 6'h0A); // hex A = 10
    wire match_0b = (OP1 == 6'h0B); // hex B = 11
    wire match_0c = (OP1 == 6'h0C); // hex C = 12
	wire match_0d = (OP1 == 6'h0D); // hex C = 12

    // OR all match conditions
    assign match_any = match_0a | match_0b | match_0c | match_0d;
    // MUX wires
    wire [5:0] mux_out1;
    wire [5:0] mux_out2;
    wire [5:0] final_op;

    // First MUX: selects between OP1 and OP 
    assign mux_out1 = stall ? Op_from_Decode : OP1;

    // Second MUX: selects between result of first MUX and OP 
    assign mux_out2 = KILL ? Op_from_Decode : mux_out1;

    // Final MUX: selects between result of second MUX and OP1 
    assign final_op  = match_any ? Op_from_Decode : mux_out2; 
	
	
	PCcontrol pc_control (final_op , Pcs);
	
	
	wire [5:0] MUX_LWD1; 
	
	
	assign MUX_LWD1 = stall ? 0 : OP1;
	reg round2_load;
	reg round2_store;	 
	
	round_control1 round(CLK , reset , MUX_LWD1 , round2_load , round2_store); 	
	
	reg sel_round;
	or (sel_round , round2_store , round2_load);
	reg [31:0] outmux111;
	
	// ----------  Pc Selection  ----------
	
	reg [31:0] ADD;
	
	always@(posedge CLK)begin
		
		ADD = Rs_add + 1;
		
		$display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		$display("Busx = %h  , ADD = %h |",Rs_add , ADD);
		$display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
	end	
	
	
    always @(posedge CLK) begin
        if (reset)
            PC_N = 32'h00000000;
        else begin
            case (Pcs)
                3'b000: PC_N = PC + 1;
                3'b001: PC_N = ZERO_D ? PC + $signed({{18{Imm[13]}}, Imm}) : PC + 1;
                3'b010: PC_N = G_ZERO_D ? PC + $signed({{18{Imm[13]}}, Imm}) : PC + 1;
                3'b011: PC_N = L_ZERO_D ? PC + $signed({{18{Imm[13]}}, Imm}) : PC + 1;
                3'b100: PC_N = ADD;
                3'b101, 3'b110: PC_N = PC + $signed({{18{Imm[13]}}, Imm});
                3'b111: PC_N = sel_round ? PC + 1 : PC;
                default: PC_N = PC + 1;
            endcase
        end
    end
    
	
	
	
    always @(posedge CLK or posedge reset) begin
    if (reset)
        PC = 32'h00000000;
    else if (!stall)
        PC = PC_N;
	end


endmodule 


module Decode_Stage(
	output reg [1:0] ALUSignal,
	output reg [1:0] ALUSrc,
	input clk,
	input [31:0 ] Data_From_WB , Alu_Forward , Mem_Forward , PC, 
	input RegW_Mem, RegW_Ex , RegW_WB , MemR_Ex,
	input [3:0] Rd_EX, Rd_MEM, Rd_WB,
	output [1:0] WB,
	output reg MEM_read, MEM_write, RegW, 
	output reg [1:0] RegDist,
	output reg [31:0] IN1, IN2, Data, 
	output reg stallSignal, killSignal,
	output reg [13:0] Imm,
	output reg [5:0] Op,
	output reg [3:0] Rz , Rs_t, Rm,
    input  [31:0] inst,
    output reg ZERO , G_ZERO ,L_ZERO ,
	output reg [1:0] A ,B,
	output reg Round2_out,
	output reg [31:0] RS_ADD
	);

	
	wire Fake_clk;
    wire Source;
	wire ExtOp;
	reg Round2;
	wire [3:0] Rd_s,Rt;
	reg [3:0] src1, src2, RegDest; 
	wire [31:0] Extend_out , Busx , Busy; 
	reg [1:0] ForwardA, ForwardB;
	reg signed [31:0] ForwardA_Out, ForwardB_Out;
	wire [31:0] ImmExt = {{18{Imm[13]}}, Imm}; 
	wire round2_load , round2_store;
	
	Split Sip(inst,Op,Rd_s,Rs_t,Rt,Imm); 
	

	
	reg stall_Buff;
	reg Round2_Buff;
	
	wire reset; 
	always@(posedge clk)begin
			stall_Buff = stallSignal;
			Round2_Buff = Round2;		
		
	end
	
	always@(*) begin 
		if(stall_Buff && Round2_Buff) begin
			  Round2 = 1;
		end	 
	else begin
		 Round2 =  round2_load |  round2_store ;
		end	
	end
	
	
	
	round_control1 round(clk , reset  ,Op  ,round2_load , round2_store);



	
	MainControl Con(Round2, Op, stallSignal, RegDist, RegW, ALUSignal, ALUSrc, MEM_read, MEM_write, Source, WB, ExtOp);
	
   /*
	always@(posedge clk) begin 
		$display("================================= Decode Round 2 ================================= ");
		$display("Time: %0t , round2_load = %b , round2_store = %b , op =%b , Round2=%b ,stallSignal=%b , killSignal=%b ",$time,round2_load,round2_store,Op,Round2,stallSignal,killSignal);	 
		$display("AluSrc = %b",ALUSrc);
		$display("======================================================================");
		
	end*/ /*
	always@(posedge clk) begin 
		$display("================================= Decode Round 2 ================================= ");
		$display("Time: %0t , op =%b ",$time,Op);	 
		$display("AluSrc = %b",ALUSrc);
		$display("======================================================================");
		
	end*/
	
	
	always @(*)begin
		   case (RegDist)
            	2'b00: Rm = Rd_s;
            	2'b01: Rm = 4'b1110;      // register 14
            	2'b10: Rm = Rd_s + 1;	  // (Rd + 1)
            	default: Rm = 4'b0000;    // default to register 0
        	endcase
		end

	always @(*) begin
    	if (Source == 1) begin
        	Rz = Rt;
    	end else begin
			// Source = 0 ;
        	Rz = Rm; 
	end
		case (ForwardA)
       	 		2'b00: ForwardA_Out = Busx;
        		2'b01: ForwardA_Out = Alu_Forward;
        		2'b10: ForwardA_Out = Mem_Forward;
        		2'b11: ForwardA_Out = Data_From_WB;
        		default: ForwardA_Out = Busx; 
    		endcase	 
		case (ForwardB)
       			2'b00: ForwardB_Out = Busy;
        		2'b01: ForwardB_Out = Alu_Forward;
        		2'b10: ForwardB_Out = Mem_Forward;
        		2'b11: ForwardB_Out = Data_From_WB;
        		default: ForwardB_Out = Busy; 
    		endcase
			
			case (ALUSrc)  
       			2'b00: IN2 = ForwardB_Out;
        		2'b01: IN2 = ImmExt;
        		2'b10: IN2 = 32'b0;
        		2'b11: IN2 = ImmExt + 32'b1;
        		default: IN2 = ForwardB_Out; 
			endcase
			Data = ForwardB_Out;
			IN1 = ForwardA_Out;	
    	end
	
	
				
	assign ZERO = (ForwardA_Out == 0);  // A = 0
    assign G_ZERO = (ForwardA_Out > 0);   // A > 0
    assign L_ZERO = (ForwardA_Out < 0);   // A < 0
	
	// ---------- Register File ---------- 	
	
	
    RegFile RegisterFile (PC , Op , Rs_t , Rz , Rd_WB , Data_From_WB , RegW_WB,clk, Busx ,Busy); 
	
	assign RS_ADD = Busx ;
	Forwarding_Unit Aa(Rs_t , Rd_EX , Rd_MEM ,  Rd_WB , RegW_Ex , RegW_Mem , RegW_WB, ForwardA);
	Forwarding_Unit Bb(Rz , Rd_EX , Rd_MEM ,  Rd_WB , RegW_Ex , RegW_Mem , RegW_WB, ForwardB);
	
	
	assign A= ForwardA ;
	assign B = ForwardB;
	assign Round2_out = Round2;
	
    Hazard_CU Hazarad(MemR_Ex , ZERO , G_ZERO , L_ZERO , ForwardA , ForwardB , Op , stallSignal , killSignal);
	
	
endmodule

// ===================//

module Ex_Stage(input RegW_ID, MEMwrite_ID, MEMread_ID,
    input [1:0] WB_ID,ALUSignal_ID,
    input [3:0]Rd_ID,
    input [31:0] IN1_ID, IN2_ID, Regdata_ID,PC_d,

    output reg RegW, MEMW, MEMR, 
    output reg [1:0]WB, 
    output reg [3:0] Rd,
    output reg [31:0] Data, Result,Pc_d);

  alu execution(IN1_ID,IN2_ID,ALUSignal_ID,Result);

  assign Rd = Rd_ID;
  assign RegW = RegW_ID;
  assign MEMR = MEMread_ID;
  assign MEMW = MEMwrite_ID; 
  assign Data = Regdata_ID;
  assign WB = WB_ID; 
  assign Pc_d = PC_d; 
  
endmodule

// ===================== Memory Stage ============================= //
module MemoryStage(input clk, RegWrite_EX, Mem_r_EX, Mem_w_EX,
                   input [1:0]WB_EX,
                   input [3:0] Rd_EX,
                   input [31:0] Data_in, Result,PC,
                   output reg [31:0] Data_out, 
                   output reg RegWrite, 
                   output reg [3:0] Rd);

  wire [31:0] memoryData;
  Data_MEM ReadData(clk,Data_in,Result,Mem_w_EX,Mem_r_EX, memoryData);

  assign Rd = Rd_EX;
  assign RegWrite = RegWrite_EX; 

  always @(*) begin
    if(WB_EX == 0) Data_out = Result;
    else if(WB_EX == 1) Data_out = memoryData;
    else if(WB_EX == 2) Data_out = PC;
    else Data_out = 0;
  end

endmodule



