// 例10-5 Mealy型状态机
// 输出变化领先Moore型一个周期，一旦输入信号或状态发生变化，输出信号即刻发生变化
// 各状态的转换方式由输入信号DIN1控制
// 对外的控制信号码输出由DIN2控制

module MEALY1 (input CLK, DIN1, DIN2, RST, output reg[4:0] Q);
    reg[4:0] PST;
    parameter st0=0, st1=1, st2=2, st3=3, st4=4; //设定4个状态参数
    always @(posedge CLK or posedge RST)
    begin : REG //状态转换的过程
        if(RST) PST <= st0; //复位端RST置1，则回到状态st0
        else begin
            case(PST)
                st0 : if(DIN1==1'b1) PST<=st1; else PST<=st0;   //1
                st1 : if(DIN1==1'b1) PST<=st2; else PST<=st1;   //11
                st2 : if(DIN1==1'b1) PST<=st3; else PST<=st2;   //111
                st3 : if(DIN1==1'b1) PST<=st4; else PST<=st3;   //1111
                st4 : if(DIN1==1'b0) PST<=st0; else PST<=st4;   //11110 即再来一个0回到状态st0
                default :   PST<=st0;
            endcase
        end
    end
    always @(PST or DIN2)   //纯组合电路，天生就有毛刺现象
    begin : COM //输出控制信号的过程
        case(PST)
            st0 : if(DIN2==1'b1) Q=5'H10; else Q=5'H0A; //转换：1 0000  未转换：0 1010
            st1 : if(DIN2==1'b0) Q=5'H17; else Q=5'H14; //转换：1 0111  未转换：1 0100
            st2 : if(DIN2==1'b1) Q=5'H15; else Q=5'H13; //转换：1 0101  未转换：1 0011
            st3 : if(DIN2==1'b0) Q=5'H1B; else Q=5'H09; //转换：1 1011  未转换：0 1001
            st4 : if(DIN2==1'b1) Q=5'H1D; else Q=5'H0D; //转换：1 1101  未转换：0 1101
            default :   Q=5'b00000;
        endcase
    end
endmodule
