`default_nettype none

module fir_test();
    logic clock, reset;
    logic [15:0] xin;
    logic [15:0] taps[9:0];
    logic [15:0] y;
    logic done;

    fir dut (.*);

    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

    initial begin
        $display("### INFO: RTL Simulation of FIR Filter.");
        fid_mat_inp = $fopen("input.mat", "r");
        fid_mat_oup = $fopen("output.mat", "r");
        if ((fid_mat_inp == `NULL)||(fid_mat_oup == `NULL)) begin
            $display("data_file handle was NULL");
            $finish;
        end
        if (done) begin
            $fclose(fid_mat_inp); 
	        $fclose(fid_mat_oup);
            if (error_count>0)
                $display("### INFO: Testcase FAILED");
            else
                $display("### INFO: Testcase PASSED with %d samples", nr_of_samples);
            $finish;
        end
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