module top(
				clk_sys,rst_n,
				rx_mpu6050,rx_esp8266,tx_esp8266,
				lcd_rs,lcd_en,lcd_rw,lcd_data,
				pwm_l,pwm_r
);
//系统输入输出
input clk_sys,rst_n;

//1602输入输出
output lcd_en,lcd_rs,lcd_rw;
output [7:0]lcd_data;

//串口输入输出
input rx_mpu6050;
input rx_esp8266;
output tx_esp8266;
//pwm输出
output pwm_l,pwm_r;

//--算式:50_000_000/baud/16
parameter BPS_9600   = 16'd325,
			 BPS_115200 = 16'd27;
wire clk;		
wire [7:0]data;

//-----------------时钟信号的设定-----------------
clk_set U1(
					.clk_sys(clk_sys),
					.rst_n(rst_n),
					.baud(BPS_115200),
					.clk(clk)
);

//--------------------UART串口-------------------
//MPU6050陀螺仪
wire rx_int;		//接收数据中断信号,接收到数据期间始终为高电平
uart_rx U2(
					.clk(clk),
					.rst_n(rst_n),
					.rx_int(rx_int),
					.data_rd(rx_mpu6050),
					.dataout(data[7:0])
);
//uart_tx uart_tx(
//					.clk(clk),
//					.rst_n(rst_n),
//					.data_wr(tx),
//					.wrsig(sig),
//					.datain(data_send[7:0])
//					
//);

//ESP8266无线模块
reg [7:0]datasend_esp8266;
wire [7:0]datarece_esp8266;
wire Sig;
wire rx_int_esp8266;
//reg [7:0]qqq=8'h41;
//assign datasend_esp8266=qqq;

//esp8266 esp8266(
//					.Clk(clk),
//					.Rst_n(rst_n),
//					.Sig(Sig),
//					.Data_send(datasend_esp8266[7:0])
//);

reg sig;
reg [23:0]cnt;
always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
				sig <= 1'b0;
				cnt <= 15'd0;
			end
		else if(cnt == 24'd2500 -1)begin
				sig <= 1'b1;
				cnt <= cnt + 1'b1;
			end
		else if(cnt == 24'd5000 -1)begin
				sig <= 1'b0;
				cnt <= 24'd0;
			end
		else begin
				cnt <= cnt + 1'b1;
			end
end	

reg [7:0]state;
always@(posedge sig or negedge rst_n)begin
	if(!rst_n)begin
			state <= 0;
			//datasend_esp8266<=0;
		end
	else begin
			case(state)
			0:begin datasend_esp8266<=8'h41;state<=1;end
			1:begin datasend_esp8266<=8'h54;state<=2;end
			2:begin datasend_esp8266<=8'h2b;state<=3;end
			3:begin datasend_esp8266<=8'h43;state<=4;end
			4:begin datasend_esp8266<=8'h49;state<=5;end
			5:begin datasend_esp8266<=8'h50;state<=6;end
			6:begin datasend_esp8266<=8'h4d;state<=7;end
			7:begin datasend_esp8266<=8'h55;state<=8;end
			8:begin datasend_esp8266<=8'h58;state<=9;end
			9:begin datasend_esp8266<=8'h3d;state<=10;end
			10:begin datasend_esp8266<=8'h31;state<=11;end
			11:begin datasend_esp8266<=8'h0d;state<=12;end
			12:begin datasend_esp8266<=8'h0a;state<=13;end
			
			13:begin datasend_esp8266<=8'h41;state<=14;end
			14:begin datasend_esp8266<=8'h54;state<=15;end
			15:begin datasend_esp8266<=8'h2b;state<=16;end
			16:begin datasend_esp8266<=8'h43;state<=17;end
			17:begin datasend_esp8266<=8'h49;state<=18;end
			18:begin datasend_esp8266<=8'h50;state<=19;end
			19:begin datasend_esp8266<=8'h53;state<=20;end
			20:begin datasend_esp8266<=8'h45;state<=21;end
			21:begin datasend_esp8266<=8'h52;state<=22;end
			22:begin datasend_esp8266<=8'h56;state<=23;end
			23:begin datasend_esp8266<=8'h45;state<=24;end
			24:begin datasend_esp8266<=8'h52;state<=25;end
			25:begin datasend_esp8266<=8'h3d;state<=26;end
			26:begin datasend_esp8266<=8'h31;state<=27;end
			27:begin datasend_esp8266<=8'h2c;state<=28;end
			28:begin datasend_esp8266<=8'h38;state<=29;end
			29:begin datasend_esp8266<=8'h30;state<=30;end
			30:begin datasend_esp8266<=8'h38;state<=31;end
			31:begin datasend_esp8266<=8'h30;state<=32;end
			32:begin datasend_esp8266<=8'h0d;state<=33;end
			33:begin datasend_esp8266<=8'h0a;state<=34;end
			34:;
			endcase
		end                         
end	
uart_rx module_rx_esp8266(
					.clk(clk),
					.rst_n(rst_n),
					.rx_int(rx_int_esp8266),
					.data_rd(rx_esp8266),
					.dataout(datarece_esp8266[7:0])
);
uart_tx module_tx_esp8266(
					.clk(clk),
					.rst_n(rst_n),
					.data_wr(tx_esp8266),
					.wrsig(sig),
					.datain(datasend_esp8266[7:0])					
);


//-------------MPU6050数据处理-------------	
wire [3:0] angle_g,angle_s,angle_b,angley_g,angley_s,angley_b,anglez_g,anglez_s,anglez_b;
wire[3:0] wx_g,wx_s,wx_b,wy_g,wy_s,wy_b,wz_g,wz_s,wz_b;				

angle_dale U3(
					.rx_int(rx_int),
					.rx_data(data),
					.clk(clk_sys),
					.rst(rst_n),
					.angle_g(angle_g),
					.angle_s(angle_s),
					.angle_b(angle_b),
					.angley_g(angley_g),
					.angley_s(angley_s),
					.angley_b(angley_b),
					.anglez_g(anglez_g),
					.anglez_s(anglez_s),
					.anglez_b(anglez_b)
);

w_dale U4(
					.rx_int(rx_int),
					.rx_data(data),
					.clk(clk_sys),
					.rst(rst_n),
					.wx_g(wx_g),
					.wx_s(wx_s),
					.wx_b(wx_b),
					.wy_g(wy_g),
					.wy_s(wy_s),
					.wy_b(wy_b),
					.wz_g(wz_g),
					.wz_s(wz_s),
					.wz_b(wz_b) 
);	
//----------------------PID计算----------------------
wire signed[12:0]CurrentAngle;
wire signed[12:0]CurrentGyro;
wire [15:0]ResultOut_l,ResultOut_r;

assign CurrentAngle[12:0]={1'b0,angle_b[3:0],angle_s[3:0],angle_g[3:0]};
assign CurrentGyro[12:0]={1'b0,wx_b[3:0],wx_s[3:0],wx_g[3:0]};
pid_control	PID(
					.Clk(clk_sys),
					.Rst_n(rst_n),
					.CurrentAngle(CurrentAngle),
					.CurrentGyro(CurrentGyro),
					.ResultOut_l(ResultOut_l),
					.ResultOut_r(ResultOut_r)
);

//-------------------pwm输出------------------
parameter duty=7000, //占空比（与精度有关  比如说精度最大为1000  也就是当duty等于1000时占空比为100 等于500时占空比为50 ）
			 prec=10000,//精度
			 freq=500;//频率
			 
pwm	pwm_left(
					.clk(clk_sys),
					.rst_n(rst_n),
					.PWM_duty(ResultOut_l),
					.PWM_prec(prec),
					.PWM_freq(freq),
					.PWM_out(pwm_l)
);
pwm	pwm_right(
					.clk(clk_sys),
					.rst_n(rst_n),
					.PWM_duty(ResultOut_r),
					.PWM_prec(prec),
					.PWM_freq(freq),
					.PWM_out(pwm_r)
);

//--------------------LCD1602显示----------------------
lcd1602 U5( 	.clk(clk_sys),    //50M  20ns
					.rst_n(rst_n),  
					.lcd_rs(lcd_rs),//  1:write data  0:write commmand 
					.lcd_en(lcd_en),//  1:使能
					.lcd_rw(lcd_rw),//  1:read data   0:write data
					.lcd_data(lcd_data),//数据口

//传入要显示的字符
//第一行
					.data0("X"), 
					.data1(":"), 
					.data2(8'h30+datasend_esp8266[7:4]),
					.data3(8'h30+datasend_esp8266[3:0]), 
					.data4(8'h30+angle_g),
					.data5("Y"), 
					.data6(":"), 
					.data7(8'h30+datarece_esp8266[7:4]),
					.data8(8'h30+datarece_esp8266[3:0]), 
					.data9(8'h30+angley_g),
					.data10("Z"),
					.data11(":"),
					.data12(8'h30+anglez_b),
					.data13(8'h30+anglez_s),
					.data14(8'h30+anglez_g), 
					.data15(" "),
//第二行
					.data16("X"),
					.data17(":"),
					.data18(8'h30+wx_b),
					.data19(8'h30+wx_s),
					.data20(8'h30+wx_g),
					.data21("Y"),
					.data22(":"),
					.data23(8'h30+wy_b),
					.data24(8'h30+wy_s),
					.data25(8'h30+wy_g),
					.data26("Z"),
					.data27(":"),
					.data28(8'h30+wz_b),
					.data29(8'h30+wz_s),
					.data30(8'h30+wz_g),
					.data31(" ")
);


endmodule
