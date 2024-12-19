module design1( 
    input  io_valid_0, 
    output io_chosen,  
    input  io_ready);
  
  wire choose;        
  assign io_chosen = choose; 
  assign choose = io_valid_0 ? 1'h0 : 1'h1;
endmodule 

module design2( 
    input  io_valid_0, 
    output io_chosen,  
    input  io_ready);

  not (io_chosen, io_valid_0);

endmodule

module miter();
wire  io_chosen1, io_chosen2;
design1 inst1 (.io_valid_0(io_valid_0),.io_chosen(io_chosen1),.io_ready(io_ready));
design2 inst2 (.io_valid_0(io_valid_0),.io_chosen(io_chosen2),.io_ready(io_ready));
always @* begin
assert(io_chosen1 == io_chosen2);
end
endmodule