module uart_rx (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        rx,
    output logic [7:0]  data,
    output logic        valid
);

    localparam IDLE   = 3'b000;
    localparam START  = 3'b001;
    localparam DATA   = 3'b010;
    localparam STOP   = 3'b011;
    localparam DONE   = 3'b100;

    logic [2:0]  state;
    logic [2:0]  bit_idx;
    logic [15:0] clk_cnt;
    logic [7:0]  shift_reg;
    logic [15:0] clks_per_bit;
    logic        rx_sync;
    logic        rx_d;

    assign clks_per_bit = 16'd10416;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rx_sync <= 1'b1;
            rx_d    <= 1'b1;
        end else begin
            rx_sync <= rx;
            rx_d    <= rx_sync;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            bit_idx   <= 0;
            clk_cnt   <= 0;
            shift_reg <= 0;
            data      <= 0;
            valid     <= 1'b0;
        end else begin
            valid <= 1'b0;

            case (state)
                IDLE: begin
                    if (rx_d == 1'b0) begin
                        state   <= START;
                        clk_cnt <= 0;
                    end
                end

                START: begin
                    if (clk_cnt < (clks_per_bit >> 1) - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        if (rx_d == 1'b0) begin
                            clk_cnt <= 0;
                            bit_idx <= 0;
                            state   <= DATA;
                        end else begin
                            state <= IDLE;
                        end
                    end
                end

                DATA: begin
                    if (clk_cnt < clks_per_bit - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        shift_reg[bit_idx] <= rx_d;
                        if (bit_idx < 7) begin
                            bit_idx <= bit_idx + 1;
                        end else begin
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    if (clk_cnt < clks_per_bit - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        state <= DONE;
                    end
                end

                DONE: begin
                    data  <= shift_reg;
                    valid <= 1'b1;
                    state <= IDLE;
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule
