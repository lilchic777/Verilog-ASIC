//文件名:display.v
module display(clk,num,rst,out);
input clk;//时钟信号
input [4:0] num;//输入十进制数码的8421BCD码
input rst;//复位信号(置0)
output reg [6:0] out;//输出七段数码管对应的7位信号
always @(posedge clk or posedge rst)
begin
    if(rst)
        out<=7'b1000000;//收到复位信号，数码管输出置0
    else
    begin
        case(num) //将0-9九个数译成对应的七段数码管取值
            5'b00000:
                out <= 7'b1000000;//1111110，取反+倒置
            5'b00001:
                out <= 7'b1111001;//0110000
            5'b00010:
                out <= 7'b0100100;//1101101
            5'b00011:
                out <= 7'b0110000;//1111001
            5'b00100:
                out <= 7'b0011001;//0110011
            5'b00101:
                out <= 7'b0010010;//1011011
            5'b00110:
                out <= 7'b0000010;//1011111
            5'b00111:
                out <= 7'b1111000;//1110000
            5'b01000:
                out <= 7'b0000000;//1111111
            5'b01001:
                out <= 7'b0010000;//1111011
            5'b01010:
                out <= 7'b1111111;
            default:
                out <= 7'b1000000;//1111110
        endcase
    end
end
endmodule
