//// Module for reading data via I2C
//module I2C_Data_read(
//    input clk,
//    input rst,
//    input flag,
//    input sda_in,
//    output imu_flag,
//    output [15:0] x_gyro,
//    output [15:0] y_gyro,
//    output [15:0] z_gyro,
//    output [15:0] x_acc,
//    output [15:0] y_acc,
//    output [15:0] z_acc,
//    output [15:0] x_mag,
//    output [15:0] y_mag,
//    output [15:0] z_mag
//);
//
//    // Registers for storing sensor data temporarily
//    reg [15:0] xgyro_w, ygyro_w, zgyro_w;
//    reg [15:0] xacc_w, yacc_w, zacc_w;
//    reg [15:0] xmag_w, ymag_w, zmag_w;
//
//    // Registers for output data
//    reg [15:0] xgyro_out, ygyro_out, zgyro_out;
//    reg [15:0] xacc_out, yacc_out, zacc_out;
//    reg [15:0] xmag_out, ymag_out, zmag_out;
//
//    // Variables to control the internal state and data bit position
//    reg [7:0] mode;       // Used for state machine control
//    reg [7:0] bit_cnt;    // Used to track bit position during data reads
//    reg imu_w;            // Flag to indicate data is ready
//
//    assign imu_flag = imu_w;
//
//    // State machine for reading and processing I2C data
//    always @(posedge flag or posedge rst) begin
//        if (rst == 1'b1) begin
//            mode <= 8'd0;
//            imu_w <= 1'b0;
//            // Reset all outputs
//            {xacc_out, yacc_out, zacc_out, xmag_out, ymag_out, zmag_out} <= 0;
//            {xacc_w, yacc_w, zacc_w, xmag_w, ymag_w, zmag_w} <= 0;
//        end else begin
//            case (mode)
//                8'd0: begin // Data reset
//                    bit_cnt <= 16;
//                    imu_w <= 1'b0;
//                    mode <= mode + 1;
//                end
//                8'd1: begin // Save X gyro data
//                    xgyro_w[bit_cnt - 1] <= sda_in;
//                    bit_cnt <= (bit_cnt == 1) ? 16 : bit_cnt - 1;
//                    mode <= (bit_cnt == 1) ? mode + 1 : mode;
//                end
//                8'd2: begin // Save Y gyro data
//                    ygyro_w[bit_cnt - 1] <= sda_in;
//                    bit_cnt <= (bit_cnt == 1) ? 16 : bit_cnt - 1;
//                    mode <= (bit_cnt == 1) ? mode + 1 : mode;
//                end
//                8'd3: begin // Save Z gyro data
//                    zgyro_w[bit_cnt - 1] <= sda_in;
//                    bit_cnt <= (bit_cnt == 1) ? 14 : bit_cnt - 1; // Note the switch to 14, adjust based on your data structure
//                    mode <= (bit_cnt == 1) ? mode + 1 : mode;
//                end
//                8'd4 to 8'd9: begin // Similar structure for X, Y, Z acceleration and magnetometer data
//                    // Insert similar logic here for acc and mag data handling
//                end
//                8'd10: begin // Output the data
//                    imu_w <= 1'b1;
//                    {xgyro_out, ygyro_out, zgyro_out} <= {xgyro_w, ygyro_w, zgyro_w};
//                    {xacc_out, yacc_out, zacc_out} <= {xacc_w, yacc_w, zacc_w};
//                    {xmag_out, ymag_out, zmag_out} <= {xmag_w, ymag_w, zmag_w};
//                    mode <= 8'd0;
//                end
//            endcase
//        end
//    end
//
//    // Assign outputs to module ports
//    assign {x_acc, y_acc, z_acc} = {xacc_out, yacc_out, zacc_out};
//    assign {x_gyro, y_gyro, z_gyro} = {xgyro_out, ygyro_out, zgyro_out};
//
//endmodule
