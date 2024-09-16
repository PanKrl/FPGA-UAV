//Ctrl + F ⇒ "asdfg" + Find Next
//加速度、角速度のプログラムの最初の行へ

//i2c通信用
module i2c_master(
	clk,
	rst,
	sw,
	scl,
	sda,
	sda_in,
	flag,
	led
	);
	
	//i2c_master
	input			clk;
	input			rst;
	input			sw;//通信のON,OFF切り替えスイッチ
	
	output		scl;//I2Cのクロック信号線
	output		sda;//I2Cのデータ信号線
	input			sda_in;//データ信号を取り込む用
	
	output		flag;//データ保存用(flagがHIGHの時データを保存する)
	output		led;//i2c通信行えているか確認用
	
	reg			scl_reg;
	reg			sda_reg;
	reg			flag_w;
	reg			led_w;
	
	reg[6:0]		slave;//I2Cのスレーブアドレス
	reg[7:0]		register;//I2Cのレジスタアドレス
	
	//FX0S8700CQ
	reg[6:0]		slave_A = 7'b0011110;//0x1E	
	reg[7:0]		who_am_i_A = 8'b00001101;//0x0D
	reg[7:0]		ctrl_regA1 = 8'b00101010;//0x2A
	reg[7:0]		ctrl_regA2 = 8'b00101011;//0x2B
	reg[7:0]		mctrl_reg1 = 8'b01011011;//0x5B
	reg[7:0]		mctrl_reg2 = 8'b01011100;//0x5C
	reg[7:0]		xyz_data_reg = 8'b00001110;//0x0E
	
	//FXAS21002C
	reg[6:0]		slave_G = 7'b0100000;//0x20
	reg[7:0]		who_am_i_G = 8'b00001100;//0x0C
	reg[7:0]		ctrl_regG0 = 8'b00001101;//0x0D
	reg[7:0]		ctrl_regG1 = 8'b00010011;//0x13
	
	//MPL3115
	reg[6:0]		slave_M = 7'b1100000;//0x60
	reg[7:0]		who_am_i_M = 8'b00001100;//0x0C
	reg[7:0]		ctrl_regM1 = 8'b00100110;//0x26
	reg[7:0]		pt_data_cfg = 8'b00010011;//0x13
	
	reg[7:0]		data1 = 8'b00000000;//0x00
	reg[7:0]		data2 = 8'b00001110;//0x0E
	reg[7:0]		data3 = 8'b00011111;//0x1F
	reg[7:0]		data4 = 8'b00100000;//0x20
	reg[7:0]		data5 = 8'b00000001;//0x01
	reg[7:0]		data6 = 8'b00000010;//0x02
	reg[7:0]		data7 = 8'b00010101;//0x15
	
	reg[7:0]		acc_reg_sta = 8'b00000000;//0x00 STATUS
	reg[7:0]		acc_reg = 8'b00000001;//0x01 X_data
	reg[7:0]		gyro_reg = 8'd00000000;//0x00 STATUS
	
	reg[6:0]		slvadd;//シフトレジスタ
	reg[7:0]		regadd;//シフトレジスタ
	reg[7:0]		status;//STATUSの値が取れているか確認する用
	reg[7:0]		data;//書き込み用レジスタ
	
	reg[7:0]		bit_cnt;//送受信するデータのビット数
	reg[7:0]		data_cnt;//writeを繰り返す
	reg[7:0]		off_cnt;//1つのmodeを繰り返すための変数
	reg			sta_cnt;
	reg			data_flag;
	
	reg[8:0]		mode;//case文の変数

	reg[18:0]	timer;
	reg[18:0]	tim = 19'd524250;
	reg[21:0]	act_timer;
	reg[21:0]	act_time = 22'd3500000;//1/ODR + 60 ms //Standby -> Active //1101010110011111100000(22bit)
	reg[21:0]	acc_gyro_time = 22'd3625;
//	reg[17:0]	act_time = 18'd250000;//1/ODR + 5 ms //Standby -> Ready -> Active //10110111000110110000(20bit)
	
	//時間調整
	reg[3:0]		nodata_cnt;
	reg[18:0]	time_cnt;
	reg[21:0]	error_time = 22'd5000;
	
	assign flag = flag_w;
	assign led = led_w;
	
	always@(posedge clk or posedge rst)
	begin
		if(rst == 1'b1)begin
			mode = 8'd0;
			bit_cnt = 8'd0;
			scl_reg = 1'b1;
			sda_reg = 1'b1;
			led_w = 1'b0;
		end
		
		else begin
			case(mode)
			
			//Acceleration Sensor calib--------------------------------------------------------------------------------------------------------------
			//asdfg
			
			9'd0://i2c_off
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				led_w = 1'b0;
				if(sw == 1'b1)begin
					mode = mode + 1;
					off_cnt = 8'd40;
					data_cnt = 8'd0;
//-------------------------------------------------------
					slvadd = slave_A;
					regadd = who_am_i_A;
//-------------------------------------------------------
				end
				else begin
					mode = mode;
				end
			end
			
			9'd1://start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				led_w = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd2://start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd3://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd4://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd5://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd6://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					off_cnt = 8'd33;
//--------------------------------------------
					slvadd = slave_A;
//--------------------------------------------
				end
				else begin
					mode = mode - 4;
					off_cnt = 8'd5;
				end
			end
			
			9'd7://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd8://write
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd9://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd10://rst_write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd11://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd12://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd13://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd14://reg_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd15://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd16://register_address
			begin
				scl_reg = 1'b1;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd17://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd18://rst_register_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				regadd = regadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd19://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd20://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd21://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd22://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd39;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd23://R_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd24://R_start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd40;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd25://R_start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd26://rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd27://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd28://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd29://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd30://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
//--------------------------------------------
					slvadd = slave_A;
//--------------------------------------------
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd31://read_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd32://read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd33://read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd34://read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd35://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd36://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd37://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd38://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd39://data_read_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd40://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;				
				if(off_cnt == 1)begin
					mode = mode + 1;
					//off_cnt = 8'd35;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd41://data_read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd70;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd42://data_read_Register
			begin
				scl_reg = 1'b1;
				data[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					//off_cnt = 8'd36;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd43://data_read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd44://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd45://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin//0~7bitまでデータをとったか確認
					mode = mode + 1;
//					if(data == 8'b11000111)begin
//						mode = mode + 1;
//					end
//					else begin
//						mode = 8'd85;
//						data_cnt = 8'd4;
//					end
				end
				else begin
					mode = mode - 6;
				end
			end
			
			9'd46://rst_nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd47://nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd48://nack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd49://nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd50://rst_stop
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd51://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd98;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd52://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd39;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd53://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
//--------------------------------------------
					data_cnt = 8'd6;
					regadd = ctrl_regA1;//0x2A
					data = data1;//0x00
//--------------------------------------------
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			
			
			//Single Byte Write ---------------------------------------------------------------------------------------------------------------------
			
			9'd54://start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
//--------------------------------------------
					slvadd = slave_A;
//--------------------------------------------
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd55://start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd56://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd57://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd58://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd59://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode - 4;
					off_cnt = 8'd5;
				end
			end
			
			9'd60://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd61://write
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd62://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd63://rst_write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd64://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd65://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd66://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd67://reg_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd68://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd69://register_address
			begin
				scl_reg = 1'b1;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd70://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd71://rst_register_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				regadd = regadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd72://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd73://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd74://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd75://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd76://data_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd77://data_write
			begin
				scl_reg = 1'b0;
				sda_reg = (data & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd78://data_write
			begin
				scl_reg = 1'b1;
				sda_reg = (data & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd79://data_write
			begin
				scl_reg = 1'b0;
				sda_reg = (data & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd80://rst_data_write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				data = data << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd81://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd82://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd83://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd84://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd85://rst_stop
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd86://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd97;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd87://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd88://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
//------------------------------------------------------
				if(data_cnt == 6)begin
					mode = 9'd54;
					off_cnt = 8'd39;
					regadd = mctrl_reg1;//0x5B
					data = data3;//0x1F
					data_cnt = data_cnt - 1;
				end
				else if(data_cnt == 5)begin
					mode = 9'd54;
					off_cnt = 8'd39;
					regadd = mctrl_reg2;//0x5C
					data = data4;//0x20
					data_cnt = data_cnt - 1;
				end
				else if(data_cnt == 4)begin
					mode = 9'd54;
					off_cnt = 8'd39;
					regadd = xyz_data_reg;//0x0E
					data = data5;//0x01
					data_cnt = data_cnt - 1;
				end
				else if(data_cnt == 3)begin
					mode = 9'd54;
					off_cnt = 8'd39;
					regadd = ctrl_regA2;//0x2B
					data = data6;//0x02
					data_cnt = data_cnt - 1;
				end
				else if(data_cnt == 2)begin
					mode = 9'd54;
					off_cnt = 8'd39;
					regadd = ctrl_regA1;//0x2A
					data = data7;//0x15
					data_cnt = data_cnt - 1;
				end
					else if(data_cnt == 1)begin
					act_timer = 21'd3625;
					mode = mode + 1;
				end
//------------------------------------------------------
			end
			
			9'd89://avtive time
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(act_timer == 1)begin
					mode = mode + 1;//8'd0;
				end
				else begin
					mode = mode;
					act_timer = act_timer - 1;
				end
			end
			
			//Gyro Sensor calib----------------------------------------------------------------------------------------------------------------------
			//asdfg
			
			9'd90://i2c_off
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				led_w = 1'b0;
				if(sw == 1'b1)begin
					mode = mode + 1;
					off_cnt = 8'd40;
					data_cnt = 8'd0;
					slvadd = slave_G;
					regadd = who_am_i_G;
				end
				else begin
					mode = mode;
				end
			end
			
			9'd91://start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd92://start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd93://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd94://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd95://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd96://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					slvadd = slave_G;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode - 4;
					off_cnt = 8'd5;
				end
			end
			
			9'd97://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd98://write
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd99://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd100://rst_write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd101://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd102://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd103://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd104://reg_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd105://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd106://register_address
			begin
				scl_reg = 1'b1;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd107://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd108://rst_register_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				regadd = regadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd109://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd110://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd111://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd112://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd39;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd113://R_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd114://R_start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd40;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd115://R_start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd116://rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd117://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd118://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd119://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd120://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					slvadd = slave_G;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd121://read_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd122://read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd123://read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd124://read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd125://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd126://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd127://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd128://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd129://data_read_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd130://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;				
				if(off_cnt == 1)begin
					mode = mode + 1;
					//off_cnt = 8'd35;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd131://data_read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd70;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd132://data_read_Register
			begin
				scl_reg = 1'b1;
				data[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					//off_cnt = 8'd36;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd133://data_read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd134://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd135://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin//0~7bitまでデータをとったか確認
					mode = mode + 1;
//					if(data == 8'b11000111)begin
//						mode = mode + 1;
//					end
//					else begin
//						mode = 8'd85;
//						data_cnt = 8'd4;
//					end
				end
				else begin
					mode = mode - 6;
				end
			end
			
			9'd136://rst_nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd137://nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd138://nack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd139://nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd140://rst_stop
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd141://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd98;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd142://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd39;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd143://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					data_cnt = 8'd3;
					regadd = ctrl_regG1;
					data = data1;//0x00
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			
			
			//Single Byte Write ---------------------------------------------------------------------------------------------------------------------
			
			9'd144://start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
					slvadd = slave_G;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd145://start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd146://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd147://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd148://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd149://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode - 4;
					off_cnt = 8'd5;
				end
			end
			
			9'd150://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd151://write
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd152://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd153://rst_write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd154://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd155://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd156://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd157://reg_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd158://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd159://register_address
			begin
				scl_reg = 1'b1;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd160://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd161://rst_register_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				regadd = regadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd162://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd163://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd164://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd165://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd166://data_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd167://data_write
			begin
				scl_reg = 1'b0;
				sda_reg = (data & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd168://data_write
			begin
				scl_reg = 1'b1;
				sda_reg = (data & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd169://data_write
			begin
				scl_reg = 1'b0;
				sda_reg = (data & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd170://rst_data_write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				data = data << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd171://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd172://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd173://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd174://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd175://rst_stop
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd176://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd97;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd177://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd178://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(data_cnt == 3)begin
					mode = 9'd144;
					off_cnt = 8'd39;
					regadd = ctrl_regG0;
					data = data1;//0x00
					data_cnt = data_cnt - 1;
				end
				else if(data_cnt == 2)begin
					mode = 9'd144;
					off_cnt = 8'd39;
					regadd = ctrl_regG1;
					data = data2;//0x0E
					data_cnt = data_cnt - 1;
				end
					else if(data_cnt == 1)begin
					act_timer = act_time;
					mode = mode + 1;
				end
			end
			
			9'd179://avtive time
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(act_timer == 1)begin
					mode = mode + 1;//9'd0;
				end
				else begin
					mode = mode;
					act_timer = act_timer - 1;
				end
			end
			
			
			//Gyro START -----------------------------------------------------------------------------------------------------------------------------
			//asdfg
			
			9'd180://i2c_off
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				led_w = 1'b0;
				mode = mode + 1;
				off_cnt = 8'd40;
				sta_cnt = 1'b0;
				time_cnt = tim;
				nodata_cnt = 4'd0;
				slvadd = slave_G;
				regadd = gyro_reg;
			end
			
			9'd181://start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				flag_w = 1'b0;
				data_flag = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd182://start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd183://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd184://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd185://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd186://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					slvadd = slave_G;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode - 4;
					off_cnt = 8'd5;
				end
			end
			
			9'd187://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd188://write
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd189://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd190://rst_write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd191://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd192://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd193://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd194://reg_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd195://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd196://register_address
			begin
				scl_reg = 1'b1;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd197://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd198://rst_register_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				regadd = regadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					regadd = gyro_reg;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd199://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd200://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd201://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd202://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd39;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd203://R_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd204://R_start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd40;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd205://R_start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd206://rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd207://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd208://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd209://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd210://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					slvadd = slave_G;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd211://read_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd212://read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd213://read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd214://read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd215://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd216://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(sta_cnt == 1'b1)begin
					flag_w = 1'b1;//Data_read case: 8'd0:begin
				end
				else begin
					flag_w = 1'b0;
				end
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd217://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				flag_w = 1'b0;//Data_read case: 8'd0:begin
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd218://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
					data_cnt = 8'd7;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd219://data_read_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd220://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;				
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd221://data_read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd70;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd222://data_read_Register
			begin
				scl_reg = 1'b1;
				if(data_cnt == 8'd7)begin
					status[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				end
				
				else if(data_cnt == 8'd6 || data_cnt == 8'd5)begin//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
					flag_w = 1'b1;
				end
				
				else if(data_cnt == 8'd4 || data_cnt == 8'd3)begin//yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy
					flag_w = 1'b1;
				end
				
				else if(data_cnt == 8'd2 || data_cnt == 8'd1)begin//zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz
					flag_w = 1'b1;
				end

				
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd223://data_read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					flag_w = 1'b0;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd224://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd225://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin//0~7bitまでデータをとったか確認
					if(status != 0 && sta_cnt == 1)begin//STATUSデータを取得して、もう1周したか確認
						if(data_cnt == 1)begin//7つのデータをとったか確認
							mode = mode + 6;
							sta_cnt = 1'b0;
							data_flag = 1'b1;
							nodata_cnt = 4'd0;
							
						end
						else begin
							mode = mode + 1;
						end
					end
					else if(status != 0 && sta_cnt == 0)begin//STATUSデータを取得したらもう1回取得
						mode = mode + 6;
						sta_cnt = 1'b1;
						nodata_cnt = 4'd0;
					end
					else begin
						mode = mode + 6;
						nodata_cnt = nodata_cnt + 1;
					end
				end
				else begin
					mode = mode - 6;
				end
			end
			
			9'd226://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd227://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd228://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd229://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd230://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				data_cnt = data_cnt - 1;
				off_cnt = 8'd5;
				if(data_cnt != 0)begin
					mode = mode - 11;
					bit_cnt = 8'd8;
				end
			end
			
			9'd231://rst_nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd232://nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd233://nack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd234://nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd235://rst_stop
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd236://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd97;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd237://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd238://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(data_flag == 1'b1)begin
					mode = mode + 3;
					timer = acc_gyro_time;
				end
				else if(nodata_cnt == 4)begin
					mode = mode + 2;
					time_cnt = time_cnt - 750;
					timer = time_cnt;
				end
				else begin
					mode = mode + 1;
					off_cnt = 8'd39;
				end
			end
			
			9'd239://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = 9'd181;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd240://time
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(timer == 1)begin
					mode = mode - 1;
					off_cnt = 8'd39;
				end
				else begin
					mode = mode;
					timer = timer - 1;
				end
			end
			
			9'd241://time
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(timer == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					timer = timer - 1;
				end
			end
			
			
			
					
			
			//Accleration START ----------------------------------------------------------------------------------------------------------------------
			//asdfg
			
			9'd242://i2c_off
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				led_w = 1'b0;
				mode = mode + 1;
				off_cnt = 8'd40;
				sta_cnt = 1'b0;
				time_cnt = tim;
				nodata_cnt = 4'd0;
				slvadd = slave_A;
				regadd = acc_reg_sta;
				data_cnt = 8'd13;
			end
			
			9'd243://start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				flag_w = 1'b0;
				data_flag = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd244://start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd245://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd246://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd247://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd248://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					slvadd = slave_A;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode - 4;
					off_cnt = 8'd5;
				end
			end
			
			9'd249://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd250://write
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd251://write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd252://rst_write
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd253://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd254://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd255://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd256://reg_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd257://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd258://register_address
			begin
				scl_reg = 1'b1;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd259://register_address
			begin
				scl_reg = 1'b0;
				sda_reg = (regadd & 8'b10000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd260://rst_register_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				regadd = regadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd261://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd262://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd263://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd264://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd39;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd265://R_start
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd266://R_start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd40;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd267://R_start
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd27;
					bit_cnt = 8'd7;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd268://rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd269://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd270://slave_address
			begin
				scl_reg = 1'b1;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd271://slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = (slvadd & 7'b1000000)? 1'b1 : 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd272://rst_slave_address
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				slvadd = slvadd << 1;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin
					mode = mode + 1;
					slvadd = slave_A;
				end
				else begin
					mode = mode - 4;
				end
			end
			
			9'd273://read_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd274://read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd275://read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd276://read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd277://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd278://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd279://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd280://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd6;
					bit_cnt = 8'd8;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd281://data_read_rst
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd282://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;				
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd283://data_read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd70;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd284://data_read_Register
			begin
				scl_reg = 1'b1;
				if(data_cnt == 8'd13)begin
					status[bit_cnt - 1] = (sda_in == 1'b1)? 1'b1 : 1'b0;
				end
				
				else if(data_cnt == 8'd12 || (data_cnt == 8'd11 && bit_cnt > 8'd2))begin//acc_xxxxxxxxxxxxxxxxxxx
					flag_w = 1'b1;
				end
				
				else if(data_cnt == 8'd10 || (data_cnt == 8'd9 && bit_cnt > 8'd2))begin//acc_yyyyyyyyyyyyyyyyyyyy
					flag_w = 1'b1;
				end
				
				else if(data_cnt == 8'd8 || (data_cnt == 8'd7 && bit_cnt > 8'd2))begin//acc_zzzzzzzzzzzzzzzzzzzzz
					flag_w = 1'b1;
				end
				
				else if(data_cnt == 8'd6 || data_cnt == 8'd5)begin//mag_xxxxxxxxxxxxxxxxxxxxx
					flag_w = 1'b1;
				end
				
				else if(data_cnt == 8'd4 || data_cnt == 8'd3)begin//mag_yyyyyyyyyyyyyyyyyyyyy
					flag_w = 1'b1;
				end
				
				else if(data_cnt == 8'd2 || data_cnt == 8'd1)begin//mag_zzzzzzzzzzzzzzzzzzzzz
					flag_w = 1'b1;
				end

				
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd285://data_read
			begin
				scl_reg = 1'b1;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
					flag_w = 1'b0;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd286://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'bz;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd287://data_read
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				bit_cnt = bit_cnt - 1;
				off_cnt = 8'd5;
				if(bit_cnt == 0)begin//0~7bitまでデータをとったか確認
					if(status != 0 && sta_cnt == 1)begin//STATUSデータを取得して、もう1周したか確認
						if(data_cnt == 1)begin//7つのデータをとったか確認
							mode = mode + 6;
							sta_cnt = 1'b0;
							data_flag = 1'b1;
							nodata_cnt = 4'd0;
							
						end
						else begin
							mode = mode + 1;
						end
					end
					else if(status != 0 && sta_cnt == 0)begin//STATUSデータを取得したらもう1回取得
						mode = mode + 6;
						sta_cnt = 1'b1;
						nodata_cnt = 4'd0;
						data_cnt = data_cnt - 1;
						regadd = acc_reg;
					end
					else begin
						mode = mode + 6;
						nodata_cnt = nodata_cnt + 1;
					end
				end
				else begin
					mode = mode - 6;
				end
			end
			
			9'd288://rst_ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd289://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd290://ack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd291://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd292://ack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				data_cnt = data_cnt - 1;
				off_cnt = 8'd5;
				if(data_cnt != 0)begin
					mode = mode - 11;
					bit_cnt = 8'd8;
				end
			end
			
			9'd293://rst_nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd294://nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(data_flag == 1'b1)begin
					flag_w = 1'b1;////Data_read case: 8'd10:begin
				end
				else begin
					flag_w = 1'b0;
				end
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd72;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd295://nack
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd21;
					flag_w = 1'b0;////Data_read case: 8'd10:begin
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd296://nack
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd33;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd297://rst_stop
			begin
				scl_reg = 1'b0;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd50;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd298://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = mode + 1;
					off_cnt = 8'd97;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd299://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(off_cnt == 1)begin
					mode = mode + 1;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd300://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(data_flag == 1'b1)begin
					mode = mode + 3;
					timer = time_cnt;
				end
				else if(nodata_cnt == 4)begin
					mode = mode + 2;
					time_cnt = time_cnt - 750;
					timer = time_cnt;
				end
				else begin
					mode = mode + 1;
					off_cnt = 8'd39;
				end
			end
			
			9'd301://stop
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b0;
				if(off_cnt == 1)begin
					mode = 9'd243;
				end
				else begin
					mode = mode;
					off_cnt = off_cnt - 1;
				end
			end
			
			9'd302://time
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				led_w = 1'b1;
				if(timer == 1)begin
					mode = mode - 1;
					off_cnt = 8'd39;
				end
				else begin
					mode = mode;
					timer = timer - 1;
				end
			end
			
			9'd303://time
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				led_w = 1'b1;
				if(timer == 1)begin
					mode = 9'd180;
				end
				else begin
					mode = mode;
					timer = timer - 1;
				end
			end
			
			9'd511://error
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				if(timer == 1)begin
					mode = 9'd0;
				end
				else begin
					mode = mode;
					timer = timer - 1;
				end
			end
			
			
			default://error
			begin
				scl_reg = 1'b1;
				sda_reg = 1'b1;
				mode = 9'd511;
				timer = error_time;
			end
			
			endcase
			
		end
	end
	
	assign scl = scl_reg;
	assign sda = sda_reg;
	
	
endmodule
