/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */
//
//
//#include <stdio.h>
//#include <stdint.h>
//#include "imu_i2c.h"
//
//int main() {
//    // Use uint16_t for storing combined 16-bit quaternion components
//    uint16_t quat_w, quat_x, quat_y, quat_z;
//
//    // Initialization
//    IMU_init();
//    setExtCrystalUse(TRUE);
//
//    while(1) {
//        // Read quaternion data and combine it correctly into 16-bit values
//        quat_w = (uint16_t)IMU_read(QUA_DATA_W_LSB) | ((uint16_t)IMU_read(QUA_DATA_W_MSB) << 8);
//        quat_x = (uint16_t)IMU_read(QUA_DATA_X_LSB) | ((uint16_t)IMU_read(QUA_DATA_X_MSB) << 8);
//        quat_y = (uint16_t)IMU_read(QUA_DATA_Y_LSB) | ((uint16_t)IMU_read(QUA_DATA_Y_MSB) << 8);
//        quat_z = (uint16_t)IMU_read(QUA_DATA_Z_LSB) | ((uint16_t)IMU_read(QUA_DATA_Z_MSB) << 8);
//
//        // Print quaternion data
//        printf("quat_w=%04x ", quat_w);
//        printf("quat_x=%04x ", quat_x);
//        printf("quat_y=%04x ", quat_y);
//        printf("quat_z=%04x\n", quat_z);
//
//        usleep(100000); // Delay for 100 milliseconds
//    }
//
//    return 0;
//}
//



//#include <stdio.h>
//#include <stdint.h> // For uint16_t and other integer types
//#include "imu_i2c.h" // Include the header file for the IMU I2C interface.
////
//
////int main() {
////    IMU_init(); // Initialize I2C and BNO055
////
////    // Try reading the chip ID only
////    u8 chip_id = IMU_read(CHIP_ID_ADDR);
////    printf("chip_id=%02x\n", chip_id);
////
////    // If chip_id is not correct, halt or loop here
////    while(chip_id != 0xA0) {
////        usleep(1000000); // 1 second delay
////        chip_id = IMU_read(CHIP_ID_ADDR); // Attempt to read again
////        printf("chip_id retry=%02x\n", chip_id);
////    }
////
////    return 0;
////}
////
////
//
//
//
//
//int main() {
//    // Use uint16_t for storing combined 16-bit quaternion components
//    uint16_t quat_w, quat_x, quat_y, quat_z;
//
//    // Initialization remains the same...
//    IMU_init();
//    setExtCrystalUse(TRUE);
//
//    while(1) {
//        // Assuming IMU_read returns an 8-bit value, combine it correctly into 16-bit values
//        quat_w = (uint16_t)IMU_read(QUA_DATA_W_LSB) | ((uint16_t)IMU_read(QUA_DATA_W_MSB) << 8);
//        quat_x = (uint16_t)IMU_read(QUA_DATA_X_LSB) | ((uint16_t)IMU_read(QUA_DATA_X_MSB) << 8);
//        quat_y = (uint16_t)IMU_read(QUA_DATA_Y_LSB) | ((uint16_t)IMU_read(QUA_DATA_Y_MSB) << 8);
//        quat_z = (uint16_t)IMU_read(QUA_DATA_Z_LSB) | ((uint16_t)IMU_read(QUA_DATA_Z_MSB) << 8);
//
//        // Printing remains the same
//        printf("quat_w=%04x ", quat_w);
//        printf("quat_x=%04x ", quat_x);
//        printf("quat_y=%04x ", quat_y);
//        printf("quat_z=%04x ", quat_z);
//        printf("\n");
//
//        usleep(100000); // Correctly labeled as 100 milliseconds.
//    }
//
//    return 0;
//}
//

