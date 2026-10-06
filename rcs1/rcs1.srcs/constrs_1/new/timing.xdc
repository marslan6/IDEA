# Set clock period to 18.0 ns (55.5 MHz) to meet physical timing rules of the 3-multiplier critical path
create_clock -period 18.000 -name sys_clk [get_ports CLOCK]