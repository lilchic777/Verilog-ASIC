// 例10-6 Mealy型状态机 消除毛刺现象
// 把例10-5的组合电路融合到时序电路中
// 含有异步复位端，五进制加法计数器

module MEALY2 (input CLK, DIN1, DIN2, RST, output reg[4:0] Q);
    reg[4:0] PST;
    parameter st0=0, st1=1, st2=2, st3=3, st4=4; //设定4个状态参数
    always @(posedge CLK or posedge RST)    //都挂在时序电路下，即可消除毛刺现象
    begin
        if(RST) PST <= st0; //复位端RST置1，则回到状态st0
        else
            case(PST)
                st0 : begin 
                    if(DIN2==1'b1) Q=5'H10;  else Q=5'H0A;      //DIN2控制输出信号(Q)
                    if(DIN1==1'b1) PST<=st1; else PST<=st0; end //DIN1控制状态转换(PST)
                st1 : begin 
                    if(DIN2==1'b1) Q=5'H17;  else Q=5'H14;
                    if(DIN1==1'b1) PST<=st1; else PST<=st0; end
                st2 : begin 
                    if(DIN2==1'b1) Q=5'H15;  else Q=5'H13;
                    if(DIN1==1'b1) PST<=st1; else PST<=st0; end
                st3 : begin 
                    if(DIN2==1'b1) Q=5'H1B;  else Q=5'H09;
                    if(DIN1==1'b1) PST<=st1; else PST<=st0; end
                st4 : begin 
                    if(DIN2==1'b1) Q=5'H1D;  else Q=5'H0D;
                    if(DIN1==1'b1) PST<=st1; else PST<=st0; end
                default : begin PST<=st0; Q=5'b00000; end
            endcase
    end
endmodule
