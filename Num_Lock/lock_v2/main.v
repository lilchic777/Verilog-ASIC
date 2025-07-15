module main(key,led_g,led_r,clk,pos,led,beep,led_test,key_all,status,judge,setpw,rst);
input [9:0] key;//对应开关量输入模块二，按键开关
input clk;
//input clk0,clk1,clk2,clk3;//右侧4个拨码按键模拟的时钟信号，用于给数码+1
input rst;//拨码开关K6，复位信号
input setpw;//拨码开关K7，设置密码状态
input judge;//拨码开关K8，输入密码模式

output led_g,led_r,beep,led_test;
output reg [7:0] pos;//右侧右侧4个数码管位选
output [6:0] led;//右侧4个数码管段选，表示当前数码管显示的数字字形
// output [6:0] led_countdown;//左侧4个数码管段选，显示倒计时数码
//output reg pos_countdown;//左1数码管位选，用于显示倒计时
output reg status;//右1LED，表示开锁状态
//output reg g_rst; //左1LED，表示复位状态
output reg key_all;

reg led_g,led_r,beep,led_test;//绿灯(L2)，红灯(L3)，蜂鸣器，测试用LED(L8)
integer clock_led,clock_countdown,i,j,q0,q1,q2,q3,pressed,q3_flag,q2_flag,q1_flag,q0_flag,counter,beep_end;//计算上升沿数量，用于分频
// reg [3:0] q;
// wire [3:0] q0,q1,q2,q3;//存储当前输入的四个数码
reg [3:0] pw0,pw1,pw2,pw3;//存储当前保存的四位密码
reg [4:0] num;//存储当前位选下数码管显示的数字
reg timeout;//分频给数码管动态显示
reg [3:0] countdown;//倒计时，这里设为5s倒计时
//reg [16:0] counter;//按键消抖用
reg input_start,input_rst;

initial
begin
	countdown=4'b0101; //初始时设倒计时为5s
	pos=8'b11111110; //右侧四个数码管位选先选到最右侧一个数码管
	timeout=0;
	clock_led=0;//分频，使数码管能动态显示
    beep=1;
    led_test=1;
	led_g = 1;
	led_r = 1;
	key_all = 1;
	clock_countdown=0; //计数，控制倒计时
	//pos_countdown=1; //左侧4个数码管段选始终选到最左侧一个
	status=1; //开锁状态先打开
	//g_rst = 0;  //先不处于复位状态
    q3_flag = 0; q2_flag = 0; q1_flag = 0; q0_flag = 0;
    pw3=8; pw2=4; pw1=2; pw0=1;//默认密码：8421
    beep_end = 0;
end

// //右侧四个拨码按键的输入，通过模10计数器输入十进制0~9数码
// mod10counter u0(clk0,input_rst,input_start,q0);
// mod10counter u1(clk1,input_rst,input_start,q1);
// mod10counter u2(clk2,input_rst,input_start,q2);
// mod10counter u3(clk3,input_rst,input_start,q3);

//输入读取，这里不用模10计数器
// always@(k1 or k2 or k3 or k4 or k5 or k6 or k7 or k8)
// 	begin :main
// 		if(!k1) q3 <= 1;
//         else if(!k2) q3 <= 2;
//         else if(!k3) q3 <= 3;
//         else if(!k4) q3 <= 4;
//         else if(!k5) q3 <= 5;
//         else if(!k6) q3 <= 6;
//         else if(!k7) q3 <= 7;
//         else if(!k8) q3 <= 8;
// 	end

//右侧四个数码管显示4位密码，led为右侧数码管段选
display s0(clk,num,input_rst,led);

// //左1数码管显示倒计时,led_countdown为左侧数码管段选
// display s1(clk,7,0,led_countdown);// display s1(clk,countdown,0,led_countdown);

always @(posedge clk) //输入控制模块
begin
    if(countdown==8'b0000)//5s倒计时结束，电路复位
    begin
        input_start<=0; //停止拨码按键输入
        input_rst<=1; //数码管复位信号置1，令所有数码管显示0
        //g_rst <= 1; //复位信号置1
    end
    else
    begin
        //g_rst <= 0; //正常情况下复位信号置0
    	input_start<=setpw|judge; //要么处于重置密码状态，要么处于输入密码状态，都是处于输入状态
    	input_rst<=rst|((~judge)&(~setpw)); //电路总复位信号为1或同时打开输入和重置密码状态，令电路输入复位
    end

    //分频
    if(clock_led==40)
    begin
        timeout<=1;
        clock_led<=0;
    end
    else
    begin
        timeout<=0;
        clock_led<=clock_led+1;
    end

    // for(i=1; i<9; i=i+1)
    // begin
    //     if(~key[i]) 
    //     begin 
    //         pressed <= pressed + 1;
    //         if(pressed == 1)
    //             q3 <= i;
    //         else if(pressed == 2)
    //             q2 <= i;
    //         else if(pressed == 3)
    //             q1 <= i;
    //         else if(pressed == 4)
    //             q0 <= i;
    //         //while(~key[i]);
    //     end
    //     // if(i==8) i <= 0;
    // end
    
    //按键输入模块
    if(input_rst)
    begin
        q3_flag=0; q2_flag=0; q1_flag=0; q0_flag=0;
        q3 <= 0; q2 <= 0; q1 <= 0; q0 <=0;
        beep = 1;
        beep_end = 0;
    end
    else if(input_start)
    begin
        key_all <= key[0] & key[1] & key[2] & key[3] & key[4] & key[5] & key[6] & key[7] & key[8] & key[9];
        //都真则真，没有按键被按下则key_all为1，有按键被按下则置0

        //第一位
        if(key_all==0&&q3_flag==0)//如果有开关被按下
        begin
            //beep = 0;
            led_test = 0;
            for(i=0;i<10;i=i+1)//检测是哪个开关被按下
                if(key[i]==0)
                begin
                    q3_flag = 1;
                    // if(~key[1] && ~key[2])
                    //     q3 <= 0;
                    // else if(~key[7] && ~key[8])
                    //     q3 <= 9;
                    // else
                        q3 <= i;
                end
            while(~key_all);
        end
        else if(key_all==1&&q2_flag==0)
            led_test = 1;
        //第二位
        if(key_all==0&&q3_flag==1&&q2_flag==0&&led_test==1)//如果有开关被按下
        begin
            //beep = 0;
            led_test = 0;
            for(i=0;i<10;i=i+1)//检测是哪个开关被按下
                if(key[i]==0)
                begin
                    q2 <= i;
                    q2_flag = 1;
                end
            while(~key_all);
        end
        else if(key_all==1&&q1_flag==0)
            led_test = 1;
        //第三位
        if(key_all==0&&q2_flag==1&&q1_flag==0&&led_test==1)//如果有开关被按下
        begin
            //beep = 0;
            led_test = 0;
            for(i=0;i<10;i=i+1)//检测是哪个开关被按下
                if(key[i]==0)
                begin
                    q1 <= i;
                    q1_flag = 1;
                end
            while(~key_all);
        end
        else if(key_all==1&&q0_flag==0)
            led_test = 1;
        //第四位
        if(key_all==0&&q1_flag==1&&q0_flag==0&&led_test==1)//如果有开关被按下
        begin
            //beep = 0;
            led_test = 0;
            for(i=0;i<10;i=i+1)//检测是哪个开关被按下
                if(key[i]==0)
                begin
                    q0 <= i;
                    q0_flag = 1;
                end
            while(~key_all);
        end
        else if(key_all==1)
            led_test = 1;
    end



    if(judge&&countdown!=8'b0000&&~status) //输入密码中
    begin
        //led_test = 0;
        if(clock_countdown!=40960)//不够大的话//1250 000 000
        begin
            clock_countdown<=clock_countdown+1;//就一直自增
        end
        case(clock_countdown)
            40960://60 000 000://1250000000:
                countdown<=8'b0000;
            32768://48 000 000://1000 000 000:
                countdown<=8'b0001;
            24576://36 000 000://750 000 000:
                countdown<=8'b0010;
            16384://24 000 000://500 000 000:
                countdown<=8'b0011;
            8192://12000000://250 000 000:
                countdown<=8'b0100;//倒计时4s
            0:
                countdown<=8'b0101;//倒计时5s
        endcase
    end
    else if(~judge) //未处于输入密码中，倒计时置5
    begin
        //led_test = 1;
        countdown<=8'b0101;
        clock_countdown<=0;
    end

    //重置密码模块
    if(setpw && status)//只有当锁打开时才能重置密码
    begin
        pw0<=q0;
        pw1<=q1;
        pw2<=q2;
        pw3<=q3;
    end

    if(judge)
    begin
        if(pw0==q0&&pw1==q1&&pw2==q2&&pw3==q3&&countdown!=8'b0000)
        begin
            status<=1;
            //beep = 0;
            // #2;// counter = counter + 1;
        end
        else if(countdown==8'b0000)
        begin
            status <= 0;
            if(counter!=4096&&beep_end==0)//不够大的话//1250 000 000
            begin
                counter<=counter+1;//就一直自增
                beep = 0;
            end
            else
            begin
                counter = 0;
                beep = 1;
                beep_end = 1;
            end
            // for(counter=0; counter<4000; counter=counter+1)
            //     beep = 0;
            // beep = 1;
           // #2 beep = 1;
        end
        else
        begin
            status<=0;
        end
    end


    if(status==0)//关锁状态
    begin
        led_r = 0;//红灯亮
        led_g = 1;//绿灯灭
    end
    else//开锁状态
    begin
        led_r = 1;//红灯灭
        led_g = 0;//绿灯亮
    end

end

always @(posedge timeout) begin
    if (pos==8'b11111110)//右一亮的话
    begin
        pos<=8'b11111101;//转到右二
        num <= 10;//消隐
        #1 num <= q1;//右二显示q1
    end
    else if(pos==8'b11111101)
    begin
        pos<=8'b11111011;
        num <= 10;//消隐
        #1 num<=q2;//右三显示
    end
    else if(pos==8'b11111011)
    begin
        pos<=8'b11110111;
        num <= 10;//消隐
        #1 num<=q3;//右四显示
    end
    else if(pos==8'b11110111)//右四亮的话
    begin
        pos<=8'b01111111;//转到左一
        num <= 10;//消隐
        #1 num<=countdown;//左一显示
    end
    else if(pos==8'b01111111)//左一亮的话
    begin
        pos<=8'b11111110;//转到右一
        num <= 10;//消隐
        #1 num<=q0;//右一显示
    end
end

//判断开锁模块
// always @(*)
// begin

// end

// always@(k1 or k2)
// 	begin :main
// 		led_g = k1;
// 		led_r = k2;
// end
endmodule
