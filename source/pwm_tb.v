`timescale 1ns/1ps
module pwm_tb;

reg clk,rst_n;
wire pwm;

top U2(
			.clk(clk),
			.rst_n(rst_n),
			.pwm(pwm)
);
initial begin
		clk = 0;
		rst_n = 0;
		#200
		rst_n =1;
end

always #10 clk = ~clk;
endmodule
