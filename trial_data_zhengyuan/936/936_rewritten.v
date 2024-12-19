module BrzSlice_16_18_1 (
  out_0r, out_0a, out_0d, 
  inp_0r, inp_0a, inp_0d  
);
  input out_0r;
  output out_0a;
  output [15:0] out_0d;
  output inp_0r;
  input inp_0a;
  input [17:0] inp_0d;

  assign {inp_0r, out_0a} = {out_0r, inp_0a};
  assign out_0d = inp_0d[17:2];
endmodule