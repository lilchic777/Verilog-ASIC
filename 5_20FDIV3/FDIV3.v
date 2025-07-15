// 例5-20 半整数与奇数分频器设计
// 占空比为50%的奇数次5分频电路

module FDIV3 (CLK,K_OR,K1,K2);
    input CLK;
    output K_OR,K1,K2;
    reg[2:0] C1,C2;
    reg M1,M2;
    always @(posedge CLK) begin
        if (C1==4) C1<=0;   else C1<=C1+1;  //C1在0~4间循环
        if (C1==1) M1<=~M1; else if (C1==3) M1=~M1; //第1、第3个上升沿时，K1翻转
    end
    always @(negedge CLK) begin
        if (C2==4) C2<=0;   else C2<=C2+1;  //C2在0~4间循环
        if (C2==1) M2<=~M2; else if (C2==3) M2=~M2; //第1、第3个下降沿时，K2翻转
    end
    assign K1 = M1;
    assign K2 = M2;
    assign K_OR = M1 | M2;  //最终输出M1和M2的或运算结果，即实现5分频
endmodule
