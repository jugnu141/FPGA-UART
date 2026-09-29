# fpga-uart

UART controller for Basys3 FPGA board. Written in SystemVerilog.

## Features

- Full duplex UART TX and RX
- Configurable baud rates: 9600, 19200, 38400, 57600, 115200
- 8N1 format (8 data bits, no parity, 1 stop bit)
- FIFO buffers for TX and RX

## Project Structure

```
rtl/
  uart_tx.sv     - UART transmitter
  uart_rx.sv     - UART receiver
  fifo.sv        - FIFO buffer
  baud_gen.sv    - Baud rate generator
  uart_top.sv    - Top module
constraints/
  basys3.xdc     - Pin constraints for Basys3
tb/
  uart_tx_tb.sv  - TX testbench
  uart_rx_tb.sv  - RX testbench
```

## Baud Rate Selection

Use switches SW0-SW2 to select baud rate:

| SW2 | SW1 | SW0 | Baud Rate |
|-----|-----|-----|-----------|
|  0  |  0  |  0  |   9600    |
|  0  |  0  |  1  |  19200    |
|  0  |  1  |  0  |  38400    |
|  0  |  1  |  1  |  57600    |
|  1  |  0  |  0  | 115200    |

## Usage

1. Open Vivado and create a new project
2. Add all files from `rtl/` as design sources
3. Add `constraints/basys3.xdc` as constraints
4. Run synthesis and implementation
5. Generate bitstream and program the Basys3

## Simulation

Run testbenches with your preferred simulator:

```bash
# Using Icarus Verilog
iverilog -g2012 -o uart_tx_tb.vvp rtl/uart_tx.sv tb/uart_tx_tb.sv
vvp uart_tx_tb.vvp

iverilog -g2012 -o uart_rx_tb.vvp rtl/uart_rx.sv tb/uart_rx_tb.sv
vvp uart_rx_tb.vvp
```
