module DataPath(input clk , reset);
	reg [31:0] PC;
	
	reg [31:0] Rs_add; 
	

	wire stallSignal, killSignal;
	wire RegW_Mem, RegW_Ex, RegW_WB;
	wire MemR_Ex, MEM_readB, MEM_writeB;
	wire [3:0] Rd_EX, Rd_MEM, Rd_WB, RegDist;
	wire [1:0] ALUSignal , ALUSrc;
	wire [31:0] inst, inst_final , InstrF , Instruction_D ;
	wire [31:0] Data_From_WB;
	wire [31:0] Alu_Forward, Mem_Forward;
	wire [31:0] PC_D;
	wire RegWB;
	wire [31:0] IN1, IN2, Data;
	wire [13:0] Imm;
	wire [5:0] Op;
	wire [3:0] Rz , Rs , Rm;
	wire Regwrite_EX, MEMR_EX, MEMW_EX;
	wire [31:0] IN1_EX, IN2_EX, Data_EX, PC_EX;
	wire [1:0] ALUSignal_EX , WB_EX , WB_Buff , WB_B , WB_MEM;
	wire Regwrite_Ex_Out, MemW_Ex_Out, MemR_Ex_Out;
	wire [3:0] Rd_Buff;
	wire [31:0] Data_Buff, Result, Pc_Buff;
	
	wire Regwrite_Mem, MEMR_MEM, MEMW_MEM;

	wire [31:0] Data_MEM, Result_MEM, Pc_MEM;
	
	wire RegWrite_out;
	wire [3:0] Rd_out;
	wire [31:0] Data_out;
	wire Regwrite_WB;

	wire [31:0] Data_WB;
	wire [5:0] Op_from_Decode;
	wire [2:0] Pcs;
	wire ZERO , G_ZERO ,L_ZERO;
	
	wire[1:0] A,B;
	wire Round2;
	
	
// ======================================================================================================================================================================//	
	Fetch_stage FT(Op , clk , reset , killSignal , stallSignal , G_ZERO , L_ZERO , ZERO , Rs_add , Imm , InstrF , PC);

	 
	always@(posedge clk) begin
		$display("========================================= Fatch Stage =====================================================");
		$display("Time: %0t | clk=%b | PC=0x%h | InstrF=0x%h", 
		$time, clk,PC,InstrF);
		$display("***********************************************************************************************************");
	end	
		 
	IF_ID B1(clk , stallSignal , killSignal , InstrF , PC , Instruction_D , PC_D); 
// ======================================================================================================================================================================//		
	
	
// ======================================================================================================================================================================//


	Decode_Stage Decod(ALUSignal, ALUSrc ,clk , Data_WB , Result , Data_out , PC_D , RegWrite_out , Regwrite_Ex_Out , Regwrite_WB , MemR_Ex_Out
				 ,Rd_Buff , Rd_out , Rd_WB , 
				 // output
				 WB_B , MEM_readB , MEM_writeB, RegWB , RegDist , IN1 ,IN2 , Data , stallSignal , killSignal , Imm , Op , Rz , Rs , Rm , Instruction_D , ZERO , G_ZERO ,L_ZERO,A,B,Round2,Rs_add);
	 			 
	/*		 
	always@(posedge clk) begin
            $display("========================================= Decode Stage =====================================================");
            $display("Time: %0t | clk=%b | Rz=%b | WB = %b | MemR = %b | MemW = %b | IN1 = %h | IN2 = %h | Data = %h | ALUSignal = %b | Regwrite = %b | Instruction_D=0x%h | PC_D=0x%h  |ForwardA =%b | ForwardB =%b | Round2=%b | stallSignal=%b | , Imm=%h ", 
            $time,clk,Rm,WB_B,MEM_readB,MEM_writeB,IN1,IN2,Data,ALUSignal,RegWB,Instruction_D,PC_D,A,B,Round2,stallSignal,Imm); 
            $display("***********************************************************************************************************");			 
		end*/		 
			 
	ID_EX B2(clk , stallSignal , Rm , RegWB , MEM_readB , MEM_writeB , IN1 , IN2 , Data , ALUSignal , WB_B , PC_D , Rd_EX , Regwrite_EX , MEMR_EX , MEMW_EX, IN1_EX, IN2_EX, Data_EX, ALUSignal_EX, WB_EX, PC_EX);  
	// ======================================================================================================================================================================//	
// ======================================================================================================================================================================//		
 	Ex_Stage EX(Regwrite_EX ,  MEMW_EX , MEMR_EX , WB_EX , ALUSignal_EX , Rd_EX , IN1_EX , IN2_EX , Data_EX , PC_EX , Regwrite_Ex_Out , MemW_Ex_Out , MemR_Ex_Out , WB_Buff , Rd_Buff , Data_Buff , Result , Pc_Buff); 
  	/*
	always@(posedge clk) begin
            $display("========================================= Ex Stage ====================================================="); 
	 		$display("Time: %0t | Rd_Buff = %b , Regwrite_Ex_Out = %b ,MemR_Ex_Out = %b , MemW_Ex_Out = %b , Result = %h , Data_Buff = %h ,  WB_Buff = %b , Pc_Buff = %h ",$time,Rd_Buff,Regwrite_Ex_Out,MemR_Ex_Out , MemW_Ex_Out , Result , Data_Buff , WB_Buff , Pc_Buff );
	 		$display("***********************************************************************************************************");			 
		end*/	
	 		
	EX_MEM B3(clk , Regwrite_Ex_Out , MemR_Ex_Out , MemW_Ex_Out , WB_Buff , Rd_Buff , Data_Buff , Result , Pc_Buff , Regwrite_Mem , MEMR_MEM , MEMW_MEM , WB_MEM , Rd_MEM	, Data_MEM , Result_MEM , Pc_MEM); 
// ======================================================================================================================================================================//		 


// ======================================================================================================================================================================//	
	MemoryStage Memo(clk , Regwrite_Mem , MEMR_MEM , MEMW_MEM , WB_MEM , Rd_MEM , Data_MEM , Result_MEM , Pc_MEM , Data_out , RegWrite_out , Rd_out); 
	/*
	always@(posedge clk) begin
            $display("========================================= Memory Stage =====================================================");
			$display("Time: %0t | Rd_out = %b , Data_out = %h , RegWrite_out = %b , WB_MEM = %b | Pc_MEM =%h",$time,Rd_out , Data_out , RegWrite_out , WB_MEM,Pc_MEM );
			$display("***********************************************************************************************************");
			end	*/
				 
	MEM_WB B4(clk , RegWrite_out , Rd_out , Data_out , Regwrite_WB , Rd_WB , Data_WB);

	
	
// ======================================================================================================================================================================//	

	 /*
	always@(posedge clk) begin
            $display("========================================= WB Stage =====================================================");
			$display("Time: %0t | Rd_out = %b , Data_out = %h , RegWrite_out = %b ",$time,Rd_WB , Data_WB , Regwrite_WB);
			$display("***********************************************************************************************************");
	end
	 
		*/ 
	

	
	
endmodule

`timescale 1ns / 1ps

module DataPath_tb;

    // Inputs and Outputs
    reg clk;
    reg reset;

    // Instantiate the DataPath module
    DataPath uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Testbench logic
    initial begin
        // Initialize inputs
        reset = 1;

        // Apply reset for 10 time units
        #10 reset = 0;

        repeat (50) begin
            @(posedge clk);
            #1;
        end

        // End simulation
        $display("=====================================================================================================");
		
        $stop;
    end


endmodule