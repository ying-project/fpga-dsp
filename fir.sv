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
        for (i = 0; i < n-1; i = i+1) begin
            if (reset) begin
                x[i] <= 0;
                y <= 0;
            end
            else begin
                x[i] <= x[i+1];
                y <= y + x[i] * taps[i];
            end
        end
        if (reset) x[n-1] <= 0;
        else x[n-1] <= xin;
        // y <= y_comb;
    end

    // always_comb begin
    //     for (j = 0; j < n; j = j+1) begin
    //         if (reset) y_comb = 0;
    //         else y_comb = y_comb + x[j] * taps[j];
    //     end
    // end

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
        $monitor($time,, "y = %d, x = %d", y, dut.x[0]);
        reset <= 1;
        @(posedge clock);
        reset <= 0;
        @(posedge clock);
        for (i = 0; i < 10; i++)
            taps[i] <= 1;
        xin <= 10;
        #1000000;
        #1 $finish;
    end
endmodule: fir_test