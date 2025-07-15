// 3.1 二位十进制加法计数器
// 方法1：在Verilog程序里增加一个十位
module CNT1010 (CLK,RST,EN,COUT,DOUT2,DOUT1);
    input CLK,EN,RST;
    output [3:0] DOUT2,DOUT1;       //DOUT2为十位,DOUT1为个位
    output COUT; 
    reg [3:0] Q2,Q1; reg COUT;
    assign DOUT2 = Q2;
    assign DOUT1 = Q1;
    always @(posedge CLK or negedge RST)    //来一个上升沿，各位加一个数
    begin 
        if(!RST) begin Q1 <= 4'b0000;Q2 <= 4'b0000; end
        else if(EN) 
        begin
            if(Q1 < 9)  Q1 <= Q1 + 1;     //个位计数，逢十归零
            else begin
                Q1 <= 4'b0000;
                if(Q2 < 9)  Q2 <= Q2 + 1;   //十位计数，逢十归零
                else  Q2 <= 4'b0000;
            end
        end
    end
    always @(Q2,Q1) //进位检测，99时进一（应该再来个上升沿才进位？）
        if((Q2==4'h9)&(Q1==4'h9))  COUT = 1'b1;
        else  COUT = 1'b0;
endmodule
