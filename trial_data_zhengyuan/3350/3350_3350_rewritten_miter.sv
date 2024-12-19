module  design1
	(
	data,
	q) ;
	input   [1:0]  data;
	output   [0:0]  q;
	assign
		q = {(~ data[0])};
endmodule

module design2 (
	data,
	q
);
	input [1:0] data;
	output [0:0] q;
	wire not_data_lsb;
	
	assign not_data_lsb = ~data[0];	
	assign q = not_data_lsb;
endmodule

module miter();
wire  q1, q2;
design1 inst1 (.data(data),.q(q1));
design2 inst2 (.data(data),.q(q2));
always @* begin
assert(q1 == q2);
end
endmodule