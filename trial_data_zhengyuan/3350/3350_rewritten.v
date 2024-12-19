module fp_add_v1_altpriority_encoder_n28 (
	data,
	q
);
	input [1:0] data;
	output [0:0] q;
	wire not_data_lsb;
	
	assign not_data_lsb = ~data[0];	
	assign q = not_data_lsb;
endmodule