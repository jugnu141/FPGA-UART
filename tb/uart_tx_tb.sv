`timescale 1ns/1ps

module uart_tx_tb;

    logic        clk;
    logic        rst_n;
    logic [7:0]  data;
    logic        valid;
    logic        ready;
    logic        tx;

    uart_tx dut (
        .clk   (clk),
        .rst_n (rst_n),
        .data  (data),
        .valid (valid),
        .ready (ready),
        .tx    (tx)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        valid = 0;
        data  = 0;
        #100;
        rst_n = 1;
        #50;

        // Send byte 0x55
        @(posedge clk);
        data  = 8'h55;
        valid = 1;
        @(posedge clk);
        valid = 0;

        // Wait for transmission
        wait(ready == 1);
        #1000;

        // Send byte 0xAA
        @(posedge clk);
        data  = 8'hAA;
        valid = 1;
        @(posedge clk);
        valid = 0;

        wait(ready == 1);
        #1000;

        $display("TX testbench complete");
        $finish;
    end

endmodule
