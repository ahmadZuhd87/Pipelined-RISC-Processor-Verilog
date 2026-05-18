module mux2_32(input sel, input [31:0] i0, i1, output [31:0] out);
    assign out = sel ? i1 : i0;
endmodule

module mux4_32(
    input [1:0] sel,
    input [31:0] i0, i1, i2, i3,
    output reg [31:0] out  
);
    always @(*) begin
        case(sel)
            2'b00: out = i0;
            2'b01: out = i1;
            2'b10: out = i2;
            2'b11: out = i3;
            default: out = i0;
        endcase
    end
endmodule



module mux4 #(parameter WIDTH = 32)
             (input  [WIDTH-1:0] d0, d1, d2, d3,
              input  [1:0]       s, 
              output [WIDTH-1:0] y);

  assign y = s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0); 
endmodule	

module adder(
    input  [31:0] a, b,
    output [31:0] y
);
    assign y = a + b;
endmodule

module subtractor(
    input  [31:0] a, b,
    output        Z, N, V,
    output [31:0] y
);
    assign y = a - b;
    assign N = y[31];
    assign V = (a[31] ^ b[31]) & (a[31] ^ y[31]);
    assign Z = ~|y;
endmodule


module signext(
    input [13:0] in,
    output reg [31:0] sign_ext_out
);

always @(*) begin
    sign_ext_out = {{18{in[13]}}, in};
end

endmodule


module flopr #(parameter WIDTH = 32) // register with reset
              (input                  clk, reset,
               input      [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(negedge clk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule




