
module round_control1 (
    input  wire       clk,
    input  wire       reset,
    input  wire [5:0] op,
    output reg        round2_load,
    output reg        round2_store
);

    reg   load_counter;
    reg   store_counter;
    reg        prev_op8, prev_op9;

    wire op8_now  = (op == 6'd8);
    wire op9_now  = (op == 6'd9);
    wire op8_rise = op8_now && !prev_op8;
    wire op9_rise = op9_now && !prev_op9;

    always @(posedge clk) begin
       
        prev_op8 <= op8_now;
        prev_op9 <= op9_now;

        if (reset) begin
            load_counter   = 0;
            store_counter  = 0;
            round2_load    = 0;
            round2_store   = 0;
        end else begin
       
            if (op8_rise)
                load_counter = 1;

            
            if (op9_rise)
                store_counter = 1;

     
            if (load_counter > 0) begin
                round2_load  = 1;
                load_counter = load_counter - 1;
            end else
                round2_load = 0;

      
            if (store_counter > 0) begin
                round2_store  = 1;
                store_counter = store_counter - 1;
            end else
                round2_store = 0;
        end
    end
endmodule
