module JOA13NN(OT, X);
input   OT; 
output  X;  

wire n1, n2, and_a, and_b, or_a, or_b;

// Perform initial inversion
not     (n1, OT);

// Generate intermediate signals
nand    (n2, n1, n1); // Equivalent to not with less area for some technologies

// Use nand and nor instead of separate and, or, and not gates
nand    (and_a, n2, n1);
nor     (or_b, n1, n2);

// Reorganize logic operations to minimize intermediate signals
xnor    (X, and_a, or_b);

endmodule