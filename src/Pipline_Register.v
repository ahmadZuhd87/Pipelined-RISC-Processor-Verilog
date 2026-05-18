module IF_ID (input clk, stall, kill,input [31:0] Instruction_F, PC_F,output reg [31:0] Instruction_D , PC_D);

    always @(posedge clk) begin
        if (~stall) begin
            if (kill)
                Instruction_D = 32'h0FFF_FFFF;  // NOP
            else
                Instruction_D = Instruction_F;

            PC_D = PC_F; 
			
        end
    end

endmodule





//Decode - Execute Buffer ==> ID_EX
module ID_EX(clk,stall, Rd_D, Regwrite_D, MEMR_D, MEMW_D, IN1_D, IN2_D, Data_D , ALUSignal_D, WB_D , PC_D , Rd_EX, Regwrite_EX, MEMR_EX, MEMW_EX, IN1_EX, IN2_EX, Data_EX, ALUSignal_EX, WB_EX ,PC_EX );
  input clk, stall, Regwrite_D, MEMR_D, MEMW_D;
  input [31:0] IN1_D, IN2_D, Data_D,PC_D; 
  input [3:0] Rd_D;
  input [1:0] ALUSignal_D,WB_D;

  output reg Regwrite_EX, MEMR_EX, MEMW_EX;
  output reg [31:0] IN1_EX, IN2_EX, Data_EX,PC_EX; 
  output reg [3:0] Rd_EX;
  output reg [1:0] ALUSignal_EX,WB_EX;

  always @(posedge clk) begin
    if(!stall) begin
      PC_EX = PC_D;
      Regwrite_EX = Regwrite_D;
      MEMR_EX = MEMR_D;
      MEMW_EX = MEMW_D;
      WB_EX = WB_D;
      IN1_EX = IN1_D;
      IN2_EX = IN2_D;
      Data_EX = Data_D;
      Rd_EX = Rd_D;
      ALUSignal_EX = ALUSignal_D;
    end

    else begin //stall ==> the Execution control signals are zeros
      Regwrite_EX = 1'b0;
      MEMR_EX = 1'b0;
      MEMW_EX = 1'b0;
      WB_EX = 1'b0;
      IN1_EX = IN1_D;
      IN2_EX = IN2_D;
      Data_EX = Data_D;
      Rd_EX = Rd_D;
      ALUSignal_EX = 00;
      PC_EX = PC_D;
    end
  end
endmodule


module EX_MEM(input clk,WE_EX, MEMR_EX, MEMW_EX, 
    input [1:0]WB_EX,
              input [3:0] Rd_EX,
              input [31:0] Reg2_EX, Result_EX,PC_EX ,
             output reg WE_MEM, MEMR_MEM, MEMW_MEM,
			 output reg [1:0] WB_MEM,
             output reg [3:0] Rd_MEM,
              output reg [31:0] Reg2_MEM, Result_MEM,Pc_MEM);

  always @(posedge clk) begin
    WE_MEM = WE_EX; 
    MEMR_MEM = MEMR_EX; 
    MEMW_MEM = MEMW_EX;
    Pc_MEM = PC_EX; 
    WB_MEM = WB_EX;
    Rd_MEM = Rd_EX;
    Reg2_MEM = Reg2_EX;
    Result_MEM = Result_EX;

  end
endmodule

module MEM_WB(input clk, Regwrite_MEM,
              input [3:0] Rd_MEM,
              input [31:0] Data_MEM,
              output reg Regwrite_WB,
              output reg [3:0] Rd_WB,
              output reg [31:0] Data_WB);
  always @(posedge clk) begin
    Regwrite_WB = Regwrite_MEM;
    Rd_WB = Rd_MEM;
    Data_WB = Data_MEM;
  end
endmodule


