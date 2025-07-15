// 3.6 带有复位和时钟使能的4位二进制同步加法计数器

module RENC4 (CLK,R,EN,Q);
    input CLK,R,EN;
    output [3:0] Q;
    reg [3:0] Q1;
    assign Q = Q1;
    always @(posedge CLK or negedge R) begin
        if(!R) Q1 <= 0;
        else if(EN) Q1 <= Q1+1;
    end
endmodule
