module SyncReset0 (
		   IN_RST,
		   OUT_RST
		   );
   input   IN_RST;
   output  OUT_RST;
   wire    temp_rst;
   buf     (temp_rst, IN_RST);
   buf     (OUT_RST, temp_rst);
endmodule