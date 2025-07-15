// 3.4 32选4多路选择器
// 8位数码扫描显示电路设计
// 宏观上是8选1，实际上是32选4：每路都是4位，共8*4=32位选4位

module MUX32_4A (a,b,c,d,e,f,g,h,s2,s1,s0,y);
    input [3:0] a,b,c,d,e,f,g,h;
    input s2,s1,s0;
    output [3:0] y;
    reg [3:0] y;
    always @(*)
    case ({s2,s1,s0})   //位选
        3'b000 : y <= a;    //段选
        3'b001 : y <= b;
        3'b010 : y <= c;
        3'b011 : y <= d;
        3'b100 : y <= e;
        3'b101 : y <= f;
        3'b110 : y <= g;
        3'b111 : y <= h;
        default : y <= 7'bx;
    endcase
endmodule
