module Ramifier
#(
    parameter BRANCH_CONDITION_WIDTH = 4
)(
  input [(BRANCH_CONDITION_WIDTH - 1):0] condition,
  input negative_flag, zero_flag, carry_flag, overflow_flag,
  output reg take
);
    wire [14:0] conditions;
    
    assign conditions[0]  = zero_flag;
    assign conditions[1]  = !zero_flag;
    assign conditions[2]  = carry_flag;
    assign conditions[3]  = !carry_flag;
    assign conditions[4]  = negative_flag;
    assign conditions[5]  = !negative_flag;
    assign conditions[6]  = overflow_flag;
    assign conditions[7]  = !overflow_flag;
    assign conditions[8]  = carry_flag && !zero_flag;
    assign conditions[9]  = !carry_flag || zero_flag;
    assign conditions[10] = negative_flag ^~ overflow_flag;
    assign conditions[11] = negative_flag ^ overflow_flag;
    assign conditions[12] = (!zero_flag) && (negative_flag ^~ overflow_flag);
    assign conditions[13] = (zero_flag) || (negative_flag ^ overflow_flag);
    assign conditions[14] = 1;

    always @(*) begin
        if (condition < 15)
            take = conditions[condition];
        else
            take = 0;
    end
endmodule