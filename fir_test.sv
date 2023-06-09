`default_nettype none

module fir_test();
    logic clock, reset;
    logic [15:0] xin, data_in, data_out;
    logic [15:0] taps[9:0];
    logic [15:0] y, y_temp, y_expect;
    logic done;

    assign xin = data_in;

    fir dut (.*);

    always_comb begin
        taps[0] = 16'hF85;
        taps[1] = 16'h79E;
        taps[2] = 16'h8D8;
        taps[3] = 16'h9C0;
        taps[4] = 16'hA3C;
        taps[5] = 16'hA3C;
        taps[6] = 16'h9C0;
        taps[7] = 16'h8D8;
        taps[8] = 16'h79E;
        taps[9] = 16'hF85;
    end

    initial begin
        clock = 0;
        forever #50 clock = ~clock;
    end

    int mat_input, mat_output, status_input, status_output;
    int sample_num, error_num;
    logic done;

    initial begin
        $display("### INFO: RTL Simulation of FIR Filter.");
        mat_input = $fopen("input.txt", "r");
        mat_output = $fopen("output.txt", "r");
        if ((!mat_input)||(!mat_output)) begin
            $display("data_file handle was NULL");
            $finish;
        end

        reset <= 1'b1;
        y_temp <= 0;
        @(posedge clock);
        reset <= 1'b0;
    end

    always @(posedge done) begin
        $fclose(mat_input);
        $fclose(mat_output);
        if (error_num > 0)
            $display("### INFO: Testcase FAILED with %d errors", error_num);
        else
            $display("### INFO: Testcase PASSED with %d samples", sample_num);
        $finish;
    end
    
    always @(posedge clock) begin 
        status_input = $fscanf(mat_input,"%d\n", data_in);
        status_output = $fscanf(mat_output,"%d\n", data_out);
        //$display("data_in: %d, data_out: %d\n", data_in, data_out);
        sample_num <= sample_num + 1;
        y_temp <= data_out; // delay one clock cycle to account for filter module delay
        y_expect <= y_temp;
        
        if ($feof(mat_input)) begin
            done = 1'b1;
            $display("done with data file");
        end
    end

    always @(negedge clock) begin
        if ((y >= y_expect + 10 || y <= y_expect - 10) && (y_expect > 10 && y_expect < 16'hfff6)) begin // tolerance due to rounding errors
            $error("### RTL = %d, MAT = %d", y, y_expect);
            error_num <= error_num + 1;
        end
    end

endmodule: fir_test