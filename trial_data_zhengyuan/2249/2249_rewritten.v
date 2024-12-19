module RREncode_14( 
    input  io_valid_0, 
    output io_chosen,  
    input  io_ready);

  not (io_chosen, io_valid_0);

endmodule