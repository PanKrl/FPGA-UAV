
module Master(
	clk,
	rst,
	//IMU
	sw_i2c,
	led_i2c,
	scl,
	sda,
	sda_in,
	//SBUS
	sw_sbus,
	led_sbus,
	rx,
	//motor
	pwm
	);
	
	input					clk;//FPGAのクロック(50 MHz)
	input					rst;//リセット信号
	
	//IMUセンサ(I2C)
	input					sw_i2c;//I2C通信開始スイッチ
	output				led_i2c;//I2C通信が行えているか確認用
	output				scl;//クロック信号線
	inout					sda;//データ信号線
	input					sda_in;//データ読み取り用
	
	//プロポ(SBUS)
	input					sw_sbus;//SBUS通信開始スイッチ
	output				led_sbus;//SBUS通信行えているか確認用
	input					rx;//データ信号線
	
	//モータ
	output				pwm;//モータ出力用
	
	//クロック周期変更用
	wire					clk_w;//50 MHz
	wire					clk_bps;//200 kHz
	
	//IMUセンサ用
	wire					flag_w;//データ保存用クロック
	wire					imu_flag;
	wire[15:0]			x_gyro;//角速度データ
	wire[15:0]			y_gyro;
	wire[15:0]			z_gyro;
	wire[15:0]			x_acc;//加速度データ
	wire[15:0]			y_acc;
	wire[15:0]			z_acc;
	wire[15:0]			x_mag;//磁気データ
	wire[15:0]			y_mag;
	wire[15:0]			z_mag;
	
	//プロポ用
	wire[10:0]			ch2;//スロットル
	wire[10:0]			ch4;//モータキャリブ用
	wire[10:0]			ch5;//強制停止
	wire					flag_w1;//データ保存用信号
	wire					flag_w2;//データ保存用信号
	wire					rx_reg;//信号反転用
	
	assign rx_reg =~ rx;
	
	//モータ
	wire					pwm1;
	wire					pwm2;
	wire					pwm3;
	wire					pwm4;
	assign pwm = pwm1;
	
	wire [11:0] F_Throttle;  // ufix12
	wire signed [15:0] Data_Type_Conversion_out1;  // int16
	wire [31:0] PID_Controller_Roll_out1;  // ufix32
	wire [31:0] F_P;  // ufix32
	wire Motor_Controller_out1;  // ufix1	
	
	
	//I2C通信用モジュール
	i2c_master u1(clk_w, rst, sw_i2c, scl, sda, sda_in, flag_w, led_i2c);
	//I2Cのデータ保存用モジュール
	I2C_Data_read u2(clk_w, rst, flag_w, sda_in, imu_flag, x_gyro, y_gyro, z_gyro, x_acc, y_acc, z_acc, x_mag, y_mag, z_mag);
	
	//SBUS通信用モジュール
	SBUS u3(clk_bps, rst, sw_sbus, rx_reg, flag_w1, flag_w2, led_sbus);
	//SBUSのデータ保存モジュール
	SBUS_Data_read u4(clk_bps, rst, rx_reg, flag_w1, flag_w2, ch2, ch4, ch5);
	
	//1軸のモータ制御モジュール(HDL Coder)
	PID_Attitude_ver7_5 u5(clk_w, rst, ch2, x_gyro, imu_flag, ch4, ch5, pwm1);
	
	
	
	//clk_ALTPLL
	 mypll mypll_inst(
	 .areset(1'b0),
	 .inclk0(clk),
	 .c0(clk_bps),
	 .c1(clk_w),
	 .locked()
	 );
	 
	 
endmodule
