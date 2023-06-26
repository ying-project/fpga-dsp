module ChipInterface
  (input  logic        CLOCK_50,
   input  logic  [3:0] KEY,
   input  logic [17:0] SW,
   output logic  [6:0] HEX0, HEX1, HEX2, HEX3,
                       HEX4, HEX5, HEX6, HEX7);
  logic [2:0] taps[3:0];
  
  always_comb begin
    taps[0] = 1;
    taps[1] = 1;
    taps[2] = 2;
    taps[3] = 2;
  end
  fir #(4, 3) dut (.clock(CLOCK_50), .reset(~KEY[0]), .xin(SW[4:0]), .taps, .y());

endmodule: ChipInterface