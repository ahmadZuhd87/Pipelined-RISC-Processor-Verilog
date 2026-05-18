module Instruction_mem (
    input  [31:0] Pc,
    output reg [31:0] Instr
);
    reg [31:0] mem [0:127];

    initial begin
        $readmemh("input.txt", mem);  
    end

    always @(*) begin
        Instr = mem[Pc];
    end
endmodule
	


module Data_MEM (
    input clk,
    input [31:0] data_in,
    input [31:0] address,
    input MEM_W,
    input MEM_R,
    output reg [31:0] data_out
);

    // 32-bit memory with 64K entries
    reg [31:0] RAM [0:65535];

    // Load initial values from file
    initial begin
        $readmemh("DataMem.txt", RAM);  // HEX values file for 32-bit
    end

    // Display first few values at simulation time 0
    initial $display(
    "At time = %0d, MEM[0] = %0d, MEM[1] = %0d, MEM[2] = %0d, MEM[3] = %0d, MEM[4] = %0d, MEM[5] = %0d",$time,RAM[0], RAM[1], RAM[2], RAM[3], RAM[4],
    RAM[5]
);

    // Asynchronous read
    always @(*) begin
        if (MEM_R)
            data_out = RAM[address];
        else
            data_out = 32'hXXXXXXXX; // undefined value if not reading
    end

    // Synchronous write on positive edge of clock
    always @(posedge clk) begin
        if (MEM_W) begin
            RAM[address] = data_in;
            $display("WRITE to MEM[%0d] = %0d at time = %0t", address, data_in, $time);
        end
    end

endmodule













