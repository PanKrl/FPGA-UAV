// -------------------------------------------------------------
// 
// File Name: D:\fukuda\B4\HDLCoder\2023_12_15\PID_Attitude\PID_Attitude_Mixer_ver7_5\PID_Attitude_ver7_5\Duty.v
// Created: 2024-02-07 16:17:48
// 
// Generated by MATLAB 9.12 and HDL Coder 3.20
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: Duty
// Source Path: PID_Attitude_ver7_5/Motor_Controller/Motor/Duty
// Hierarchy Level: 3
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module Duty
          (in,
           calib,
           rst,
           swin);


  input   [31:0] in;  // uint32
  input   [10:0] calib;  // ufix11
  input   [10:0] rst;  // ufix11
  output  [31:0] swin;  // uint32


  reg [31:0] swin_1;  // uint32


  always @(calib, in, rst) begin
    if (rst > 11'b01111101000) begin
      //reset
      swin_1 = 32'd125000;
      //swin = [rst; rst; rst; rst];
    end
    else if (calib > 11'b10000011010) begin
      //PWM -> MAX
      swin_1 = 32'd500;
      //swin = [max; max; max; max];
    end
    else if (calib == 11'b10000000000) begin
      //PWM -> MIN
      swin_1 = 32'd78000;
      //swin = [min; min; min; min];
    end
    else if (calib < 11'b01111101000) begin
      //PWM -> thrust
      swin_1 = in;
      //swin = [in(1); in(2); in(3); in(4)];
    end
    else begin
      swin_1 = 32'd78000;
      //swin = [err; err; err; err];
    end
  end



  assign swin = swin_1;

endmodule  // Duty

