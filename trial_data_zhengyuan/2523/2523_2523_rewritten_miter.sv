module design1 (
    COUT,  
    SUM,   
    A,     
    B,     
    CIN    
);
    output COUT; 
    output SUM;  
    input  A;    
    input  B;    
    input  CIN;  
    wire or0_out;      
    wire and0_out;     
    wire and1_out;     
    wire and2_out;     
    wire nor0_out;     
    wire nor1_out;     
    wire or1_out_COUT; 
    wire or2_out_SUM;  
    or  or0  (or0_out, CIN, B);
    and and0 (and0_out, or0_out, A);
    and and1 (and1_out, B, CIN);
    or  or1  (or1_out_COUT, and1_out, and0_out);
    buf buf0 (COUT, or1_out_COUT);
    and and2 (and2_out, CIN, A, B);
    nor nor0 (nor0_out, A, or0_out);
    nor nor1 (nor1_out, nor0_out, COUT);
    or  or2  (or2_out_SUM, nor1_out, and2_out);
    buf buf1 (SUM, or2_out_SUM);
endmodule

module design2 (
    COUT,  
    SUM,   
    A,     
    B,     
    CIN    
);
    output COUT; 
    output SUM;  
    input  A;    
    input  B;    
    input  CIN;

    wire xor1_out;
    wire and1_out;
    wire and2_out;

    
    xor (xor1_out, A, B);     
    xor (SUM, xor1_out, CIN); 
    and (and1_out, xor1_out, CIN); 
    and (and2_out, A, B);     
    or  (COUT, and1_out, and2_out); 
endmodule

module miter();
wire  COUT1, COUT2;
wire  SUM1, SUM2;
design1 inst1 (.COUT(COUT1),.SUM(SUM1),.A(A),.B(B),.CIN(CIN));
design2 inst2 (.COUT(COUT2),.SUM(SUM2),.A(A),.B(B),.CIN(CIN));
always @* begin
assert(COUT1 == COUT2);
assert(SUM1 == SUM2);
end
endmodule