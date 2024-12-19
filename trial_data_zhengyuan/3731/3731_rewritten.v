module axi_dmac_resize_dest #(  
  parameter DATA_WIDTH_DEST = 64,  
  parameter DATA_WIDTH_MEM = 64   
) (
  input clk,  
  input reset,  
  input mem_data_valid,  
  output mem_data_ready,  
  input [DATA_WIDTH_MEM-1:0] mem_data,  
  input mem_data_last,  
  output dest_data_valid,  
  input dest_data_ready,  
  output [DATA_WIDTH_DEST-1:0] dest_data,  
  output dest_data_last  
);
generate if (DATA_WIDTH_DEST == DATA_WIDTH_MEM) begin  
  assign dest_data_valid = mem_data_valid;  
  assign dest_data = mem_data;  
  assign dest_data_last = mem_data_last;  
  assign mem_data_ready = dest_data_ready;  
end else begin  
  localparam RATIO = DATA_WIDTH_MEM / DATA_WIDTH_DEST;  
  reg [$clog2(RATIO)-1:0] counter;  
  reg [DATA_WIDTH_MEM-1:0] buffer;  
  reg valid_reg, last_reg;
  wire advance;
  
  always @(posedge clk or posedge reset) begin  
    if (reset) begin  
      counter <= 0;  
      valid_reg <= 0;  
      last_reg <= 0;  
    end else if (advance) begin  
      counter <= (counter == RATIO - 1) ? 0 : counter + 1;  
      valid_reg <= (counter == RATIO - 1) ? 0 : 1;  
      last_reg <= (counter == RATIO - 1) && mem_data_last;  
    end else if (mem_data_valid) begin  
      buffer <= mem_data;  
      valid_reg <= 1;  
      last_reg <= mem_data_last;  
    end
  end
  
  assign advance = dest_data_ready & valid_reg;  
  assign mem_data_ready = ~valid_reg | (advance & (counter == RATIO - 1));  
  assign dest_data_valid = valid_reg;  
  assign dest_data = buffer[DATA_WIDTH_DEST-1:0];  
  assign dest_data_last = last_reg;  
  
  always @(posedge clk) begin
    if (advance) begin
      buffer <= buffer >> DATA_WIDTH_DEST;
    end
  end
end 
endgenerate
endmodule