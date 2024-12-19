module multiplier_block (
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