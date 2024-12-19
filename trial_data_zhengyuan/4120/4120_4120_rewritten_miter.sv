module design1(OT, X);
input   OT; 
output  X;  
wire    OT_; 
wire    tmg1m1n_out; 
wire    tmg1m1n_out_; 
wire    ENC; 
wire    bscn_xd0; 
wire    bscn_d0; 
wire    bscn_xd1; 
wire    bscn_d1; 
wire    out_buf_a; 
wire    out_buf_b; 
wire    out_buf_en; 
not     g1(OT_, OT); 
not     g2(tmg1m1n_out, OT_); 
not     g3(ENC, 1'b0); 
not     g4(tmg1m1n_out_, tmg1m1n_out); 
and     g5(bscn_xd0, ENC, tmg1m1n_out); 
or      g6(bscn_d0, 1'b0, tmg1m1n_out_); 
or      g7(bscn_xd1, 1'b0, tmg1m1n_out); 
and     g8(bscn_d1, ENC, tmg1m1n_out_); 
not     g9(out_buf_a, bscn_xd0); 
not     g10(out_buf_b, bscn_xd1); 
xor     g11(out_buf_en, out_buf_a, out_buf_b); 
notif0  g12(X, out_buf_a, out_buf_en); 
endmodule

module design2(OT, X);
input   OT; 
output  X;  

wire n1, n2, and_a, and_b, or_a, or_b;


not     (n1, OT);


nand    (n2, n1, n1); 


nand    (and_a, n2, n1);
nor     (or_b, n1, n2);


xnor    (X, and_a, or_b);

endmodule

module miter();
wire  X1, X2;
design1 inst1 (.OT(OT),.X(X1));
design2 inst2 (.OT(OT),.X(X2));
always @* begin
assert(X1 == X2);
end
endmodule