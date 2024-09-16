module PwmCtrl(
reset_n,
clk,
PWM,
SW1,
SW2,
SW3
);

input clk,reset_n;
output PWM;
reg[27:0] counter0;
wire counter0_clr,counter0_dec;
wire [27:0] Decode0;
wire [27:0] Period0;
input SW1,SW2,SW3;

always@(negedge reset_n or posedge clk)
begin

if(reset_n==1'b0) begin 
counter0<=0;

end else begin
if(counter0_clr==1'b1)begin
counter0<=0;

end else begin
counter0<=counter0+1;

end
end
end

assign counter0_clr=(counter0>=Period0)?1'b1:1'b0;
assign counter0_dec=(counter0<Decode0)?1'b1:1'b0;
assign PWM=counter0_dec;


    nios2e u0 (
        .clk_clk       (clk),       //   clk.clk
        .duty_export   (Decode0),   //  duty.export
        .cycle_export  (Period0),  // cycle.export
        .reset_reset_n (reset_n),  // reset.reset_n
		  .sw1_export    (SW1),    //   sw1.export
        .sw2_export    (SW2),    //   sw2.export
        .sw3_export    (SW3)     //   sw3.export
		  
    );


endmodule