`timescale 1ns/1ps
module pid_tb();
reg Clk,Rst_n;
reg [8:0]CurrentAngle,CurrentGyro;
wire [16:0]ResultOut;

initial begin
		Clk 	= 0;
		Rst_n = 0;
		#100
		Rst_n = 1;
		CurrentAngle = 9'd100;
		CurrentGyro = 9'd30;
		#200
		CurrentAngle = 9'd80;
		CurrentGyro = -9'd30;
		#200
		CurrentAngle = 9'd110;
		CurrentGyro = 9'd20;

end
always #10 Clk=~Clk;
pid_control UU(	
						.Clk(Clk),
						.Rst_n(Rst_n),
						.CurrentAngle(CurrentAngle),
						.CurrentGyro(CurrentGyro),
						.ResultOut(ResultOut)
);

endmodule
