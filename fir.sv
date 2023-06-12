`default_nettype none

module fir // finite impulse response filter for 10 samples
 #(parameter n = 10,
             w = 16)
  (input  logic clock, reset,
   input  logic [w-1:0] xin,
   input  logic [w-1:0] taps[n-1:0],
   output logic [w-1:0] y);

    logic [w-1:0] x[n-1:0];
    logic [w-1:0] i, j, y_comb;

    always_ff @(posedge clock) begin
        if (reset) begin
            x <= '{default:0};
            y <= 0;
        end
        else begin
            x[n-1:1] <= x[n-2:0];
			x[0] <= xin;
			y <= y_comb;
            // y <= y + x[i] * taps[i];
        end
        // y <= y_comb;
    end

    always_comb begin
        if (reset) y_comb = 0;
        else begin
            for (j = 0; j < n; j = j+1)
                y_comb += x[j] * taps[j];
        end
    end

endmodule: fir


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

    logic [15:0] i;

    initial begin
        $monitor($time,, "y = %d, x = %d", dut.y_comb, dut.x[0]);
        reset <= 1;
        @(posedge clock);
        reset <= 0;
        for (i = 0; i < 10; i++)
            taps[i] <= 1;
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
        #1000000;
        #1 $finish;
    end
endmodule: fir_test