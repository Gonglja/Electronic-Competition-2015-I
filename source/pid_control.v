module pid_control(Clk,Rst_n,CurrentAngle,CurrentGyro,ResultOut_l,ResultOut_r);
input Clk,Rst_n;
input signed[12:0]CurrentAngle,CurrentGyro;
output [15:0]ResultOut_l,ResultOut_r;

//reg [8:0]setAngle;
reg signed[12:0]Angle_1,Angle_2,Angle_3,Angle_4,Angle_5;
reg signed[13:0]Angle_Tmp;
reg signed[12:0]Gyro_1,Gyro_2;
reg signed[13:0]Gyro_Tmp;

parameter setAngle=90;
parameter P=10,
			 I=0,
			 D=0;
			 
//reg [3:0]cnt;
//reg Clk_12M;
//always@(posedge Clk or negedge Rst_n)begin
//	if(!Rst_n)cnt<=0;
//	else if(cnt==2)begin Clk_12M<=1;cnt<=cnt+1;end
//	else if(cnt==4)begin Clk_12M<=0;cnt<=0;end
//	else cnt<=cnt+1;
//end
//角度计算
always@(posedge Clk or negedge Rst_n)begin
	if(!Rst_n)begin
			Angle_1 <= 0;
			Angle_2 <= 0;
			Angle_3 <= 0;
			Angle_4 <= 0;
			Angle_5 <= 0;
		end
	else begin
			Angle_1 <= Angle_2;
			Angle_2 <= Angle_3;
			Angle_3 <= Angle_4;
			Angle_4 <= Angle_5;
			Angle_5 <= CurrentAngle - setAngle;
			Angle_Tmp <= (Angle_1+Angle_2+Angle_3+Angle_4+Angle_5)/5;
		end
end

//
always@(posedge Clk or negedge Rst_n)begin
	if(!Rst_n)begin
			Gyro_1 <= 0;
			Gyro_2 <= 0;
		end
	else begin
			Gyro_1 <= Gyro_2;
			Gyro_2 <= CurrentGyro;
			Gyro_Tmp <= Gyro_1 *7 +Gyro_2*3;
			//Gyro_Tmp <=Gyro_Tmp/10;
		end
end

//计算
reg signed[14:0]ResultOutTmp;
reg [15:0]ResultOutTmp_l,ResultOutTmp_r;

always@(posedge Clk)begin
	ResultOutTmp <= P*Angle_Tmp*10 + D*Gyro_Tmp;
	if(ResultOutTmp>0)
		ResultOutTmp_l<=ResultOutTmp;
	else
		ResultOutTmp_r<=~ResultOutTmp+1;
end

assign ResultOut_l=(ResultOutTmp_l>7500)?7500:ResultOutTmp_l;
assign ResultOut_r=(ResultOutTmp_r>7500)?7500:ResultOutTmp_r;
endmodule
