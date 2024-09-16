#include "imu_i2c.h"
#include <stdio.h>
#include <stdint.h>
#include <unistd.h> // For usleep()

// Define for enabling detailed debugging output
#define DEBUG 1

#if DEBUG
#define DEBUG_PRINT(fmt, ...) printf(fmt "\n", ##__VA_ARGS__)
#else
#define DEBUG_PRINT(fmt, ...)
#endif

// Function to generate transfer command for I2C communication.
u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D) {
    return (STA << 9) | (STO << 8) | (AD << 1) | RW_D;
}

// Function to read data from a specific address of the IMU.
u8 IMU_read(u8 addr) {
    u8 rd_data = 0;
    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 1));
    usleep(100);
    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | addr));
    usleep(100);
    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 1, BNO055_ADDR, 1));
    for (int i = 0; i < 10000; i++) {
        rd_data = IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);
    }
    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, STOP_BIT);
    return rd_data;
}

// Function to write data to a specific address of the IMU.
u8 IMU_write(u8 addr, u8 data) {
    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 0));
    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, addr);
    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | data));
    return 1;
}

// Function to initialize the IMU device.
int IMU_init(void) {
    IOWR_ALT_AVALON_I2C_CTRL(I2C_BASE, ENABLE);
    DEBUG_PRINT("I2C Start!");
    u8 chip_id = IMU_read(CHIP_ID_ADDR);
    DEBUG_PRINT("chip_id=%04x", chip_id);
    if (chip_id != 0xA0) {
        usleep(2000000);
        chip_id = IMU_read(CHIP_ID_ADDR);
        if (chip_id != 0xA0) {
            DEBUG_PRINT("Error: Invalid Chip ID for BNO055 sensor.");
            return FALSE;
        }
    }
    IMU_write(OPR_MODE_ADDR, CONFIG_MODE);
    IMU_write(SYS_TRIGGER_ADDR, RST_SYS_BIT);
    usleep(650000);
    IMU_write(PWR_MODE_ADDR, NORMAL_MODE);
    IMU_write(PAGE_ID_ADDR, 0);
    IMU_write(SYS_TRIGGER_ADDR, 0x0);
    usleep(50000);
    IMU_write(OPR_MODE_ADDR, IMU_MODE);
    usleep(20000);
    return TRUE;
}

void setExtCrystalUse(u8 usextal) {
    IMU_write(OPR_MODE_ADDR, CONFIG_MODE);
    usleep(25000);
    IMU_write(PAGE_ID_ADDR, 0);
    if (usextal) {
        IMU_write(SYS_TRIGGER_ADDR, 0x80);
    } else {
        IMU_write(SYS_TRIGGER_ADDR, 0x0);
    }
    usleep(10000);
    IMU_write(OPR_MODE_ADDR, IMU_MODE);
    usleep(20000);
}

void IMU_soft_reset(void) {
    IMU_write(SYS_TRIGGER_ADDR, RST_SYS_BIT);
    usleep(650000);
}

void readIMUContinuously(void) {
    uint16_t quat_w, quat_x, quat_y, quat_z;
    IMU_init();
    setExtCrystalUse(TRUE);

    while (1) {
        quat_w = (uint16_t)IMU_read(QUA_DATA_W_LSB) | ((uint16_t)IMU_read(QUA_DATA_W_MSB) << 8);
        quat_x = (uint16_t)IMU_read(QUA_DATA_X_LSB) | ((uint16_t)IMU_read(QUA_DATA_X_MSB) << 8);
        quat_y = (uint16_t)IMU_read(QUA_DATA_Y_LSB) | ((uint16_t)IMU_read(QUA_DATA_Y_MSB) << 8);
        quat_z = (uint16_t)IMU_read(QUA_DATA_Z_LSB) | ((uint16_t)IMU_read(QUA_DATA_Z_MSB) << 8);

        printf("quat_w=%04x ", quat_w);
        printf("quat_x=%04x ", quat_x);
        printf("quat_y=%04x ", quat_y);
        printf("quat_z=%04x\n", quat_z);

        usleep(100000); // Delay for 100 milliseconds
    }
}

int main() {
    readIMUContinuously();
    return 0;
}






//#include "imu_i2c.h"
//
//// Define for enabling detailed debugging output
//#define DEBUG 1
//
//#if DEBUG
//#include <stdio.h>
//#define DEBUG_PRINT(fmt, ...) printf(fmt "\n", ##__VA_ARGS__)
//#else
//#define DEBUG_PRINT(fmt, ...)
//#endif
//
//// Function to generate transfer command for I2C communication.
//u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D) {
//    // Create the command byte with start bit, stop bit, address, and read/write direction.
//    return (STA << 9) | (STO << 8) | (AD << 1) | RW_D;
//}
//
//// Function to read data from a specific address of the IMU.
//u8 IMU_read(u8 addr) {
//    u8 rd_data = 0;
//
//    // Start a transfer to the IMU address.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 1));
//    usleep(100); // Short delay for stability.
//
//    // Send the address with the stop bit.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | addr));
//    usleep(100); // Another short delay.
//
//    // Repeat start for reading data.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 1, BNO055_ADDR, 1));
//
//    // Poll to read the data from the receive buffer.
//    for (int i = 0; i < 10000; i++) {
//        rd_data = IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);
//    }
//
//    // Send stop bit to conclude the transfer.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, STOP_BIT);
//
//    return rd_data;
//}
//
//// Function to write data to a specific address of the IMU.
//u8 IMU_write(u8 addr, u8 data) {
//    // Start a transfer command with write direction.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 0));
//
//    // Write the address where the data will be written.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, addr);
//
//    // Write the data with the stop bit to conclude the transfer.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | data));
//
//    return 1;
//}
//
//// Function to initialize the IMU device.
//int IMU_init(void) {
//    // Enable I2C control.
//    IOWR_ALT_AVALON_I2C_CTRL(I2C_BASE, ENABLE);
//
//    DEBUG_PRINT("I2C Start!");
//
//    // Read the chip ID to verify communication.
//    u8 chip_id = IMU_read(CHIP_ID_ADDR);
//    DEBUG_PRINT("chip_id=%04x", chip_id);
//
//    // Check if the chip ID matches the expected value, retry if necessary.
//    if (chip_id != 0xA0) {
//        usleep(2000000); // Wait for the device to boot.
//        chip_id = IMU_read(CHIP_ID_ADDR);
//        if (chip_id != 0xA0) {
//            DEBUG_PRINT("Error: Invalid Chip ID for BNO055 sensor.");
//            return FALSE; // Return false if the chip ID is still incorrect.
//        }
//    }
//
//    // Set the device to configuration mode before making any changes.
//    IMU_write(OPR_MODE_ADDR, CONFIG_MODE);
//    // Reset the device by writing to the SYS_TRIGGER_ADDR.
//    IMU_write(SYS_TRIGGER_ADDR, 0x20);
//    usleep(650000); // Wait for reset to complete.
//
//    // Set the power mode to normal.
//    IMU_write(PWR_MODE_ADDR, NORMAL_MODE);
//    // Set the page ID to 0 for default register page.
//    IMU_write(PAGE_ID_ADDR, 0);
//    // Clear the system trigger register.
//    IMU_write(SYS_TRIGGER_ADDR, 0x0);
//
//    usleep(50000); // Additional delay for stability.
//    // Set the operation mode to IMU mode.
//    IMU_write(OPR_MODE_ADDR, IMU_MODE);
//    usleep(20000); // Wait for the mode change to take effect.
//
//    return TRUE; // Indicate successful initialization of the IMU.
//}
//
//void setExtCrystalUse(u8 usextal) {
//    IMU_write(OPR_MODE_ADDR, CONFIG_MODE);
//    usleep(25000);
//    IMU_write(PAGE_ID_ADDR, 0);
//    if (usextal) {
//        IMU_write(SYS_TRIGGER_ADDR, 0x80);
//    } else {
//        IMU_write(SYS_TRIGGER_ADDR, 0x0);
//    }
//    usleep(10000);
//    IMU_write(OPR_MODE_ADDR, IMU_MODE);
//    usleep(20000);
//}
//
//void IMU_soft_reset(void) {
//    IMU_write(SYS_TRIGGER_ADDR, RST_SYS_BIT);
//    usleep(650000); // The BNO055 needs some time to reset, typically 650ms
//}








//
//
//// Function to generate transfer command for I2C communication.
//u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D) {
//    // Create the command byte with start bit, stop bit, address, and read/write direction.
//    u8 cmd = ((STA << 9) | (STO << 8) | (AD << 1) | RW_D);
//    return cmd;
//}
//
//// Function to read data from a specific address of the IMU.
//u8 IMU_read(u8 addr) {
//    u8 rd_data;
//
//    // Start a transfer to the IMU address.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, BNO055_ADDR);  // Corrected the address variable name
//    usleep(100); // Short delay for stability.
//
//    // Send the address with the stop bit.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | addr));
//    usleep(100); // Another short delay.
//
//    // Repeat start for reading data.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, BNO055_ADDR);  // Corrected the address variable name again
//
//    // Poll to read the data from the receive buffer.
//    for (int i = 0; i < 10000; i++)
//        rd_data = IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);
//
//    // Send stop bit to conclude the transfer.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, STOP_BIT);
//
//    return rd_data;
//}
//
//
//// Function to write data to a specific address of the IMU.
//u8 IMU_write(u8 addr, u8 data) {
//    // Start a transfer command with write direction.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(0x1, 0x0, BNO055_ADDR, 0x0)); // Corrected the address variable name
//
//    // Write the address where the data will be written.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, addr);
//
//    // Write the data with the stop bit to conclude the transfer.
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | data));
//
//    return 1;
//}
//
//
//// Function to initialize the IMU device.
//int IMU_init(void) {
//    // Enable I2C control.
//    IOWR_ALT_AVALON_I2C_CTRL(I2C_BASE, ENABLE);
//    int timeout = 850;
//
//    printf("I2C Start!\n");
//    // Read the chip ID to verify communication.
//    u8 chip_id = IMU_read(CHIP_ID_ADDR);
//#ifdef DEBUG_SERIAL
//    printf("chip_id=%04x\n", chip_id);
//#endif
//    // Check if the chip ID matches the expected value, retry if necessary.
//    if (chip_id != 0xa0) {
//        usleep(2000000); // Wait for the device to boot.
//        chip_id = IMU_read(CHIP_ID_ADDR);
//        if (chip_id != 0xa0) {
//#ifdef DEBUG_SERIAL
//            printf("Error: Invalid Chip ID for BNO055 sensor.\n");
//#endif
//            return FALSE; // Return false if the chip ID is still incorrect.
//        }
//    }
//
//    // Set the device to configuration mode before making any changes.
//    IMU_write(OPR_MODE_ADDR, CONFIG_MODE);
//    // Reset the device by writing to the SYS_TRIGGER_ADDR.
//    IMU_write(SYS_TRIGGER_ADDR, 0x20);
//    usleep(650000); // Wait for reset to complete.
//
//    usleep(20000);
//    // Check if the device is ready by reading the chip ID again.
//    while (IMU_read(CHIP_ID_ADDR) != 0xa0) {
//        usleep(10000);
//        timeout -= 10;
//        if (timeout <= 0) {
//            break; // Exit the loop if the device does not respond in time.
//        }
//    }
//
//    usleep(50000); // Additional delay for stability.
//    // Set the power mode to normal.
//    IMU_write(PWR_MODE_ADDR, NORMAL_MODE);
//    // Set the page ID to 0 for default register page.
//    IMU_write(PAGE_ID_ADDR, 0);
//    // Clear the system trigger register.
//    IMU_write(SYS_TRIGGER_ADDR, 0x0);
//    usleep(10000); // Short delay before setting the operation mode.
//    // Set the operation mode to IMU mode.
//
//	IMU_write(OPR_MODE_ADDR,IMU_MODE);// Switch the operation mode of the IMU to IMU mode for collecting sensor data.
//	usleep(20000); // Wait for the mode change to take effect.
//
//	return TRUE; // Indicate successful initialization of the IMU.
//
//}
//
//void setExtCrystalUse(u8 usextal){//use external crystal
//	IMU_write(OPR_MODE_ADDR,CONFIG_MODE);//operation mode>configuration mode
//	usleep(25000);
//	IMU_write(PAGE_ID_ADDR,0);//page id>0
//	if(usextal){
//		IMU_write(SYS_TRIGGER_ADDR,0x80);
//	}else{
//		IMU_write(SYS_TRIGGER_ADDR,0x0);
//	}
//	usleep(10000);
//	IMU_write(OPR_MODE_ADDR,IMU_MODE);//operation mode>configuration mode
//	usleep(20000);
//
//}
//
//void IMU_soft_reset(void) {
//    // Write to the SYS_TRIGGER register to trigger a system reset
//    IMU_write(SYS_TRIGGER_ADDR, RST_SYS_BIT);
//
//    // The BNO055 needs some time to reset, typically 650ms
//    usleep(650000);
//}
