module alu(
    input  signed [31:0] a, b,
    input  [1:0] op,
    output reg signed [31:0] result
);



always @(*) begin
    case(op)
        2'd0: result = a | b; // OR
        2'd1: begin // ADD
            result = a + b;
        end
        2'd2: begin // SUB
            result = a - b;
        end
        2'd3: begin // CMP
            if (a == b) result = 0;
            else if ($signed(a) < $signed(b)) result = -1;
            else if ($signed(a) > $signed(b)) result = 32'h00000001;
        end
        default: result = 0;
    endcase
end

endmodule


`timescale 1ns / 1ps

module alu_tb;

  
    reg [31:0] a, b;
    reg [3:0] op;
    wire [31:0] result;

    alu dut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

    task print_result;
        begin
            $display("op=%0d | a=%0d | b=%0d || result=%0h ", op, a, b, result);
        end
    endtask

    initial begin
        $display("==== Starting ALU Testbench ====");

      
        a = 32'b00000000000000000000000000000101; // 5
        b = 32'b00000000000000000000000000001010; // 10
        op = 4'd0; #10;
        print_result();

     
        a = 32'b00000000000000000000000000001111; // 15
        b = 32'b00000000000000000000000000010100; // 20
        op = 4'd1; #10;
        print_result();

    
        a = 32'b00000000000000000000000000110010; // 50
        b = 32'b00000000000000000000000000010100; // 20
        op = 4'd2; #10;
        print_result();

    
        a = 32'b00000000000000000000000000011110; // 30
        b = 32'b00000000000000000000000000110100; // 20
        op = 4'd3; #10;
        print_result();


        a = 32'b00000000000000000000000000001010; // 10
        b = 32'b00000000000000000000000000010100; // 20
        op = 4'd3; #10;
        print_result();

 
        a = 32'b00000000000000000000000000011001; // 25
        b = 32'b00000000000000000000000000011001; // 25
        op = 4'd3; #10;
        print_result();


        a = 32'b11111111111111110000000000000000; // 0xFFFF0000
        b = 32'b00000000000000000011000000111001; // 12345
        op = 4'd4; #10;
        print_result();


        a = 32'b00000000000000000000000001100100; // 100
        b = 32'b00000000000000000000000000110010; // 50
        op = 4'd5; #10;
        print_result();

    
        a = 32'b00000000000000000000000001100100; // 100
        b = 32'b00000000000000001111111111111111; 
        op = 4'd5; #10;
        print_result();


        a = 32'b00000000000000000000000000000000; // 0
        b = 32'b00000000000000000000000000000000; // 0
        op = 4'd1; #10;
        print_result();


        a = -32'sd5; 
        b = 32'b00000000000000000000000000000000;
        op = 4'd1; #10;
        print_result();


        a = 32'b00000000000000000000000000000111;
        b = 32'b00000000000000000000000000000000;
        op = 4'd1; #10;
        print_result();

        $display("==== Testbench Finished ====");
        $finish;
    end



endmodule