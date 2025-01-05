module design1 
  (output reg expdiff, 
   output reg [53:0] normalized_mantissa, 
   input wire 	     clk, 
   input wire [53:0] mantissa4, mantissa5);
 
   parameter EARLY_EXPDIFF = 1; 
   parameter EARLY_NORMALIZE = 0; 
   generate
      if(EARLY_EXPDIFF) begin : CHECK_EXPDIFF_EARLY 
	 always @(posedge clk) begin 
	    expdiff <= 1; 
	    if(!mantissa4[53:50]) begin 
	       expdiff <= 0; 
	    end
	 end
      end else begin : CHECK_EXPDIFF_LATE 
	 always @* begin 
	    expdiff = 1; 
	    if(!mantissa5[53:50]) begin 
	       expdiff = 0; 
	    end
	 end
      end
   endgenerate
   generate 
      if(EARLY_NORMALIZE) begin : CHECK_NORMALIZATION_EARLY 
	 always @(posedge clk) begin 
            normalized_mantissa <= mantissa4[53:0]; 
            if(!mantissa4[53:50]) begin 
    	       normalized_mantissa <= {mantissa4[49:0], 4'b0000}; 
            end
	 end
      end else begin : CHECK_NORMALIZATION_LATE 
	 always @* begin 
            normalized_mantissa = mantissa5[53:0]; 
            if(!expdiff) begin 
    	       normalized_mantissa = {mantissa5[49:0], 4'b0000}; 
            end
	 end
      end
   endgenerate
endmodule 

module design2 
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

module miter();
wire  expdiff1, expdiff2;
wire [53:0] normalized_mantissa1, normalized_mantissa2;
design1 inst1 (.expdiff(expdiff1),.normalized_mantissa(normalized_mantissa1),.clk(clk),.mantissa4(mantissa4),.mantissa5(mantissa5));
design2 inst2 (.expdiff(expdiff2),.normalized_mantissa(normalized_mantissa2),.clk(clk),.mantissa4(mantissa4),.mantissa5(mantissa5));
always @(posedge clk) begin
assert(expdiff1 == expdiff2);
assert(normalized_mantissa1 == normalized_mantissa2);
end
endmodule