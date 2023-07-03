`default_nettype none

module fir // finite impulse response filter for 10 samples
 #(parameter n = 10,
             w = 16)
  (input  logic clock, reset,
   input  logic [w-1:0] xin,
   input  logic [w-1:0] taps[n-1:0],
   output logic [w-1:0] y);

    logic [w-1:0] x[n-1:0];
    logic [2*w-1:0] y_comb[n:0];

    always_ff @(posedge clock) begin
        if (reset) begin
            x <= '{default:0};
            y <= 0;
        end
        else begin
            x[n-1:1] <= x[n-2:0];
			x[0] <= xin;
			y <= y_comb[n];
        end
    end

    always_comb begin
        y_comb[0] = 0;
        for (int i = 0; i < n; i = i+1)
            y_comb[i+1] = y_comb[i] + (x[i] * taps[i]) >> 15;
            //y_comb[1] = x[0] * 0f85;
    end

endmodule: fir

/*
module fir_test();
    logic clock, reset;
    logic [15:0] xin;
    logic [15:0] taps[9:0];
    logic [15:0] y;

    fir dut (.*);

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        $monitor($time,, "y = %d, x = %d", dut.y, dut.x[0]);
        reset <= 1;
        @(posedge clock);
        reset <= 0;
        taps[0] <= 1;
        taps[1] <= 1;
        taps[2] <= 1;
        taps[3] <= 1;
        taps[4] <= 1;
        taps[5] <= 2;
        taps[6] <= 2;
        taps[7] <= 2;
        taps[8] <= 2;
        taps[9] <= 2;
        // for (int i = 0; i < 10; i = i+1)
        //     taps[i] <= i;
        xin <= 10;
        @(posedge clock);
        xin <= 9;
        @(posedge clock);
        xin <= 8;
        @(posedge clock);
        xin <= 7;
        @(posedge clock);
        xin <= 6;
        @(posedge clock);
        xin <= 5;
        @(posedge clock);
        xin <= 4;
        @(posedge clock);
        xin <= 3;
        @(posedge clock);
        xin <= 2;
        @(posedge clock);
        xin <= 1;
        @(posedge clock);
        #1 $finish;
    end
endmodule: fir_test
*/