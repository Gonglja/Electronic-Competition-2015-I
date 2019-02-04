module angle_dale
	(	rx_int,rx_data,clk,rst,
		angle_g,angle_s,angle_b,
		angley_g,angley_s,angley_b,
		anglez_g,anglez_s,anglez_b
	);

input clk,rst,rx_int;
input [7:0] rx_data;

output wire[3:0] angle_g,angle_s,angle_b,angley_g,angley_s,angley_b,anglez_g,anglez_s,anglez_b;

reg[3:0] count;

reg [47:0]angle;
wire [15:0] angle_dat;//,angley_dat,anglez_dat;
reg [15:0] chang_x;//,chang_y,chang_z;
reg flag;

always@(posedge clk or negedge rst)
	begin
		if(!rst)
			flag<=1'b0;
		else
			begin
				if(rx_data==8'h53)
					flag<=1'b1;
				if(count>=6)
					flag<=1'b0;
			end
	end

always@(negedge rx_int or negedge rst)
	begin
		if(!rst)
			begin
				count<=0;
			end
		else
			begin
				if(flag)
					begin
						if(count>=6)
							count<=0;
						else 
							count<=count+1'b1;
					end
				else
					count<=0;
			end
	end
/***************************************************
*********************读取角度************************
****************************************************/
always@(negedge clk or negedge rst)
	begin
		if(!rst)
			begin
				angle<=0;
			end
		else
			begin
				case(count)
					4'd1:angle[47:40]<=rx_data;
					4'd2:angle[39:32]<=rx_data;
					4'd3:angle[31:24]<=rx_data;
					4'd4:angle[23:16]<=rx_data;
					4'd5:angle[15:8]<=rx_data;
					4'd6:angle[7:0]<=rx_data;
					default:angle<=angle;
				endcase
			end
	end
/***************************************************
**************求出真实的角度（x轴）********************
****************************************************/
always@(*)
	begin
		chang_x=(angle[39:32]<<8)|angle[47:40];
		if(chang_x>=32768)
			chang_x=16'hffff+1'b1-chang_x;
		else
			chang_x=chang_x; 
	end

///***************************************************
//**************求出真实的角度（y轴）********************
//****************************************************/
//	
//always@(*)
//	begin
//		chang_y=(angle[23:16]<<8)|angle[31:24];
//		if(chang_y>=32768)
//			chang_y=16'hffff+1'b1-chang_y;
//		else
//			chang_y=chang_y; 
//	end	
//	
///***************************************************
//**************求出真实的角度（z轴）********************
//****************************************************/
//always@(*)
//	begin
//		chang_z=(angle[7:0]<<8)|angle[15:8];
//		if(chang_z>=32768)
//			chang_z=16'hffff+1'b1-chang_z;
//		else
//			chang_z=chang_z; 
//	end	

assign angle_dat=((chang_x)*100)/32768*180/100;	
assign angle_g=angle_dat%10;
assign angle_s=angle_dat%100/10;
assign angle_b=angle_dat/100;

//assign angley_dat=((chang_y)*100)/32768*180/100;	
//assign angley_g=angley_dat%10;
//assign angley_s=angley_dat%100/10;
//assign angley_b=angley_dat/100;
//
//assign anglez_dat=((chang_z)*100)/32768*180/100;	
//assign anglez_g=anglez_dat%10;
//assign anglez_s=anglez_dat%100/10;
//assign anglez_b=anglez_dat/100;

endmodule
