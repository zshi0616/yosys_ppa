module sky130_fd_sc_lp__fa (
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

    // Use basic logic for full adder
    xor (xor1_out, A, B);     // XOR operation for intermediate sum
    xor (SUM, xor1_out, CIN); // Final SUM calculation
    and (and1_out, xor1_out, CIN); // AND operation for carry generation
    and (and2_out, A, B);     // Another AND operation for carry generation
    or  (COUT, and1_out, and2_out); // Final COUT calculation
endmodule