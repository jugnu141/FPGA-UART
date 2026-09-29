module uart_top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        rx,
    output logic        tx,
    input  logic [2:0]  baud_sel,
    input  logic [7:0]  tx_data,
    input  logic        tx_valid,
    output logic        tx_ready,
    output logic [7:0]  rx_data,
    output logic        rx_valid
);

    logic baud_tick;

    baud_gen u_baud_gen (
        .clk      (clk),
        .rst_n    (rst_n),
        .baud_sel (baud_sel),
        .tick     (baud_tick)
    );

    uart_tx u_uart_tx (
        .clk   (clk),
        .rst_n (rst_n),
        .data  (tx_data),
        .valid (tx_valid),
        .ready (tx_ready),
        .tx    (tx)
    );

    uart_rx u_uart_rx (
        .clk   (clk),
        .rst_n (rst_n),
        .rx    (rx),
        .data  (rx_data),
        .valid (rx_valid)
    );

endmodule
