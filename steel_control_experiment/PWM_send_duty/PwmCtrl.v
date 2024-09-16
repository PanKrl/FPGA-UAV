module PwmCtrl(
reset_n,
clk,
PWM_DUTY,
SW,
DIP,
LED
);

input clk,reset_n;
output PWM_DUTY;
//reg[27:0] counter0;
//wire counter0_clr,counter0_dec;
//wire [27:0] Decode0;
//wire [27:0] Period0;
input [1:0] SW;
input [3:0] DIP;
output [7:0] LED;

//always@(negedge reset_n or posedge clk)
//begin
//
//if(reset_n==1'b0) begin 
//counter0<=0;
//
//end else begin
//if(counter0_clr==1'b1)begin
//counter0<=0;
//
//end else begin
//counter0<=counter0+1;
//
//end
//end
//end
//
//assign counter0_clr=(counter0>=Period0)?1'b1:1'b0;
//assign counter0_dec=(counter0<Decode0)?1'b1:1'b0;
//assign PWM=counter0_dec;


    nios2e u0 (
        .clk_clk       (clk),
        .duty_export   (PWM_DUTY), 		  
//        .duty_export   (Decode0),   
//        .cycle_export  (Period0),  
        .reset_reset_n (reset_n),  
		  .sw0_export    (SW[0]),    
        .sw1_export    (SW[1]),   
        .dip0_export    (DIP[0]),
        .dip1_export    (DIP[1]),
        .dip2_export    (DIP[2]),
        .dip3_export    (DIP[3]),		  
		  .led0_export   (LED[0]),   
        .led1_export   (LED[1]),  
        .led2_export   (LED[2]),
	     .led3_export   (LED[3]),	
		  .led4_export   (LED[4]), 
		  .led5_export   (LED[5]),
		  .led6_export   (LED[6]),
	     .led7_export   (LED[7]),	
    );


endmodule