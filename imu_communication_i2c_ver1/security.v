//2020/096/21 Quartus

module security(
clk,
reset_n,
//sw,
stop,//停止信号
led,//LED
rx,
tx,
PWM_1,
PWM_2,
PWM_3,
PWM_4,
i2c_scl,
i2c_sda,
);

input clk;
input reset_n;
output [9:0]led;

//input sw;
output stop;

//UART
input rx;
output tx;

//i2c
inout i2c_scl; //was inout before shoud be output
inout i2c_sda;
wire i2c_scl_oe;
wire i2c_sda_oe;

wire [27:0] Period;

//PWM1
output PWM_1;
reg[27:0] counter_1;
wire counter_clr_1,counter_dec_1;
wire [27:0] Duty_1;


//PWM2
output PWM_2;
reg[27:0] counter_2;
wire counter_clr_2,counter_dec_2;
wire [27:0] Duty_2;


//PWM3
output PWM_3;
reg[27:0] counter_3;
wire counter_clr_3,counter_dec_3;
wire [27:0] Duty_3;


//PWM4
output PWM_4;
reg[27:0] counter_4;
wire counter_clr_4,counter_dec_4;
wire [27:0] Duty_4;


always@(negedge reset_n or posedge clk)
begin
//PWM_1
if(reset_n==1'b0) begin 
counter_1<=0;

end else begin
if(counter_clr_1==1'b1)begin
counter_1<=0;

end else begin
counter_1<=counter_1+1;
end
end

//PWM_2
if(reset_n==1'b0) begin 
counter_2<=0;

end else begin
if(counter_clr_2==1'b1)begin
counter_2<=0;

end else begin
counter_2<=counter_2+1;
end
end

//PWM_3
if(reset_n==1'b0) begin 
counter_3<=0;

end else begin
if(counter_clr_3==1'b1)begin
counter_3<=0;

end else begin
counter_3<=counter_3+1;

end
end

//PWM_4
if(reset_n==1'b0) begin 
counter_4<=0;

end else begin
if(counter_clr_4==1'b1)begin
counter_4<=0;

end else begin
counter_4<=counter_4+1;

end
end
end

assign counter_clr_1=(counter_1>=Period)?1'b1:1'b0;
assign counter_dec_1=(counter_1<Duty_1)?1'b1:1'b0;
assign PWM_1=counter_dec_1;

assign counter_clr_2=(counter_2>=Period)?1'b1:1'b0;
assign counter_dec_2=(counter_2<Duty_2)?1'b1:1'b0;
assign PWM_2=counter_dec_2;

assign counter_clr_3=(counter_3>=Period)?1'b1:1'b0;
assign counter_dec_3=(counter_3<Duty_3)?1'b1:1'b0;
assign PWM_3=counter_dec_3;

assign counter_clr_4=(counter_4>=Period)?1'b1:1'b0;
assign counter_dec_4=(counter_4<Duty_4)?1'b1:1'b0;
assign PWM_4=counter_dec_4;


assign i2c_scl=(i2c_scl_oe==1'b1)?1'b0:1'bz;
assign i2c_sda=(i2c_sda_oe==1'b1)?1'b0:1'bz;

    nios_security u0 (
        .clk_clk       (clk),        
        .reset_reset_n (reset_n), 
        .stop_export(stop), 
		  .led_export (led),
		  //UART  
        .uart1_rxd     (rx), //RX(受信)    
        .uart1_txd     (tx),//TX(送信)
        //i2c
        .i2c_sda_in    (i2c_sda),    //    i2c.sda_in
        .i2c_scl_in    (i2c_scl),    //       .scl_in
        .i2c_sda_oe    (i2c_sda_oe),    //       .sda_oe
        .i2c_scl_oe    (i2c_scl_oe),    //       .scl_oe
		  //Motor
		  .duty_1_export (Duty_1), // duty_1.export
        .duty_2_export (Duty_2), // duty_2.export
        .duty_3_export (Duty_3), // duty_3.export
        .duty_4_export (Duty_4), // duty_4.export
		  .period_export  (Period) // period.export
    );
	 


endmodule 