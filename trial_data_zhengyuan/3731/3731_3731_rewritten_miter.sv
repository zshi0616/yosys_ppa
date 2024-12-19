module design1  (
  input clk,  
  input reset,  
  input mem_data_valid,  
  output mem_data_ready,  
  input [64-1:0] mem_data,  
  input mem_data_last,  
  output dest_data_valid,  
  input dest_data_ready,  
  output [64-1:0] dest_data,  
  output dest_data_last  
);
generate if (64 == 64)  begin  
  assign dest_data_valid = mem_data_valid;  
  assign dest_data = mem_data;  
  assign dest_data_last = mem_data_last;  
  assign mem_data_ready = dest_data_ready;  
end else begin  
  localparam RATIO = 64 / 64;  
  reg [$clog2(RATIO)-1:0] count = 'h0;  
  reg valid = 1'b0;  
  reg [RATIO-1:0] last = 'h0;  
  reg [64-1:0] data = 'h0;  
  wire last_beat;  
  assign last_beat = count == RATIO - 1;  
  always @(posedge clk) begin  
    if (reset == 1'b1) begin  
      valid <= 1'b0;  
    end else if (mem_data_valid == 1'b1) begin  
      valid <= 1'b1;  
    end else if (last_beat == 1'b1 && dest_data_ready == 1'b1) begin  
      valid <= 1'b0;  
    end
  end
  always @(posedge clk) begin  
    if (reset == 1'b1) begin  
      count <= 'h0;  
    end else if (dest_data_ready == 1'b1 && dest_data_valid == 1'b1) begin  
      count <= count + 1;  
    end
  end
  assign mem_data_ready = ~valid | (dest_data_ready & last_beat);  
  always @(posedge clk) begin  
    if (mem_data_ready == 1'b1) begin  
      data <= mem_data;  
      last <= {mem_data_last,{RATIO-1{1'b0}}};  
    end else if (dest_data_ready == 1'b1) begin  
      data[64-64-1:0] <= data[64-1:64];  
      last[RATIO-2:0] <= last[RATIO-1:1];  
    end
  end
  assign dest_data_valid = valid;  
  assign dest_data = data[64-1:0];  
  assign dest_data_last = last[0];  
end endgenerate
endmodule

module design2  (
  input clk,  
  input reset,  
  input mem_data_valid,  
  output mem_data_ready,  
  input [64-1:0] mem_data,  
  input mem_data_last,  
  output dest_data_valid,  
  input dest_data_ready,  
  output [64-1:0] dest_data,  
  output dest_data_last  
);
generate if (64 == 64) begin  
  assign dest_data_valid = mem_data_valid;  
  assign dest_data = mem_data;  
  assign dest_data_last = mem_data_last;  
  assign mem_data_ready = dest_data_ready;  
end else begin  
  localparam RATIO = 64 / 64;  
  reg [$clog2(RATIO)-1:0] counter;  
  reg [64-1:0] buffer;  
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
  assign dest_data = buffer[64-1:0];  
  assign dest_data_last = last_reg;  
  
  always @(posedge clk) begin
    if (advance) begin
      buffer <= buffer >> 64;
    end
  end
end 
endgenerate
endmodule

module miter();
wire  mem_data_ready1, mem_data_ready2;
wire  dest_data_valid1, dest_data_valid2;
wire [63:0] dest_data1, dest_data2;
wire  dest_data_last1, dest_data_last2;
design1 inst1 (.clk(clk),.reset(reset),.mem_data_valid(mem_data_valid),.mem_data_ready(mem_data_ready1),.mem_data(mem_data),.mem_data_last(mem_data_last),.dest_data_valid(dest_data_valid1),.dest_data_ready(dest_data_ready),.dest_data(dest_data1),.dest_data_last(dest_data_last1));
design2 inst2 (.clk(clk),.reset(reset),.mem_data_valid(mem_data_valid),.mem_data_ready(mem_data_ready2),.mem_data(mem_data),.mem_data_last(mem_data_last),.dest_data_valid(dest_data_valid2),.dest_data_ready(dest_data_ready),.dest_data(dest_data2),.dest_data_last(dest_data_last2));
always @(posedge clk) begin
assert(mem_data_ready1 == mem_data_ready2);
assert(dest_data_valid1 == dest_data_valid2);
assert(dest_data1 == dest_data2);
assert(dest_data_last1 == dest_data_last2);
end
endmodule