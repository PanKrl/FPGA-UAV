//2020/096/21 Quartus

module security(
clk,
reset_n,
//sw,
stop,//停止信号
led,//LED
rx,
tx,
PWM,
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

output PWM;
reg[27:0] counter;
wire counter_clr,counter_dec;
wire [27:0] Duty;

always@(negedge reset_n or posedge clk)
begin
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
assign PWM=counter_dec;


    nios_security u0 (
        .clk_clk       (clk),       //    clk.clk
        .duty_export   (Duty),   //   duty.export
        .led_export    (led),    //    led.export
        .period_export (Period), // period.export
        .reset_reset_n (reset_n), //  reset.reset_n
        .stop_export   (stop),   //   stop.export
        .uart_rxd      (rx),      //   uart.rxd
        .uart_txd      (tx),       //       .txd
		  .sw_export     (sw)
    );


	 

endmodule 