module uart_tx (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [7:0]  data,
    input  logic        valid,
    output logic        ready,
    output logic        tx
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    logic [1:0]  state;
    logic [2:0]  bit_idx;
    logic [15:0] clk_cnt;
    logic [7:0]  shift_reg;
    logic [15:0] clks_per_bit;

    assign clks_per_bit = 16'd10416;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            bit_idx   <= 0;
            clk_cnt   <= 0;
            shift_reg <= 0;
            tx        <= 1'b1;
            ready     <= 1'b1;
        end else begin
            case (state)
                IDLE: begin
                    tx    <= 1'b1;
                    ready <= 1'b1;
                    if (valid) begin
                        shift_reg <= data;
                        state     <= START;
                        ready     <= 1'b0;
                        clk_cnt   <= 0;
                    end
                end

                START: begin
                    tx <= 1'b0;
                    if (clk_cnt < clks_per_bit - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        bit_idx <= 0;
                        state   <= DATA;
                    end
                end

                DATA: begin
                    tx <= shift_reg[bit_idx];
                    if (clk_cnt < clks_per_bit - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        clk_cnt <= 0;
                        if (bit_idx < 7) begin
                            bit_idx <= bit_idx + 1;
                        end else begin
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1;
                    if (clk_cnt < clks_per_bit - 1) begin
                        clk_cnt <= clk_cnt + 1;
                    end else begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
