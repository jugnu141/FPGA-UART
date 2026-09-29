`timescale 1ns/1ps

module uart_rx_tb;

    logic        clk;
    logic        rst_n;
    logic        rx;
    logic [7:0]  data;
    logic        valid;

    localparam BIT_PERIOD = 104160;

    uart_rx dut (
        .clk   (clk),
        .rst_n (rst_n),
        .rx    (rx),
        .data  (data),
        .valid (valid)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task send_byte(input [7:0] byte_val);
        integer i;
        begin
            // Start bit
            rx = 0;
            #BIT_PERIOD;

            // Data bits
            for (i = 0; i < 8; i = i + 1) begin
                rx = byte_val[i];
                #BIT_PERIOD;
            end

            // Stop bit
            rx = 1;
            #BIT_PERIOD;
        end
    endtask

    initial begin
        rst_n = 0;
        rx    = 1;
        #100;
        rst_n = 1;
        #50;

        send_byte(8'h55);
        #5000;

        if (data == 8'h55) begin
            $display("PASS: Received 0x55");
        end else begin
            $display("FAIL: Expected 0x55, got 0x%h", data);
        end

        send_byte(8'hAA);
        #5000;

        if (data == 8'hAA) begin
            $display("PASS: Received 0xAA");
        end else begin
            $display("FAIL: Expected 0xAA, got 0x%h", data);
        end

        $display("RX testbench complete");
        $finish;
    end

endmodule
