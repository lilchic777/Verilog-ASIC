// 3.2 二位十进制加法计数器
// 方法2：层次化方法
// 先写1位十进制计数器（这里省略数据加载功能），进位波形做了改进。
module CNT10 (CLK,RST,EN,COUT,DOUT);
   input CLK,EN,RST;
   output [3:0] DOUT; 
   output COUT; 
   reg [3:0] Q1; reg COUT;
   assign DOUT = Q1;
   always @(posedge CLK or negedge RST)
   begin 
      if (!RST) Q1 <= 4'b0000;
      else if (EN) 
      begin
         if (Q1 < 9) begin Q1 <= Q1 + 1; COUT = 1'b0; end
         else begin Q1 <= 4'b0000; COUT = 1'b1; end
      end           
   end
endmodule
