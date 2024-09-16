
//データ読み込み用
module I2C_Data_read(
	clk,
	rst,
	flag,
	sda_in,
	imu_flag,
	x_gyro,
	y_gyro,
	z_gyro,
	x_acc,
	y_acc,
	z_acc,
	x_mag,
	y_mag,
	z_mag
	);
	
	//Data_read
	input				clk;
	input				rst;
	input				flag;
	input				sda_in;
	output			imu_flag;
	
	output[15:0]	x_gyro;
	output[15:0]	y_gyro;
	output[15:0]	z_gyro;
	output[15:0]	x_acc;
	output[15:0]	y_acc;
	output[15:0]	z_acc;
	output[15:0]	x_mag;
	output[15:0]	y_mag;
	output[15:0]	z_mag;
	
	//データ保存用
	reg[15:0]		xgyro_w;
	reg[15:0]		ygyro_w;
	reg[15:0]		zgyro_w;
	reg[15:0]		xacc_w;
	reg[15:0]		yacc_w;
	reg[15:0]		zacc_w;
	reg[15:0]		xmag_w;
	reg[15:0]		ymag_w;
	reg[15:0]		zmag_w;
	
	//データ出力用
	reg[15:0]		xgyro_out;
	reg[15:0]		ygyro_out;
	reg[15:0]		zgyro_out;
	reg[15:0]		xacc_out;
	reg[15:0]		yacc_out;
	reg[15:0]		zacc_out;
	reg[15:0]		xmag_out;
	reg[15:0]		ymag_out;
	reg[15:0]		zmag_out;
	
	reg[7:0]			mode;//case用
	reg[7:0]			bit_cnt;//データ格納場所用
	reg				imu_w;
	
	assign imu_flag = imu_w;
	
	always@(posedge flag or posedge rst)
	begin
		if(rst == 1'b1)begin
			mode = 8'd0;
			imu_w = 1'b0;
			
			xacc_out = 16'd0;
			yacc_out = 16'd0;
			zacc_out = 16'd0;
			
			xacc_w = 16'd0;
			yacc_w = 16'd0;
			zacc_w = 16'd0;
			
			xmag_w = 16'd0;
			ymag_w = 16'd0;
			zmag_w = 16'd0;
			
		end
		else begin
			
			case(mode)
			
			8'd0://Data reset
			begin
				bit_cnt = 8'd16;
				imu_w = 1'b0;
				mode = mode + 1;
			end
			
			8'd1://X_gyroを保存
			begin
				xgyro_w[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(bit_cnt == 8'd1)begin
					bit_cnt = 8'd16;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd2://Y_gyroを保存
			begin
				ygyro_w[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(bit_cnt == 8'd1)begin
					bit_cnt = 8'd16;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd3://Z_gyroを保存
			begin
				zgyro_w[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(bit_cnt == 8'd1)begin
					bit_cnt = 8'd14;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd4://X_accを保存
			begin
				xacc_w[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(bit_cnt == 8'd1)begin
					bit_cnt = 8'd14;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd5://Y_accを保存
			begin
				yacc_w[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(bit_cnt == 8'd1)begin
					bit_cnt = 8'd14;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd6://Z_accを保存
			begin
				zacc_w[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(bit_cnt == 8'd1)begin
					bit_cnt = 8'd16;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd7://X_magを保存
			begin
				xmag_w[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(bit_cnt == 8'd1)begin
					bit_cnt = 8'd16;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd8://Y_magを保存
			begin
				ymag_w[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(bit_cnt == 8'd1)begin
					bit_cnt = 8'd16;
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd9://Z_magを保存
			begin
				zmag_w[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(bit_cnt == 8'd1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					bit_cnt = bit_cnt - 1;
				end
			end
			
			8'd10://データ出力
			begin
				
				imu_w = 1'b1;
				xgyro_out = xgyro_w;
				ygyro_out = ygyro_w;
				zgyro_out = zgyro_w;
				
				xacc_out = xacc_w;
				yacc_out = yacc_w;
				zacc_out = zacc_w;
				
				xmag_out = xmag_w;
				ymag_out = ymag_w;
				zmag_out = zmag_w;
				
				mode = 8'd0;
			end
			
			
			endcase
			
		end
	end
	
	assign x_acc = xacc_out;
	assign y_acc = yacc_out;
	assign z_acc = zacc_out;
	
	assign x_gyro = xgyro_out;
	assign y_gyro = ygyro_out;
	assign z_gyro = zgyro_out;


endmodule
