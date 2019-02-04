module pwm(clk,rst_n,PWM_duty,PWM_prec,PWM_freq,PWM_out);

input clk,rst_n;
input [15:0] PWM_duty;//占空比  
input [15:0] PWM_freq;//频率 
input [15:0] PWM_prec;//精度 //定义占空比精度，100即精度为1%，1000则精度为0.1%，用于占空比PWM_duty 形参传入，即占空比为 duty/PWM_prec
output PWM_out;//输出

//占空比为10% 精度为1000 PWM_duty为100
reg[31:0] counter_duty;
reg setPWM;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		counter_duty <= 32'd0;
		setPWM  <= 1'b0;
		end
	else if(counter_duty < 50_000_000/PWM_freq/PWM_prec*PWM_duty)begin
			counter_duty <= counter_duty + 1'b1;
			setPWM <= 1'b1;
		end
	else begin
			counter_duty <= counter_duty + 1'b1;
			setPWM <= 1'b0;
			//if(counter_duty == 50_000_000/PWM_freq/PWM_prec*PWM_prec - 1)
			if(counter_duty == 50_000_000/PWM_freq - 1)
				counter_duty <= 32'b0;
		end
end
assign PWM_out=setPWM;
endmodule
