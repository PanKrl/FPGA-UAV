
//データ保存用
module SBUS_Data_read(
	clk,
	rst,
	rx_in,
	flag,
	flag2,
	data2,
	data4,
	data5
	);
	
	input				clk;
	input				rst;
	input				rx_in;
	input				flag;
	input				flag2;
	output[10:0]	data2;//モータの出力
	output[10:0]	data4;//モータのキャリブレーション用
	output[10:0]	data5;//強制停止
	
	reg[7:0]			mode;
	reg[7:0]			bit_cnt;
	
	reg[10:0]		ch_w[0:15];
	reg[10:0]		ch_out[0:15];
	
	reg[10:0]		data_rst = 11'd0;
	
	always@(posedge flag or posedge rst)
	begin
		if(rst == 1'b1)begin
			ch_out[0] = data_rst;
			ch_out[1] = data_rst;
			ch_out[2] = data_rst;
			ch_out[3] = data_rst;
			ch_out[4] = data_rst;
			ch_out[5] = data_rst;
			ch_out[6] = data_rst;
			ch_out[7] = data_rst;
			ch_out[8] = data_rst;
			ch_out[9] = data_rst;
			ch_out[10] = data_rst;
			ch_out[11] = data_rst;
			ch_out[12] = data_rst;
			ch_out[13] = data_rst;
			ch_out[14] = data_rst;
			ch_out[15] = data_rst;
			mode = 8'd0;
		end
		else begin
			
			case(mode)
			
			8'd0://Data reset
			begin
				bit_cnt = 8'd8;
//				ch_out[0] = data_rst;
//				ch_out[1] = data_rst;
//				ch_out[2] = data_rst;
//				ch_out[3] = data_rst;
//				ch_out[4] = data_rst;
//				ch_out[5] = data_rst;
//				ch_out[6] = data_rst;
//				ch_out[7] = data_rst;
//				ch_out[8] = data_rst;
//				ch_out[9] = data_rst;
//				ch_out[10] = data_rst;
//				ch_out[11] = data_rst;
//				ch_out[12] = data_rst;
//				ch_out[13] = data_rst;
//				ch_out[14] = data_rst;
//				ch_out[15] = data_rst;
				if(flag2 == 1'b1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
				end
			end
			
			8'd1://Address
			begin
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd2://ch1
			begin
				ch_w[0][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd3://ch2
			begin
				ch_w[1][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd4://ch3
			begin
				ch_w[2][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd5://ch4
			begin
				ch_w[3][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd6://ch5
			begin
				ch_w[4][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd7://ch6
			begin
				ch_w[5][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd8://ch7
			begin
				ch_w[6][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd9://ch8
			begin
				ch_w[7][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd10://ch9
			begin
				ch_w[8][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd11://ch10
			begin
				ch_w[9][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd12://ch11
			begin
				ch_w[10][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd13://ch12
			begin
				ch_w[11][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd14://ch13
			begin
				ch_w[12][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd15://ch14
			begin
				ch_w[13][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd16://ch15
			begin
				ch_w[14][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					bit_cnt = 8'd11;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd17://ch16
			begin
				ch_w[15][11 - bit_cnt] = rx_in;
				if(bit_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd18://データ出力
			begin
				ch_out[0] = ch_w[0];
				ch_out[1] = ch_w[1];
				ch_out[2] = ch_w[2];
				ch_out[3] = ch_w[3];
				ch_out[4] = ch_w[4];
				ch_out[5] = ch_w[5];
				ch_out[6] = ch_w[6];
				ch_out[7] = ch_w[7];
				ch_out[8] = ch_w[8];
				ch_out[9] = ch_w[9];
				ch_out[10] = ch_w[10];
				ch_out[11] = ch_w[11];
				ch_out[12] = ch_w[12];
				ch_out[13] = ch_w[13];
				ch_out[14] = ch_w[14];
				ch_out[15] = ch_w[15];
				mode = 8'd0;
			end
			
			endcase
			
		end
	end
	
	assign data2 = ch_out[2];
	assign data4 = ch_out[4];
	assign data5 = ch_out[5];


endmodule
