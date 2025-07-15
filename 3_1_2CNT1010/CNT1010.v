// 再写顶层文件
module CNT1010 (CLK,RST,EN,COUT,DOUT2,DOUT1);
    input CLK,EN,RST;
    output [3:0] DOUT2,DOUT1; 
    output COUT;
    wire a; 
    CNT10 u1(.CLK(CLK),.RST(RST),.EN(EN),.COUT(a),.DOUT(DOUT1));    //u1的进位控制u2的CLK
    CNT10 u2(.CLK(a),.RST(RST),.EN(EN),.COUT(COUT),.DOUT(DOUT2));
endmodule
