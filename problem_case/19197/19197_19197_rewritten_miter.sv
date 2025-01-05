module design1
(
  input [(4 - 1):0] condition,
  input negative_flag, zero_flag, carry_flag, overflow_flag,
  output reg take
);
    always @ ( * ) begin
        case (condition)
            0:begin 
                take = zero_flag;
            end
            1:begin 
                take = !zero_flag;
            end
            2:begin 
                take = carry_flag;
            end
            3:begin 
                take = !carry_flag;
            end
            4:begin   
                take = negative_flag;
            end
            5:begin   
                take = !(negative_flag);
            end
            6:begin   
                take = overflow_flag;
            end
            7:begin   
                take = !(overflow_flag);
            end
            8:begin   
                take = (carry_flag) && (!zero_flag);
            end
            9:begin   
                take = (!carry_flag) || (zero_flag);
            end
            10:begin    
                take =  (negative_flag ^~ overflow_flag) ;
            end
            11:begin    
                take = (negative_flag ^ overflow_flag);
            end
            12:begin    
                take = (!zero_flag) && (negative_flag ^~ overflow_flag);
            end
            13:begin     
                take = (zero_flag) || (negative_flag ^ overflow_flag);
            end
            14:begin  
                take = 1;
            end
            default: begin
                take = 0; 
            end
        endcase
    end
endmodule

module design2
(
  input [(4 - 1):0] condition,
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

module miter();
wire  take1, take2;
design1 inst1 (.condition(condition),.negative_flag(negative_flag),.zero_flag(zero_flag),.carry_flag(carry_flag),.overflow_flag(overflow_flag),.take(take1));
design2 inst2 (.condition(condition),.negative_flag(negative_flag),.zero_flag(zero_flag),.carry_flag(carry_flag),.overflow_flag(overflow_flag),.take(take2));
always @* begin
assert(take1 == take2);
end
endmodule