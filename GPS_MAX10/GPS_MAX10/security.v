//2020/06/21 Quartus

module security(
CLK,
RST_N,
gps,
stop,//停止信号
rx,
tx
);

input CLK;
input RST_N;
input gps;
output stop;
input rx;
output tx;

    nios_security u0 (
        .clk_clk       (CLK),		  
        .reset_reset_n (RST_N), 
		  .gps_export(gps),
        .stop_export   (stop) ,
	     .uart1_rxd(rx),    
        .uart1_txd(tx)
    );
	 

endmodule 