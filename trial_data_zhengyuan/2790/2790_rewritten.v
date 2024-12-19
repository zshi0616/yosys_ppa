module cycloneive_mux41 (MO, IN0, IN1, IN2, IN3, S);
   input IN0;
   input IN1;
   input IN2;
   input IN3;
   input [1:0] S;
   output reg MO;

   always @(*)
     case(S)
       2'b00: MO = IN0;
       2'b01: MO = IN1;
       2'b10: MO = IN2;
       2'b11: MO = IN3;
     endcase
endmodule