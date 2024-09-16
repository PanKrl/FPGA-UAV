//2020/096/21 Quartus

module security(
clk,
reset_n,
//sw,
stop,//停止信号
led,//LED
rx,
tx,
PWM_input,
PWM_output,
sw
);

input clk;
input reset_n;
input sw;
output [9:0]led;
//input sw;
output stop;
input rx;
output tx;
wire [27:0] Period;

input PWM_input;
output PWM_output;
reg[27:0] counter;
wire counter_clr,counter_dec;
wire [27:0] Duty;
wire pwm_normal;

always@(negedge reset_n or posedge clk)begin



//PWM
if(reset_n==1'b0) begin 
counter<=0;

end else begin
if(counter_clr==1'b1)begin
counter<=0;

end else begin
counter<=counter+1;

end
end
end

//SBUS信号を反転
assign rx_data=~rx;

assign counter_clr=(counter>=Period)?1'b1:1'b0;
assign counter_dec=(counter<Duty)?1'b1:1'b0;

assign PWM_output=(stop==1'b0)?counter_dec:pwm_normal;

//if(stop==1'b1)begin
//assign PWM_output=pwm_normal;
//
//end else if(stop==1'b0) begin
//assign PWM_output=counter_dec;
//
//end


    nios_security u0 (
        .clk_clk       (clk),       //    clk.clk
        .pwm_in_export   (PWM_input), 
		  .pwm_out_export   (pwm_normal), 
		  .duty_export   (Duty),   
        .led0_export    (led[0]),
		  .led1_export    (led[1]),
		  .led2_export    (led[2]),
		  .led3_export    (led[3]),
		  .led4_export    (led[4]),
		  .led5_export    (led[5]),
		  .led6_export    (led[6]),
		  .led7_export    (led[7]),
		  .led8_export    (led[8]),
		  .led9_export    (led[9]),
        .period_export (Period), // period.export
        .reset_reset_n (reset_n), //  reset.reset_n
        .stop_export   (stop),   //   stop.export
        .uart_rxd      (rx),      //   uart.rxd
        .uart_txd      (tx),       //       .txd
		  .sw_export     (sw)
    );


	 

endmodule 