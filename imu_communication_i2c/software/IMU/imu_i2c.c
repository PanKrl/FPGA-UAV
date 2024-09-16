#include "imu_i2c.h"
#include "bno055.h"
#include <stdio.h>
#include <stdint.h>
#include <unistd.h>

#define I2C_SYSTEM_CLOCK 50000000

#define DEBUG 1

#if DEBUG
#define DEBUG_PRINT(fmt, ...) printf(fmt "\n", ##__VA_ARGS__)
#else
#define DEBUG_PRINT(fmt, ...)
#endif

void setI2CClock(uint32_t frequency) {
    uint32_t scl_period = I2C_SYSTEM_CLOCK / frequency;
    uint32_t scl_high = scl_period / 2;
    uint32_t scl_low = scl_period - scl_high;

    IOWR_ALT_AVALON_I2C_SCL_HIGH(I2C_BASE, scl_high);
    IOWR_ALT_AVALON_I2C_SCL_LOW(I2C_BASE, scl_low);
}

bool checkI2CReady(void) {
    uint32_t status = IORD_ALT_AVALON_I2C_STATUS(I2C_BASE);
    return (status & ALT_AVALON_I2C_STATUS_CORE_STATUS_MSK) != 0;
}

u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D) {
    return (STA << 9) | (STO << 8) | (AD << 1) | RW_D;
}

int8_t bno055_i2c_read(uint8_t dev_id, uint8_t reg_addr, uint8_t *reg_data, uint16_t length) {
    int32_t i;
    for (i = 0; i < length; i++) {
        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, dev_id, 0));
        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, reg_addr + i);
        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 1, dev_id, 1));
        reg_data[i] = IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);
        usleep(1000);
    }
    return 0;
}

int8_t bno055_i2c_write(uint8_t dev_id, uint8_t reg_addr, uint8_t *reg_data, uint16_t length) {
    int32_t i;
    for (i = 0; i < length; i++) {
        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, dev_id, 0));
        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, reg_addr + i);
        IOWR_ALT_AVALON_I2C_TX_DATA(I2C_BASE, reg_data[i]);
        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, STOP_BIT);
        usleep(1000);
    }
    return 0;
}

void bno055_delay_ms(uint32_t period) {
    usleep(period * 1000);
}


// Function to initialize the IMU device
int8_t IMU_init(void) {
    int8_t rslt;
    struct bno055_t bno055;
    bno055.bus_read = bno055_i2c_read;
    bno055.bus_write = bno055_i2c_write;
    bno055.delay_msec = bno055_delay_ms;
    bno055.dev_addr = BNO055_ADDR;

    DEBUG_PRINT("Initializing I2C bus...");

    // Set I2C clock frequency
    setI2CClock(400000);  // Set to 400 kHz as per BNO055 spec

    // Wait until I2C is ready
    while (!checkI2CReady()) {
        usleep(1000);  // Sleep for 1 ms
    }

    DEBUG_PRINT("I2C bus is ready.");

    rslt = bno055_init(&bno055);
    if (rslt != BNO055_SUCCESS) {
        DEBUG_PRINT("Failed to initialize IMU.");
        return rslt;
    }

    DEBUG_PRINT("IMU initialization successful.");
    return BNO055_SUCCESS;
}

int main() {
    if (IMU_init() != BNO055_SUCCESS) {
        DEBUG_PRINT("Failed to initialize IMU.");
        return -1;
    }

    // Device is initialized, perform further operations
    DEBUG_PRINT("Device initialized and ready for further operations.");

    // Implement further device operations, like continuous data reading
    while (1) {
        // Placeholder for reading data continuously or handling commands
        usleep(100000);  // Sleep to simulate periodic data read
    }

    return 0;
}

//#include "imu_i2c.h"
//#include "bno055.h"
//#include <stdio.h>
//#include <stdint.h>
//#include <unistd.h>  // For usleep()
//
//#define I2C_SYSTEM_CLOCK 50000000  // System clock in Hz feeding the I2C controller
//
//// Define for enabling detailed debugging output
//#define DEBUG 1
//
//#if DEBUG
//#define DEBUG_PRINT(fmt, ...) printf(fmt "\n", ##__VA_ARGS__)
//#else
//#define DEBUG_PRINT(fmt, ...)
//#endif
//
//// Function to set the I2C clock frequency
//void setI2CClock(uint32_t frequency) {
//    uint32_t scl_period = I2C_SYSTEM_CLOCK / frequency;
//    uint32_t scl_high = scl_period / 2;  // Assuming a 50% duty cycle
//    uint32_t scl_low = scl_period - scl_high;
//
//    // Write to SCL High and Low period registers
//    IOWR_ALT_AVALON_I2C_SCL_HIGH(I2C_BASE, scl_high);
//    IOWR_ALT_AVALON_I2C_SCL_LOW(I2C_BASE, scl_low);
//}
//
//// Function to check if the I2C interface is ready
//bool checkI2CReady(void) {
//    uint32_t status = IORD_ALT_AVALON_I2C_STATUS(I2C_BASE);
//    return (status & ALT_AVALON_I2C_STATUS_CORE_STATUS_MSK) != 0;
//}
//
//// Function to generate transfer command for I2C communication
//u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D) {
//    return (STA << 9) | (STO << 8) | (AD << 1) | RW_D;
//}
//
//// Function to read data from the IMU via I2C
//int8_t bno055_i2c_read(uint8_t dev_id, uint8_t reg_addr, uint8_t *reg_data, uint16_t length) {
//    int32_t i;
//    for (i = 0; i < length; i++) {
//        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, dev_id, 0));
//        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, reg_addr + i);
//        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 1, dev_id, 1));
//        reg_data[i] = IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);
//        usleep(1000);  // Sleep for 1 ms
//    }
//    return 0;
//}
//
//// Function to write data to the IMU via I2C
//int8_t bno055_i2c_write(uint8_t dev_id, uint8_t reg_addr, uint8_t *reg_data, uint16_t length) {
//    int32_t i;
//    for (i = 0; i < length; i++) {
//        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, dev_id, 0));
//        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, reg_addr + i);
//        IOWR_ALT_AVALON_I2C_TX_DATA(I2C_BASE, reg_data[i]);
//        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, STOP_BIT);
//        usleep(1000);  // Sleep for 1 ms
//    }
//    return 0;
//}
//
//// Function to provide a delay in milliseconds
//void bno055_delay_ms(uint32_t period) {
//    usleep(period * 1000);  // Convert milliseconds to microseconds
//}
//
//// Function to initialize the IMU device
//int8_t IMU_init(void) {
//    int8_t rslt;
//    struct bno055_t bno055;
//    bno055.bus_read = bno055_i2c_read;
//    bno055.bus_write = bno055_i2c_write;
//    bno055.delay_msec = bno055_delay_ms;
//    bno055.dev_addr = BNO055_ADDR;
//
//    DEBUG_PRINT("Initializing I2C bus...");
//
//    // Set I2C clock frequency
//    setI2CClock(400000);  // Set to 400 kHz as per BNO055 spec
//
//    // Wait until I2C is ready
//    while (!checkI2CReady()) {
//        usleep(1000);  // Sleep for 1 ms
//    }
//
//    DEBUG_PRINT("I2C bus is ready.");
//
//    rslt = bno055_init(&bno055);
//    if (rslt != BNO055_SUCCESS) {
//        DEBUG_PRINT("Failed to initialize IMU.");
//        return rslt;
//    }
//
//    DEBUG_PRINT("IMU initialization successful.");
//    return BNO055_SUCCESS;
//}
//
//int main() {
//    if (IMU_init() != BNO055_SUCCESS) {
//        DEBUG_PRINT("Failed to initialize IMU.");
//        return -1;
//    }
//
//    // Device is initialized, perform further operations
//    DEBUG_PRINT("Device initialized and ready for further operations.");
//
//    // Implement further device operations, like continuous data reading
//    while (1) {
//        // Placeholder for reading data continuously or handling commands
//        usleep(100000);  // Sleep to simulate periodic data read
//    }
//
//    return 0;
//}










// 16.06.2024
//
//#include "imu_i2c.h"
//#include <stdio.h>
//#include <stdint.h>
//#include <unistd.h>  // For usleep()
//
//#define I2C_SYSTEM_CLOCK 50000000  // System clock in Hz feeding the I2C controller
//
//// Define for enabling detailed debugging output
//#define DEBUG 1
//
//#if DEBUG
//#define DEBUG_PRINT(fmt, ...) printf(fmt "\n", ##__VA_ARGS__)
//#else
//#define DEBUG_PRINT(fmt, ...)
//#endif
//
//// Function to set the I2C clock frequency
//void setI2CClock(uint32_t frequency) {
//    uint32_t scl_period = I2C_SYSTEM_CLOCK / frequency;
//    uint32_t scl_high = scl_period / 2;  // Assuming a 50% duty cycle
//    uint32_t scl_low = scl_period - scl_high;
//
//    // Write to SCL High and Low period registers
//    IOWR_ALT_AVALON_I2C_SCL_HIGH(I2C_BASE, scl_high);
//    IOWR_ALT_AVALON_I2C_SCL_LOW(I2C_BASE, scl_low);
//}
//
//// Function to check if the I2C interface is ready
//bool checkI2CReady(void) {
//    uint32_t status = IORD_ALT_AVALON_I2C_STATUS(I2C_BASE);
//    return (status & ALT_AVALON_I2C_STATUS_CORE_STATUS_MSK) != 0;
//}
//
//// Function to generate transfer command for I2C communication.
// u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D) {
//    return (STA << 9) | (STO << 8) | (AD << 1) | RW_D;
// }
////Function to read data from a specific address of the IMU.
// u8 IMU_read(u8 addr) {
//    u8 rd_data = 0;
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 1));
//    usleep(100);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | addr));
//    usleep(100);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 1, BNO055_ADDR, 1));
//    rd_data = IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, STOP_BIT);
//    return rd_data;
// }
//// Function to initialize the IMU device
//int IMU_init(void) {
//    // Write to the control register to enable the I2C and set Master mode and speed
//    IOWR_ALT_AVALON_I2C_CTRL(I2C_BASE, ALT_AVALON_I2C_CTRL_EN_MSK);
//
//    DEBUG_PRINT("Initializing I2C bus...");
//
//    // Set I2C clock frequency
//    setI2CClock(400000);  // Set to 400 kHz as per BNO055 spec
//
//    // Wait until I2C is ready
//    while (!checkI2CReady()) {
//        usleep(1000);  // Sleep for 1 ms
//    }
//
//    DEBUG_PRINT("I2C bus is ready.");
//
////    // Start by resetting the IMU
////    IMU_soft_reset();
//
//    // Read Chip ID as a first test of communication
//    uint8_t chip_id = IMU_read(CHIP_ID_ADDR);
//    DEBUG_PRINT("Chip ID read: 0x%02x", chip_id);
//    if (chip_id != EXPECTED_CHIP_ID) {
//        DEBUG_PRINT("Invalid Chip ID: 0x%02x", chip_id);
//        return -1;  // Failure
//    }
//
//    DEBUG_PRINT("IMU initialization successful.");
//    return 0;  // Success
//}
//
//int main() {
//    if (IMU_init() != 0) {
//        DEBUG_PRINT("Failed to initialize IMU.");
//        return -1;
//    }
//
//    // Device is initialized, perform further operations
//    DEBUG_PRINT("Device initialized and ready for further operations.");
//
//    // Implement further device operations, like continuous data reading
//    while (1) {
//        // Placeholder for reading data continuously or handling commands
//        usleep(100000);  // Sleep to simulate periodic data read
//    }
//
//    return 0;
//}



//#include "imu_i2c.h"
//#include <stdio.h>
//#include <stdint.h>
//#include <unistd.h> // For usleep()
//
//// Define for enabling detailed debugging output
//#define DEBUG 1
//
//#if DEBUG
//#define DEBUG_PRINT(fmt, ...) printf(fmt "\n", ##__VA_ARGS__)
//#else
//#define DEBUG_PRINT(fmt, ...)
//#endif
//
//#define BNO055_I2C_ADDR (COM3_state == HIGH ? 0x29 : 0x28)
//
//// Function to generate transfer command for I2C communication.
// u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D) {
//    return (STA << 9) | (STO << 8) | (AD << 1) | RW_D;
//}
//
//// Function to read data from a specific address of the IMU.
// u8 IMU_read(u8 addr) {
//    u8 rd_data = 0;
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 1));
//    usleep(100);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | addr));
//    usleep(100);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 1, BNO055_ADDR, 1));
//    rd_data = IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, STOP_BIT);
//    return rd_data;
//}
//
//// Function to write data to a specific address of the IMU.
// u8 IMU_write(u8 addr, u8 data) {
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 0));
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, addr);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | data));
//    return 1;
//}
//
//// Function to initialize the IMU device.
//// Improved initialization function using Avalon I2C specifics
//int IMU_init(void) {
//
//	 usleep(500000);  // Wait for 500 ms before initializing to ensure IMU is ready
//
//    // Write to the control register to enable the I2C and set Master mode and speed
//    IOWR_ALT_AVALON_I2C_CTRL(I2C_BASE, ALT_AVALON_I2C_CTRL_EN_MSK);
//
//    DEBUG_PRINT("Initializing I2C bus...");
//
//    // Clear any pending interrupts by writing to the status register
//    IOWR_ALT_AVALON_I2C_STATUS(I2C_BASE, 0x00);
//
//    // Check READY status
//    if (!(IORD_ALT_AVALON_I2C_STATUS(I2C_BASE) & ALT_AVALON_I2C_STATUS_CORE_STATUS_MSK)) {
//        DEBUG_PRINT("I2C bus not ready.");
//        return FALSE;
//    }
//
//    // Read Chip ID as a first test of communication
//    uint8_t chip_id = IMU_read(CHIP_ID_ADDR);
//    if (chip_id != EXPECTED_CHIP_ID) {
//        DEBUG_PRINT("Invalid Chip ID: %02x", chip_id);
//        return FALSE;
//    }
//
//    DEBUG_PRINT("I2C bus initialized. Chip ID verified.");
//
//    return TRUE;
//}
//
//
//int main() {
//    if (!IMU_init()) {
//        DEBUG_PRINT("Failed to initialize IMU.");
//        return -1;
//    }
//    DEBUG_PRINT("IMU initialized successfully.");
//
//    // Placeholder for continuous read operation
//    while (1) {
//        // Read quaternion data
//        uint16_t quat_w = (IMU_read(QUA_DATA_W_MSB) << 8) | IMU_read(QUA_DATA_W_LSB);
//        uint16_t quat_x = (IMU_read(QUA_DATA_X_MSB) << 8) | IMU_read(QUA_DATA_X_LSB);
//        uint16_t quat_y = (IMU_read(QUA_DATA_Y_MSB) << 8) | IMU_read(QUA_DATA_Y_LSB);
//        uint16_t quat_z = (IMU_read(QUA_DATA_Z_MSB) << 8) | IMU_read(QUA_DATA_Z_LSB);
//
//        DEBUG_PRINT("quat_w=%04x quat_x=%04x quat_y=%04x quat_z=%04x", quat_w, quat_x, quat_y, quat_z);
//        usleep(100000); // Adjust based on your data refresh rate needs
//    }
//    return 0;
//}



//#include "imu_i2c.h"
//
//#define DEBUG 1
//
//#if DEBUG
//#define DEBUG_PRINT(fmt, ...) printf(fmt "\n", ##__VA_ARGS__)
//#else
//#define DEBUG_PRINT(fmt, ...)
//#endif
//
//u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D) {
//    return (STA << 9) | (STO << 8) | (AD << 1) | RW_D;
//}
//
//u8 IMU_read(u8 addr) {
//    u8 rd_data = 0;
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 1));
//    usleep(100);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | addr));
//    usleep(100);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 1, BNO055_ADDR, 1));
//    for (int i = 0; i < 10000; i++) {
//        rd_data = IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);
//    }
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, STOP_BIT);
//    return rd_data;
//}
//
//u8 IMU_write(u8 addr, u8 data) {
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 0));
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, addr);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | data));
//    return 1;
//}
//
//int IMU_init(void) {
//    IOWR_ALT_AVALON_I2C_CTRL(I2C_BASE, ENABLE);
//    DEBUG_PRINT("I2C Start!");
//    u8 chip_id = IMU_read(CHIP_ID_ADDR);
//    DEBUG_PRINT("chip_id=%04x", chip_id);
//    if (chip_id != 0xA0) {
//        usleep(2000000);
//        chip_id = IMU_read(CHIP_ID_ADDR);
//        if (chip_id != 0xA0) {
//            DEBUG_PRINT("Error: Invalid Chip ID for BNO055 sensor.");
//            return 0;  // Use standard C boolean false value
//        }
//    }
//    IMU_write(OPR_MODE_ADDR, CONFIG_MODE);
//    IMU_write(SYS_TRIGGER_ADDR, RST_SYS_BIT);
//    usleep(650000);
//    IMU_write(PWR_MODE_ADDR, NORMAL_MODE);
//    IMU_write(PAGE_ID_ADDR, 0);
//    IMU_write(SYS_TRIGGER_ADDR, 0x0);
//    usleep(50000);
//    IMU_write(OPR_MODE_ADDR, IMU_MODE);
//    usleep(20000);
//    return 1;  // Use standard C boolean true value
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
//    usleep(650000);
//}
//
//void readIMUData(void) {
//    uint16_t quat_w, quat_x, quat_y, quat_z;
//    IMU_init();
//    setExtCrystalUse(TRUE);
//
//    while (1) {
//        quat_w = (uint16_t)IMU_read(QUA_DATA_W_LSB) | ((uint16_t)IMU_read(QUA_DATA_W_MSB) << 8);
//        quat_x = (uint16_t)IMU_read(QUA_DATA_X_LSB) | ((uint16_t)IMU_read(QUA_DATA_X_MSB) << 8);
//        quat_y = (uint16_t)IMU_read(QUA_DATA_Y_LSB) | ((uint16_t)IMU_read(QUA_DATA_Y_MSB) << 8);
//        quat_z = (uint16_t)IMU_read(QUA_DATA_Z_LSB) | ((uint16_t)IMU_read(QUA_DATA_Z_MSB) << 8);
//
//        DEBUG_PRINT("quat_w=%04x ", quat_w);
//        DEBUG_PRINT("quat_x=%04x ", quat_x);
//        DEBUG_PRINT("quat_y=%04x ", quat_y);
//        DEBUG_PRINT("quat_z=%04x\n", quat_z);
//
//        usleep(100000); // Delay for 100 milliseconds
//        processIMUData(quat_w, quat_x, quat_y, quat_z);
//    }
//}
//
//void processIMUData(uint16_t quat_w, uint16_t quat_x, uint16_t quat_y, uint16_t quat_z) {
//    // Placeholder for processing the quaternion data
//    DEBUG_PRINT("Processing IMU data...");
//    // Add any logic needed to process or respond to the data
//}
//
//void scanI2CBus(void) {
//    printf("Scanning I2C bus...\n");
//    for (int address = 1; address < 128; address++) {
//        IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 1, address, 0));
//        usleep(1000); // Wait for the transfer to complete
//        if (IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE) != 0) {
//            printf("Device found at address 0x%02X\n", address);
//        }
//    }
//}
//
//int main() {
//
//	printf("Initializing I2C bus...\n");
//	    scanI2CBus(); // Scan before initialization to see if any device responds
//	    if (IMU_init() == TRUE) {
//	        printf("IMU initialized successfully.\n");
//	    } else {
//	        printf("Failed to initialize IMU.\n");
//	        return -1;
//	    }
//
//    readIMUData();
//    return 0;
//}



//#include "imu_i2c.h"
//#include <stdio.h>
//#include <stdint.h>
//#include <unistd.h> // For usleep()
//
//#define DEBUG 1
//
//#if DEBUG
//#define DEBUG_PRINT(fmt, ...) printf(fmt "\n", ##__VA_ARGS__)
//#else
//#define DEBUG_PRINT(fmt, ...)
//#endif
//
//// Replacing TRUE and FALSE with true and false if using stdbool.h
//#define TRUE true
//#define FALSE false
//
//u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D) {
//    return (STA << 9) | (STO << 8) | (AD << 1) | RW_D;
//}
//
//u8 IMU_read(u8 addr) {
//    u8 rd_data = 0;
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 1));
//    usleep(100);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | addr));
//    usleep(100);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 1, BNO055_ADDR, 1));
//    for (int i = 0; i < 10000; i++) {
//        rd_data = IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);
//    }
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, STOP_BIT);
//    return rd_data;
//}
//
//u8 IMU_write(u8 addr, u8 data) {
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, TFR_CMD(1, 0, BNO055_ADDR, 0));
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, addr);
//    IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE, (STOP_BIT | data));
//    return 1;
//}
//
//int IMU_init(void) {
//    IOWR_ALT_AVALON_I2C_CTRL(I2C_BASE, ENABLE);
//    DEBUG_PRINT("I2C Start!");
//    u8 chip_id = IMU_read(CHIP_ID_ADDR);
//    DEBUG_PRINT("chip_id=%04x", chip_id);
//    if (chip_id != 0xA0) {
//        usleep(2000000);
//        chip_id = IMU_read(CHIP_ID_ADDR);
//        if (chip_id != 0xA0) {
//            DEBUG_PRINT("Error: Invalid Chip ID for BNO055 sensor.");
//            return FALSE;
//        }
//    }
//    IMU_write(OPR_MODE_ADDR, CONFIG_MODE);
//    IMU_write(SYS_TRIGGER_ADDR, RST_SYS_BIT);
//    usleep(650000);
//    IMU_write(PWR_MODE_ADDR, NORMAL_MODE);
//    IMU_write(PAGE_ID_ADDR, 0);
//    IMU_write(SYS_TRIGGER_ADDR, 0x0);
//    usleep(50000);
//    IMU_write(OPR_MODE_ADDR, IMU_MODE);
//    usleep(20000);
//    return TRUE;
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
//    usleep(650000);
//}
//
//void readIMUContinuously(void) {
//    uint16_t quat_w, quat_x, quat_y, quat_z;
//    IMU_init();
//    setExtCrystalUse(TRUE);
//
//    while (1) {
//        quat_w = (uint16_t)IMU_read(QUA_DATA_W_LSB) | ((uint16_t)IMU_read(QUA_DATA_W_MSB) << 8);
//        quat_x = (uint16_t)IMU_read(QUA_DATA_X_LSB) | ((uint16_t)IMU_read(QUA_DATA_X_MSB) << 8);
//        quat_y = (uint16_t)IMU_read(QUA_DATA_Y_LSB) | ((uint16_t)IMU_read(QUA_DATA_Y_MSB) << 8);
//        quat_z = (uint16_t)IMU_read(QUA_DATA_Z_LSB) | ((uint16_t)IMU_read(QUA_DATA_Z_MSB) << 8);
//
//        printf("quat_w=%04x ", quat_w);
//        printf("quat_x=%04x ", quat_x);
//        printf("quat_y=%04x ", quat_y);
//        printf("quat_z=%04x\n", quat_z);
//
//        usleep(100000); // Delay for 100 milliseconds
//    }
//}
//
//int main() {
//    readIMUContinuously();
//    return 0;
//}






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
