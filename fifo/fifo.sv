`default_nettype none

module fifo // synchronous read and write FIFO based on registers
  #(parameter w = 4,
              d = 8)
   (input  logic clock, reset,
    input  logic we, re,
    input  logic [w-1:0] wdata,
    output logic [w-1:0] rdata,
    output logic full, empty);

    logic [w-1:0] data [d-1:0];
    logic [$clog2(d)-1:0] wpointer, rpointer, count;

    assign full = count >= d;
    assign empty = count == 0;

    always_ff @(posedge clock) begin
        if (reset) begin
            data <= '{default: '0};
            wpointer <= 0;
            rpointer <= 0;
            count <= 0;
        end else begin
            if (we && (!full)) begin
                data[wpointer] <= wdata;
                if (wpointer >= d - 1) wpointer <= 0;
                else wpointer <= wpointer + 1;
                count <= count + 1;
            end
            if (re && (!empty)) begin
                rdata <= data[rpointer];
                if (rpointer >= d - 1) rpointer <= 0;
                else rpointer <= rpointer + 1;
                count <= count - 1;
            end
        end
    end

endmodule: fifo