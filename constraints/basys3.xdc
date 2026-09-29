## Basys3 UART Constraints

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk]

## Reset button (active low)
set_property PACKAGE_PIN U18 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## USB-UART Interface
set_property PACKAGE_PIN B18 [get_ports rx]
set_property IOSTANDARD LVCMOS33 [get_ports rx]

set_property PACKAGE_PIN A18 [get_ports tx]
set_property IOSTANDARD LVCMOS33 [get_ports tx]

## Baud rate selection switches
set_property PACKAGE_PIN V17 [get_ports {baud_sel[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {baud_sel[0]}]

set_property PACKAGE_PIN V16 [get_ports {baud_sel[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {baud_sel[1]}]

set_property PACKAGE_PIN W16 [get_ports {baud_sel[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {baud_sel[2]}]
