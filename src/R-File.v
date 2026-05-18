
// Register File module
module RegFile(Pc, Op, src1, src2, RegDest, data_in, WE, clk, Reg1, Reg2); 
  input [5:0] Op;
  input [3:0] src1, src2, RegDest;
  input [31:0] data_in, Pc;
  input WE, clk;
  output reg [31:0] Reg1, Reg2;
  reg [31:0] Registers[15:0] ;
   // 16 registers R0 to R15

  // This block happens when clock goes up
  always @(posedge clk) begin

    // Write data_in to register if WE is 1 and not writing to R15 (PC)
    if (WE && RegDest != 4'd15)
      Registers[RegDest] = data_in;
	  
	  
	  
	  /*
	  	    // If Op is 15, save PC in R14
	    if (Op == 6'b001111)
	      Registers[14] = Pc + 32'b1;
		  $display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		  $display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		  $display(" Registers[14] = %h , Op = %b Rd = %b",Pc,Op,src2); 
		  $display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
		  $display("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
	  */
	  
    /*
	// Print all register values
    $display("Time = %0t:\nR0=%h R1=%h R2=%h R3=%h\nR4=%h R5=%h R6=%h R7=%h\nR8=%h R9=%h R10=%h R11=%h\nR12=%h R13=%h R14=%h R15(PC)=%h\n",
      $time,
      Registers[0], Registers[1], Registers[2], Registers[3],
      Registers[4], Registers[5], Registers[6], Registers[7],
      Registers[8], Registers[9], Registers[10], Registers[11],
      Registers[12], Registers[13], Registers[14], Registers[15]
    ); */
  end 
  
  // This block gives values from register to Reg1 and Reg2
  always @(*) begin
    Reg1 = Registers[src1];
    Reg2 = Registers[src2];
  end

  // Set all registers to 0 at the start
  initial begin
    integer i;
    for (i = 0; i < 16; i = i + 1)
      Registers[i] = 32'h00000000;
  end

endmodule






