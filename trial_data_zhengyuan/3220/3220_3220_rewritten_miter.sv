module design1 (
    i_data0,
    o_data0
);
  input   [31:0] i_data0;
  output  [31:0]
    o_data0;
  wire [31:0]
    w1,
    w4,
    w3,
    w384,
    w383,
    w1532;
  assign w1 = i_data0;
  assign w1532 = w383 << 2;
  assign w3 = w4 - w1;
  assign w383 = w384 - w1;
  assign w384 = w3 << 7;
  assign w4 = w1 << 2;
  assign o_data0 = w1532;
endmodule

module design2 (
    i_data0,
    o_data0
);
  input   [31:0] i_data0;
  output  [31:0] o_data0;
  wire [31:0] step1, step2, step3, step4, step5, step6;

  assign step1 = i_data0 << 2;
  assign step2 = step1 - i_data0;
  assign step3 = step2 << 7;
  assign step4 = step3 - i_data0;
  assign step5 = step4 << 2;
  assign o_data0 = step5;

endmodule

module miter();
wire [31:0] o_data01, o_data02;
design1 inst1 (.i_data0(i_data0),.o_data0(o_data01));
design2 inst2 (.i_data0(i_data0),.o_data0(o_data02));
always @* begin
assert(o_data01 == o_data02);
end
endmodule