// 3.5 20选2多路选择器
// （10位数码扫描显示电路设计）
// 宏观上是10选1，实际上是20选2：每路都是2位，共10*2=20位选2位

module MUX20_2A (a,b,c,d,e,f,g,h,i,j,s3,s2,s1,s0,y);
    input [1:0] a,b,c,d,e,f,g,h,i,j;
    input s3,s2,s1,s0;
    output [1:0] y;
    reg [1:0] y;
    always@(*)
    case ({s3,s2,s1,s0})
        4'b0000: y<=a;
        4'b0001: y<=b;
        4'b0010: y<=c;
        4'b0011: y<=d;
        4'b0100: y<=e;
        4'b0101: y<=f;
        4'b0110: y<=g;
        4'b0111: y<=h;
        4'b1000: y<=i;
        4'b1001: y<=j;
        default: y<=7'bx;   //表示未知值
    endcase
endmodule
