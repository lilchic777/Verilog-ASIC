// 题4.4 状态机方法 含有高电平有效异步复位功能的五进制加法计数器

module counter5 (CLK,RST,Q);
    input CLK,RST;
    output [2:0] Q;
    reg[2:0] Q;
    parameter s0=0, s1=1, s2=2, s3=3, s4=4;    //五进制，五种状态
    reg[4:0] c_st, n_st;    //现态，次态
    always@(c_st) begin //主控组合过程
        case(c_st)
            s0: begin Q<=0; n_st<=s1; end  //输出状态控制码，指定次态
            s1: begin Q<=1; n_st<=s2; end
            s2: begin Q<=2; n_st<=s3; end
            s3: begin Q<=3; n_st<=s4; end
            s4: begin Q<=4; n_st<=s0; end
            default: begin Q<=0; n_st<=s0; end
        endcase
    end
    always@ (posedge CLK, posedge RST) begin    //主控时序过程
        if(RST) c_st <= s0;    //复位控制端
        else c_st <= n_st;
    end
endmodule
