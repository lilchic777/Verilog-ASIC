// 例5-20 （题4.3）半整数与奇数分频器设计
// 占空比为50%的奇数次9分频电路
// N=9，可改为任意奇数次

module FDIV9(rst,clk,Q);
    parameter N=9;
    input clk,rst;
    output Q;
    reg [4:0] m,n;
    reg clk1,clk2;
    assign Q = clk1|clk2;
    always @(posedge clk) begin //clk1上升沿触发
        if(!rst) begin  //复位控制
            clk1<=0;
            m<=0;
        end
        else begin
            if(m==N-1) m<=0; else m<=m+1;   //m在0~N-1间循环
            if(m<(N-1)/2) clk1<=1; else clk1<=0;    //clk1在前(N-1)/2个周期高电平
        end
    end
    
    always @(negedge clk) begin //clk2下降沿触发
        if(!rst) begin  //复位控制
            clk2<=0;
            n<=0;
        end
        else begin
            if(n==N-1) n<=0; else n<=n+1;   //n在0~N-1间循环
            if(n<(N-1)/2) clk2<=1; else clk2<=0;    //clk2在前(N-1)/2个周期高电平
        end
    end
endmodule
