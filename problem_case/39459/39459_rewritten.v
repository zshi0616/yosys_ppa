module ccx_global_int_buf(
   rst_l_buf, se_buf, adbginit_l_buf, 
   rst_l, se, adbginit_l 
   );
   output wire rst_l_buf ; 
   output wire se_buf ; 
   output wire adbginit_l_buf ; 
   input wire rst_l ; 
   input wire se ; 
   input wire adbginit_l ; 

   wire [2:0] input_signals;
   wire [2:0] output_signals;

   assign input_signals = {rst_l, se, adbginit_l};
   assign output_signals = input_signals;
   assign {rst_l_buf, se_buf, adbginit_l_buf} = output_signals;

endmodule