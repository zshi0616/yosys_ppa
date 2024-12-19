module sysgen_reinterpret_4e0592666f (
  input [(16 - 1):0] input_port,
  output [(16 - 1):0] output_port,
  input clk,
  input ce,
  input clr);

  assign output_port = input_port;

endmodule