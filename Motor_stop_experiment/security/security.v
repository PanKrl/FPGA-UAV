//2023/07/21 Yusei Ito

module security(
clk,
reset_n,
//sw,
stop,//停止信号
led,//LED
rx,
tx
);

input clk;
input reset_n;
//input sw;
output stop;
input rx;
output tx;
output [9:0]led;


    nios_security u0 (
        .clk_clk       (clk),        
        .reset_reset_n (reset_n), 
        .stop_export(stop),
		  .sw_export     (sw),     
        .uart1_rxd     (rx),     
        .uart1_txd     (tx),      
		  .led_export (led[9:0])
    ); 

endmodule 