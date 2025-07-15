// 3.2 3-8译码器 + 7段共阴数码管
// 设计一个与共阴极数字显示器配合使用的7段数码显示译码器
// case语句

module DECODE38 ( G1 ,Y ,G2 ,A ,G3 );
    input G1, G2, G3; // 片选输入端/附加控制端
    wire G1, G2, G3;
    input [2:0] A ;
    wire [2:0] A ;
    output [7:0] Y ;
    reg [7:0] Y ;
    reg s;
    always @ (A ,G1, G2, G3)
    begin 
        s <= G2 | G3 ;
        if (G1 == 0) 
            Y <= 8'b1111_1111;  //注意此处赋值方式与下方不同
        else if (s)
            Y <= 8'b1111_1111;
        else
            case ( A )
                3'b000: Y = 8'b11111110;    //0
                3'b001: Y = 8'b11111101;    //1
                3'b010: Y = 8'b11111011;
                3'b011: Y = 8'b11110111;
                3'b100: Y = 8'b11101111;
                3'b101: Y = 8'b11011111;
                3'b110: Y = 8'b10111111;
                3'b111: Y = 8'b01111111;    //7
                default:Y = 8'b11111110;    //0
            endcase
    end
endmodule 

