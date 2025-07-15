// ZJU作业5第6题（1）
// 描述带同步预置的 4 位可逆计数器。
// ◼ 计数器有三个控制输入 LD、 UP、DN 分别对应三种功能：同步预置、加法计数和减法计数，输入高电平有效。
// ◼ 输入高电平有效，优先顺序是预置、加法计数、减法计数。
module count_bit4 (clk,LD,UP,DN,ld_data,Q);
    // input ports.
    input clk;
    input LD;
    input UP;
    input DN;
    input [3:0] ld_data;    //预置数
    // output ports.
    output [3:0] Q;
    reg [3:0] Q;
    // module function descriptions.
    always @ (posedge clk)  //输入高电平有效
    begin
        if(LD)
            Q <= ld_data;
        else if(UP)
            Q <= Q+1;
        else if(DN)
            Q <= Q-1;
        else
            Q <= Q;
    end
endmodule
