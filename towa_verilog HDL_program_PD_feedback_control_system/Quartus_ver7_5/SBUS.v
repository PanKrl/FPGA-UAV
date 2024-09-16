
//S.BUS通信回路
module SBUS(
	clk,
	rst,
	sw,
	rx,
	flag,
	flag2,
	led
	);
	
	input			clk;
	input			rst;
	input			sw;
	input			rx;
	output		flag;
	output		flag2;
	output		led;
	
	reg			flag_w;
	reg			flag_w2;
	reg			led_w;
	
	reg[2:0]		div;
	reg[7:0]		mode;//case文の変数
	reg[4:0]		byte_cnt;//受信するデータの数(22Byte: 11bit × 16)
	reg[3:0]		bit_cnt;//受信するデータのビット数(8bit)
	reg[7:0]		off_cnt;//modeの繰り返し回数
	
	assign flag = flag_w;
	assign flag2 = flag_w2;
	assign led = led_w;
	
	always@(posedge clk or posedge rst)
	begin
		if(rst == 1'b1)begin
			mode = 8'd0;
			flag_w = 1'b0;
			led_w = 1'b0;
		end
		else if(sw == 1'b1)begin
			
			case(mode)
			
			//データ受信機 RX
			
			8'd0://Ready
			begin
				flag_w = 1'b0;
				led_w = 1'b0;
				if(rx == 1'b0)begin
					off_cnt = 8'd1;
					mode = mode + 1;
				end
			end
			
			
			//START
			
			8'd1://Start Bit(1bit)
			begin
				flag_w = 1'b0;
				flag_w2 = 1'b0;
				led_w = 1'b0;
				off_cnt = 8'd8;
				mode = mode + 1;
			end
			
			8'd2://Read Address(0x0F:0000 1111)			//送られたアドレスが正しいかどうかを判定する
			begin
				flag_w = 1'b0;
				mode = mode + 1;
			end
			
			8'd3://Read Address(0x0F:0000 1111)
			begin
				flag_w = 1'b1;
				if(off_cnt == 1)begin
					off_cnt = 8'd2;
					mode = mode + 1;
				end
				else begin
					mode = mode - 1;
					off_cnt = off_cnt - 1;
				end
			end
			
			8'd4://Parity Bit(Even: ビット列中に含まれる1の個数が奇数ならパリティビットを1に、偶数なら0を出力する)
			begin
				flag_w = 1'b0;
				if(off_cnt == 1)begin
					off_cnt = 8'd4;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			8'd5://Stop Bit(2bit)
			begin
				if(off_cnt == 1)begin
					off_cnt = 8'd2;
					byte_cnt = 5'd22;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			
			//DATA READ
			
			8'd6://Start Bit(1bit)
			begin
				if(off_cnt == 1)begin
					off_cnt = 8'd8;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			8'd7://Data Read(8bit × 2)
			begin
				flag_w = 1'b0;
				mode = mode + 1;
			end
			
			8'd8://Data Read(8bit × 2)
			begin
				flag_w = 1'b1;
				if(off_cnt == 1)begin
					off_cnt = 8'd2;
					mode = mode + 1;
				end
				else begin
					mode = mode - 1;
					off_cnt = off_cnt - 1;
				end
			end
			
			8'd9://Parity Bit
			begin
				flag_w = 1'b0;
				if(off_cnt == 1)begin
					off_cnt = 8'd4;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			8'd10://Stop Bit(2bit)
			begin
				if(off_cnt == 1)begin
					off_cnt = 8'd2;
					if(byte_cnt == 1)begin
						byte_cnt = 5'd2;
						mode = mode +  1;
					end
					else begin
						mode = 8'd6;
						byte_cnt = byte_cnt - 1;
					end
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			
			//24, 25Bit
			
			8'd11://Start Bit(1bit)
			begin
				if(off_cnt == 1)begin
					off_cnt = 8'd8;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			8'd12://Data Read(8bit × 2)
			begin
				mode = mode + 1;
			end
			
			8'd13://Data Read(8bit × 2)
			begin
				if(off_cnt == 1)begin
					off_cnt = 8'd2;
					mode = mode + 1;
				end
				else begin
					mode = mode - 1;
					off_cnt = off_cnt - 1;
				end
			end
			
			8'd14://Parity Bit
			begin
				if(off_cnt == 1)begin
					off_cnt = 8'd4;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			8'd15://Stop Bit(2bit)
			begin
				if(off_cnt == 1)begin
					off_cnt = 8'd2;
					if(byte_cnt == 1)begin
						flag_w = 1'b1;//output
						mode = mode +  1;
					end
					else begin
						mode = 8'd11;
						byte_cnt = byte_cnt - 1;
					end
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			
			//Timer
			
			8'd16://Timer
			begin
				flag_w = 1'b0;
				flag_w2 = 1'b1;
				led_w = 1'b1;
				if(rx == 1'b0)begin
					mode = 8'd1;
					flag_w = 1'b1;//reset
					off_cnt = 8'd1;
				end
				else begin
					mode = mode;
				end
			end
			
			
			default://Error
			begin
				flag_w = 1'b0;
			end
			
			endcase
			
		end
		else begin
			flag_w = 1'b0;
		end
	end
	
endmodule
