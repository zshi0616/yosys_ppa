module design1 (
		   IN_RST,
		   OUT_RST
		   );
   input   IN_RST ;
   output  OUT_RST ;
   assign  OUT_RST = IN_RST ;
endmodule

module design2 (
		   IN_RST,
		   OUT_RST
		   );
   input   IN_RST;
   output  OUT_RST;
   wire    temp_rst;
   buf     (temp_rst, IN_RST);
   buf     (OUT_RST, temp_rst);
endmodule

module miter();
wire  OUT_RST1, OUT_RST2;
design1 inst1 (.IN_RST(IN_RST),.OUT_RST(OUT_RST1));
design2 inst2 (.IN_RST(IN_RST),.OUT_RST(OUT_RST2));
always @* begin
assert(OUT_RST1 == OUT_RST2);
end
endmodule