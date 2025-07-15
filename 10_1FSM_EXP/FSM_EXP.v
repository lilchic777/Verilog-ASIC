// 例10-1 状态机
// 主控时序过程 + 主控组合过程
// 给出程序“COM_E”，让画状态图

module FSM_EXP (clk,reset,state_inputs,comb_outputs);
    input clk,reset;            //状态机工作时钟和状态机复位控制
    input[0:1] state_inputs;    //来自外部的状态机控制信号
    output[3:0] comb_outputs;   //状态机对外部发出的控制信号输出
    reg[3:0] comb_outputs;
    parameter s0=0,s1=1,s2=2,s3=3,s4=4; //定义状态参数
    reg[4:0] c_st,next_state;           //定义现态和次态的状态变量
    always @(posedge clk or negedge reset) begin    //主控时序过程
        if (!reset) c_st<=s0;   //复位有效时，下一状态进入初态s0
        else c_st <= next_state;
    end
    always @(c_st or state_inputs) begin        //主控组合过程
        case (c_st)
            s0 : begin comb_outputs<=5; //进入状态s0时，输出控制码5（状态译码）
                if (state_inputs==2'b00) next_state<=s0;    //条件满足，回初态s0（状态转换）
                else next_state<=s1; end    //条件不满足，到下一状态s1
            s1 : begin comb_outputs<=8;
                if (state_inputs==2'b01) next_state<=s1;
                else next_state<=s2; end
            s2 : begin comb_outputs<=12;
                if (state_inputs==2'b10) next_state<=s4;
                else next_state<=s3; end
            s3 : begin comb_outputs<=14;
                if (state_inputs==2'b11) next_state<=s3;
                else next_state<=s4; end
            s4 : begin comb_outputs<=9;
                next_state<=s0; end
            default : next_state<=s0;
        endcase 
    end
endmodule
