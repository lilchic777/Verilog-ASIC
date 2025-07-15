// 例10-4 序列检测器，对8位序列数“1101 0011”检测
// 检测到该序列输出1，否则输出0

module SCHK (input CLK, DIN, RST, output SOUT);
    parameter s0=40, s1=41, s2=42, s3=43, s4=44, s5=45, s6=46, s7=47, s8=48;
    //设定9个状态参数
    reg[8:0] ST,NST;    //设定现态变量和次态变量
    always @(posedge CLK or posedge RST)
        if(RST) ST<=s0; //复位端RST置1，则回到状态s0
        else ST<=NST;   //复位端RST不为1，则来一个上升沿，转换一个次态
    always @(ST or DIN)
    begin   //1101 0011串行输入，高位在前
        case (ST)
            s0 : if(DIN==1'b1) NST<=s1; else NST<=s0;   //1
            s1 : if(DIN==1'b1) NST<=s2; else NST<=s0;   //11
            s2 : if(DIN==1'b0) NST<=s3; else NST<=s2;   //110
            s3 : if(DIN==1'b1) NST<=s4; else NST<=s0;   //1101
            s4 : if(DIN==1'b0) NST<=s5; else NST<=s2;   //1101 0
            s5 : if(DIN==1'b0) NST<=s6; else NST<=s1;   //1101 00
            s6 : if(DIN==1'b1) NST<=s7; else NST<=s0;   //1101 001
            s7 : if(DIN==1'b1) NST<=s8; else NST<=s0;   //1101 0011
            s8 : if(DIN==1'b0) NST<=s3; else NST<=s2;
            default : NST<=s0;
        endcase
    end
    assign SOUT = (ST==s8); //到状态s8时，输出1
endmodule
