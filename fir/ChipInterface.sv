`default_nettype none

module ChipInterface
    (input  logic        CLOCK_50,
    input  logic  [3:0] KEY,
    input  logic [17:0] SW,
    output logic [17:0] LEDR);
    logic [15:0] taps[9:0];
    
    always_comb begin
        for (int i = 0; i < 10; i = i+1)
            taps[i] <= i;
    end
    fir #(10, 16) dut (.clock(CLOCK_50), .reset(~KEY[0]), .xin(SW[15:0]), .taps, .y(LEDR));

endmodule: ChipInterface