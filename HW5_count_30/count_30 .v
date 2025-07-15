// ZJU作业5第6题（2）
// 描述设计一个模为 30（0~29）的可逆计数器。
// ◼ 有进位输出端、借位输出端，输出高电平有效；
// ◼ 有计数/保持控制端（stall 高电平时保持）、同步置数控制端（LD 高电平有效）、加/减控制端（UP_DN 高电平加低电平减）、预置数输入端；
// ◼ 输入优先顺序是预置、保持、加或减计数。
// ◼ 进位、借位信号只在计数状态下才会输出有效。
module count_30 (clk, LD, stall, UP_DN, ld_data, Q, C_up, C_dn);
    // input ports.
    input clk;
    input LD;       //同步置数控制端
    input stall;    //计数/保持控制端（高电平时保持）
    input UP_DN;    //加/减控制端（高电平加低电平减）
    input [4:0] ld_data;    //预置数输入端
    // output ports descriptions.
    output [4:0] Q;
    output C_up;    //加进位
    output C_dn;    //减进位
    reg [4:0] Q;
    reg C_up;
    reg C_dn;
    // module function descriptions.
    always @ (posedge clk) begin
        if (LD) //load
            begin Q <= ld_data; C_up <= 0; C_dn <= 0; end
        else if (stall) //keep
            begin Q <= Q; C_up <= 0; C_dn <= 0; end
        else // up or down
            begin
            if ( UP_DN ) // up
                begin
                if ( Q == 5'b11101 )
                    begin Q <= 0; C_up <= 1; C_dn <= 0; end
                else 
                    begin Q <= Q+1; C_up <= 0; C_dn <= 0; end
                end
            else // down
                begin
                if ( Q == 5'b00000 )
                    begin Q <= 5'b11101; C_up <= 0; C_dn <= 1; end
                else 
                    begin Q <= Q-1; C_up <= 0; C_dn <= 0; end
                end
            end
    end
endmodule
