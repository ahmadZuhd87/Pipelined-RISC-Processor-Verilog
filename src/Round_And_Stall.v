module Round_Fetch(input clk , input [5:0] Op , output reg Load ,Store);
	always@(posedge clk)begin	 
		if(Op == 8) begin
			Load = 1;
		end
	else if(Op == 9) begin
		Store = 1;	
	end
	else begin
		Store = 0;
		Load = 0;	
	end
	end
endmodule
