module Forwarding_Unit(
    input  [3:0] Rs, Rd_EX, Rd_MEM, Rd_WB,
    input        EX_WE, Mem_WE, WB_WE,
    output reg [1:0] Forward
);

    always @(*) begin
        if (Rs == Rd_EX && EX_WE)
            Forward = 2'b01;  // Forward from EX
        else if (Rs == Rd_MEM && Mem_WE)
            Forward = 2'b10;  // Forward from MEM
        else if (Rs == Rd_WB && WB_WE)
            Forward = 2'b11;  // Forward from WB
        else
            Forward = 2'b00;  // No forwarding
    end

endmodule




module tb_Forwarding_Unit;

    reg  [3:0] Rs, Rd_EX, Rd_MEM, Rd_WB;
    reg        EX_WE, Mem_WE, WB_WE;
    wire [1:0] Forward;

    Forwarding_Unit dut (
        .Rs(Rs), .Rd_EX(Rd_EX), .Rd_MEM(Rd_MEM), .Rd_WB(Rd_WB),
        .EX_WE(EX_WE), .Mem_WE(Mem_WE), .WB_WE(WB_WE),
        .Forward(Forward)
    );

    task run_test(input [3:0] t_Rs, t_Rd_EX, t_Rd_MEM, t_Rd_WB,
                  input t_EX_WE, t_Mem_WE, t_WB_WE);
    begin
        Rs = t_Rs;
        Rd_EX = t_Rd_EX;
        Rd_MEM = t_Rd_MEM;
        Rd_WB = t_Rd_WB;
        EX_WE = t_EX_WE;
        Mem_WE = t_Mem_WE;
        WB_WE = t_WB_WE;

        #1; // small delay to evaluate

        $display("Rs=%0d EX(Rd=%0d,WE=%b) MEM(Rd=%0d,WE=%b) WB(Rd=%0d,WE=%b) --> Forward = %b",
                  Rs, Rd_EX, EX_WE, Rd_MEM, Mem_WE, Rd_WB, WB_WE, Forward);
    end
    endtask

    initial begin
        $display("=== Forwarding Unit Testbench ===");

        // No matches
        run_test(4'd1, 4'd2, 4'd3, 4'd4, 1'b1, 1'b1, 1'b1);

        // Match with EX only
        run_test(4'd5, 4'd5, 4'd3, 4'd4, 1'b1, 1'b1, 1'b1);

        // Match with MEM only
        run_test(4'd6, 4'd5, 4'd6, 4'd4, 1'b0, 1'b1, 1'b1);

        // Match with WB only
        run_test(4'd7, 4'd1, 4'd2, 4'd7, 1'b0, 1'b0, 1'b1);

        // No write enable
        run_test(4'd8, 4'd8, 4'd8, 4'd8, 1'b0, 1'b0, 1'b0);

        // Priority: EX over MEM and WB
        run_test(4'd9, 4'd9, 4'd9, 4'd9, 1'b1, 1'b1, 1'b1);

        // Priority: MEM over WB
        run_test(4'd10, 4'd0, 4'd10, 4'd10, 1'b0, 1'b1, 1'b1);

        // Only WB (should be 11)
        run_test(4'd11, 4'd0, 4'd0, 4'd11, 1'b0, 1'b0, 1'b1);

        $finish;
    end

endmodule



