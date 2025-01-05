module hrfp_mult_normalize 
  (output reg expdiff, 
   output reg [53:0] normalized_mantissa, 
   input wire 	     clk, 
   input wire [53:0] mantissa4, mantissa5);

   parameter EARLY_EXPDIFF = 1; 
   parameter EARLY_NORMALIZE = 0;
   wire [3:0] exp_bits4 = mantissa4[53:50];
   wire [3:0] exp_bits5 = mantissa5[53:50];

   always @(posedge clk) begin
      if (EARLY_EXPDIFF) begin
         expdiff <= |exp_bits4;
      end
   end

   always @* begin 
      if (!EARLY_EXPDIFF) begin 
         expdiff = |exp_bits5;
      end
   end

   always @(posedge clk) begin
      if (EARLY_NORMALIZE) begin
         normalized_mantissa <= (exp_bits4) ? mantissa4 : {mantissa4[49:0], 4'b0000};
      end
   end

   always @* begin 
      if (!EARLY_NORMALIZE) begin
         normalized_mantissa = (expdiff) ? mantissa5 : {mantissa5[49:0], 4'b0000};
      end
   end
endmodule