module lcd1602( 	input clk,    //50M  20ns
						input rst_n,  
						output reg lcd_rs,//  1:write data  0:write commmand 
						output reg lcd_en,//  1:使能
						output reg lcd_rw,//  1:read data   0:write data
						output reg [7:0]lcd_data,//数据口
////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////传入要显示的字符////////////////////////////////
//第一行
						input [7:0]data0,input [7:0]data1,input [7:0]data2,
						input [7:0]data3,input [7:0]data4,input [7:0]data5,
						input [7:0]data6,input [7:0]data7,input [7:0]data8,
						input [7:0]data9,input [7:0]data10,input [7:0]data11,
						input [7:0]data12,input [7:0]data13,input [7:0]data14,input [7:0]data15,
//第二行
						input [7:0]data16,input [7:0]data17,input [7:0]data18,
						input [7:0]data19,input [7:0]data20,input [7:0]data21,
						input [7:0]data22,input [7:0]data23,input [7:0]data24,
						input [7:0]data25,input [7:0]data26,input [7:0]data27,
						input [7:0]data28,input [7:0]data29,input [7:0]data30,input [7:0]data31
);
//-------------------------------1602command-----------------------------------//
parameter setDisplay  = 8'h38,   //设置显示模式
			 openDisplay = 8'h3c,   //开显示
			 setClearScreen = 8'h01,//清屏
			 setCursor = 8'h06;		//显示光标

//产生
//计数 50 产生1us的时钟周期
reg [7:0]count_50;
reg clk_50;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		begin
			count_50 <= 8'd0;
			clk_50 <= 1'b0;
		end
		
	else if(count_50 == 8'd49)
		begin
			count_50 <= 8'd0;
			clk_50 <= 1'b1;
		end
		
	else 
		begin
			count_50 <= count_50 + 1'd1;
			clk_50 <= 1'b0;
		end 
end

//计数 1000 产生20us的时钟周期
reg [31:0]count_1000;
reg clk_1000;
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		begin
			count_1000 <= 32'd0;
			clk_1000 <= 1'b0;
		end
		
	else if(count_1000 == 32'd2499)
		begin
			count_1000 <= 32'd0;
			clk_1000 <= 1'd1;
		end
		
	else 
		begin
			count_1000 <= count_1000 + 1'd1;
			clk_1000 <= 1'b0;
		end 
end



//////////////write_com/////////////////
//rs=0  rw=0  p0=com e=1  e=0
//////////////write_data///////////////
//rs=1  rw=0  p0=dat e=1  e=0
reg [11:0]state1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
	   begin
			   state1 <= 1'b0;
				lcd_rs <= 1'b0;
            lcd_en <= 1'b0;
            lcd_data <= 1'b0; 
		end
	else if(clk_1000)
		begin
				case(state1)
								//液晶初始化
								//write_com(0x38)
								12'd0:begin
												lcd_rs	<= 1'b0;
												lcd_rw 	<= 1'b0;
												lcd_data <= 8'h38;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd1:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
										
								//write_com(0x0c)		
								12'd2:begin
												lcd_rs	<= 1'b0;
												lcd_rw 	<= 1'b0;
												lcd_data <= 8'h0c;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd3:begin
												lcd_rw <=  1'b0;
												state1 <= state1 + 1'b1;
										end
								
										
								//write_com(0x01)
								12'd4:begin
												lcd_rs	<= 1'b0;
												lcd_rw 	<= 1'b0;
												lcd_data <= 8'h01;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd5:begin
												lcd_rw <= 1'b0;
												state1 <= state1 + 1'b1;
										end 
						
										
								//write_com(0x06)	
								12'd6:begin
												lcd_rs	<= 1'b0;
												lcd_rw 	<= 1'b0;
												lcd_data <= 8'h06;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd7:begin
												lcd_rw <= 1'b0;
												state1 <= state1 + 1'b1;
										end 
							
										
										
								/////////////////////////////////////
								//第一行数据显示
								//write_com(0x80)
								12'd8:begin
												lcd_rs	<= 1'b0;
												lcd_rw 	<= 1'b0;
												lcd_data <= 8'h80;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd9:begin
												lcd_rw <= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								//write_data(xxxx)
								12'd10:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data0;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd11:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
							  
								12'd12:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data1;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd13:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
										
								12'd14:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data2;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd15:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd16:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data3;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd17:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								
								12'd18:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data4;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd19:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
										
								12'd20:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data5;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd21:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd22:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data6;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd23:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd24:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data7;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd25:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd26:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data8;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd27:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd28:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data9;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd29:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd30:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data10;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd31:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd32:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data11;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd33:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd34:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data12;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd35:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd36:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data13;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd37:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd38:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data14;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd39:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd40:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data15;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd41:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
										
								/////////////////////////////////////
								//第一行数据显示
								//write_com(0x80+0x40+0)
								12'd42:begin
												lcd_rs	<= 1'b0;
												lcd_rw 	<= 1'b0;
												lcd_data <= 8'hc0;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd43:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd44:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data16;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd45:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd46:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data17;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd47:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd48:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data18;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd49:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd50:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data19;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd51:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd52:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data20;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd53:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd54:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data21;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd55:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd56:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data22;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd57:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd58:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data23;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd59:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd60:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data24;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd61:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd62:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data25;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd63:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd64:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data26;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd65:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd66:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data27;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd67:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd68:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data28;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd69:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								12'd70:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data29;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd71:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								
								12'd72:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data30;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd73:begin
												lcd_en	<= 1'b0;
												state1 <= state1 + 1'b1;
										end 
								
								12'd74:begin
												lcd_rs	<= 1'b1;
												lcd_rw 	<= 1'b0;
												lcd_data <= data31;
												lcd_en	<= 1'b1;
												state1 <= state1 + 1'b1;
										end 
								12'd75:begin
												lcd_en	<= 1'b0;
												state1 <= 12'd8;
										end 	
								default: state1 <= 12'bxxxxxxxx;								
				endcase
		end
end	
endmodule

