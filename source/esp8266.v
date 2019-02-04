module esp8266(Clk,Rst_n,Sig,Data_send);
input Clk,Rst_n;
output Sig;
output [7:0]Data_send;

reg [7:0]data_send;

reg [7:0] memo[63:0];
//AT+CIPMUX=1
always@(posedge Clk)begin
	memo[0]<=8'h41; //   A
	memo[1]<=8'h54; //   T
	memo[2]<=8'h2b; //   +
	memo[3]<=8'h43; //	C
	memo[4]<=8'h49; //	I
	memo[5]<=8'h50; //	P
	memo[6]<=8'h4d; //	M
	memo[7]<=8'h55; //	U
	memo[8]<=8'h58; //	X
	memo[9]<=8'h3d; //	=
	memo[10]<=8'h31;//   1
	memo[11]<=8'h0d;//   回车
	memo[12]<=8'h0a;//	
	
	memo[13]<=8'h41;//	A
	memo[14]<=8'h54;//	T
	memo[15]<=8'h2b;//	+
	memo[16]<=8'h43;//	C
	memo[17]<=8'h49;//	I
	memo[18]<=8'h50;//	P
	memo[19]<=8'h53;//	S
	memo[20]<=8'h45;//	E
	memo[21]<=8'h52;//	R
	memo[22]<=8'h56;//	V
	memo[23]<=8'h45;//	E
	memo[24]<=8'h52;//	R
	memo[25]<=8'h3d;//	=
	memo[26]<=8'h31;//	1
	memo[27]<=8'h2c;//	,
	memo[28]<=8'h38;//	8
	memo[29]<=8'h30;//	0
	memo[30]<=8'h38;//	8
	memo[31]<=8'h30;//	0
	memo[32]<=8'h0d;//
	memo[33]<=8'h0a;//
//	
//	memo[]<=8'h;
end

reg flag;
reg [15:0]i;
always@(posedge Clk or negedge Rst_n)begin
		if(!Rst_n)begin
				data_send <=8'd0;
				flag <= 0;
				i <= 0;
			end
		else begin
				if(!flag)begin
					data_send <=memo[i];
					i <= i + 1;
					if(i==34)flag<=1;
					else flag<=0;
				end
			end
end

///////////////////////////////////
//发送命令 上升沿触发
///////////////////////////////////
reg sig;
reg [23:0]cnt;
always@(posedge Clk or negedge Rst_n)begin
		if(!Rst_n)begin
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
		
assign Sig=sig;	
assign Data_send[7:0]=data_send[7:0];


endmodule
