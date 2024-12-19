module design1 (
  out_0r, out_0a, out_0d, 
  inp_0r, inp_0a, inp_0d  
);
  input out_0r;
  output out_0a;
  output [15:0] out_0d;
  output inp_0r;
  input inp_0a;
  input [17:0] inp_0d;
  assign inp_0r = out_0r;
  assign out_0a = inp_0a;
  assign out_0d[0] = inp_0d[1];
  assign out_0d[1] = inp_0d[2];
  assign out_0d[2] = inp_0d[3];
  assign out_0d[3] = inp_0d[4];
  assign out_0d[4] = inp_0d[5];
  assign out_0d[5] = inp_0d[6];
  assign out_0d[6] = inp_0d[7];
  assign out_0d[7] = inp_0d[8];
  assign out_0d[8] = inp_0d[9];
  assign out_0d[9] = inp_0d[10];
  assign out_0d[10] = inp_0d[11];
  assign out_0d[11] = inp_0d[12];
  assign out_0d[12] = inp_0d[13];
  assign out_0d[13] = inp_0d[14];
  assign out_0d[14] = inp_0d[15];
  assign out_0d[15] = inp_0d[16];
endmodule

module design2 (
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

module miter();
wire  out_0a1, out_0a2;
wire [15:0] out_0d1, out_0d2;
wire  inp_0r1, inp_0r2;
design1 inst1 (.out_0r(out_0r),.out_0a(out_0a1),.out_0d(out_0d1),.inp_0r(inp_0r1),.inp_0a(inp_0a),.inp_0d(inp_0d));
design2 inst2 (.out_0r(out_0r),.out_0a(out_0a2),.out_0d(out_0d2),.inp_0r(inp_0r2),.inp_0a(inp_0a),.inp_0d(inp_0d));
always @* begin
assert(out_0a1 == out_0a2);
assert(out_0d1 == out_0d2);
assert(inp_0r1 == inp_0r2);
end
endmodule