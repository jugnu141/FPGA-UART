module baud_gen (
    input  logic        clk,
    input  logic        rst_n,
    input  logic [2:0]  baud_sel,
    output logic        tick
);

    // Divider values for 100MHz clock
    // 9600:   10416
    // 19200:  5208
    // 38400:  2604
    // 57600:  1736
    // 115200: 868
    localparam DIV_9600   = 16'd10416;
    localparam DIV_19200  = 16'd5208;
    localparam DIV_38400  = 16'd2604;
    localparam DIV_57600  = 16'd1736;
    localparam DIV_115200 = 16'd868;

    logic [15:0] divider;
    logic [15:0] counter;

    always_comb begin
        case (baud_sel)
            3'b000:  divider = DIV_9600;
            3'b001:  divider = DIV_19200;
            3'b010:  divider = DIV_38400;
            3'b011:  divider = DIV_57600;
            3'b100:  divider = DIV_115200;
            default: divider = DIV_9600;
        endcase
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= 0;
            tick    <= 1'b0;
        end else begin
            if (counter >= divider - 1) begin
                counter <= 0;
                tick    <= 1'b1;
            end else begin
                counter <= counter + 1;
                tick    <= 1'b0;
            end
        end
    end

endmodule
