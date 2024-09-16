#ifndef IMU_I2C_H_
#define IMU_I2C_H_

#include <stdio.h>
#include <stdlib.h>
#include "system.h"
#include <string.h>
#include "altera_avalon_pio_regs.h"
#include <altera_avalon_i2c.h>  // Include for I2C communication support.
#include "altera_avalon_i2c_regs.h"  // Register definitions for I2C.
#include "sys/alt_irq.h"
#include "sys/alt_cache.h"
#include <math.h>
#include <io.h>
#include <unistd.h>
#include <stdint.h>  // Standard integer definitions.

#define BNO055_ADDR 0x28  // I2C address of the IMU.
#define STOP_BIT 0x100  // Stop bit definition for I2C communication.

// Register addresses and operational modes for the IMU.
#define UNIT_SEL_ADDR 0x3b
#define PAGE_ID_ADDR 0x07
#define OPR_MODE_ADDR 0x3d
#define CONFIG_MODE 0x00
#define GYRONLY_MODE 0x03
#define ACC_GYRO_MODE 0x05
#define AMG_MODE 0x07
#define IMU_MODE 0x0c
#define PWR_MODE_ADDR 0x3e
#define NORMAL_MODE 0x00
#define LOW_MODE 0x01
#define SUSPEND_MODE 0x02
#define SYS_TRIGGER_ADDR 0x3f
#define RST_SYS_BIT 0x20

// Register addresses for IMU data.
#define CHIP_ID_ADDR 0x28
#define SYS_CLK_STAT 0x38

#define ACC_DATA_X_LSB 0x08
#define ACC_DATA_X_MSB 0x09
#define ACC_DATA_Y_LSB 0x0a
#define ACC_DATA_Y_MSB 0x0b
#define ACC_DATA_Z_LSB 0x0c
#define ACC_DATA_Z_MSB 0x0d

#define GYR_DATA_X_LSB 0x14
#define GYR_DATA_X_MSB 0x15
#define GYR_DATA_Y_LSB 0x16
#define GYR_DATA_Y_MSB 0x17
#define GYR_DATA_Z_LSB 0x18
#define GYR_DATA_Z_MSB 0x19

#define QUA_DATA_W_LSB 0x20
#define QUA_DATA_W_MSB 0x21
#define QUA_DATA_X_LSB 0x22
#define QUA_DATA_X_MSB 0x23
#define QUA_DATA_Y_LSB 0x24
#define QUA_DATA_Y_MSB 0x25
#define QUA_DATA_Z_LSB 0x26
#define QUA_DATA_Z_MSB 0x27

#define ENABLE 0x3  // Enable bit for I2C controller.
#define DISABLE 0x0  // Disable bit for I2C controller.

#define MAX_BUFFER_SIZE 32  // Maximum buffer size for data transfer.

#define TRUE 1
#define FALSE 0

#define DEBUG_SERIAL  // Define for enabling serial debugging.

typedef uint8_t u8;  // Define a type alias for 8-bit unsigned integers.

// Function prototypes for initializing the IMU, reading and writing data, and additional configuration.
u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D);  // Create a command for I2C transfer.
u8 IMU_read(u8 addr);  // Read a byte from a specific IMU register.
u8 IMU_write(u8 addr, u8 data);  // Write a byte to a specific IMU register.
int IMU_init(void);  // Initialize the IMU device.
void setExtCrystalUse(u8 usextal);  // Set usage of an external crystal.
void IMU_soft_reset(void);  // Perform a software reset of the IMU.

#endif /* IMU_I2C_H_ */








//#ifndef IMU_I2C_H_
//#define IMU_I2C_H_
//
//#include <stdio.h>
//#include <stdlib.h>
//#include "system.h"
//#include <string.h>
//#include "altera_avalon_pio_regs.h"
//#include <altera_avalon_i2c.h>
//#include "altera_avalon_i2c_regs.h"
//#include "sys/alt_irq.h"
//#include <math.h>
//#include <io.h>
//#include <unistd.h>
//#include <stdint.h>
//
//#define BNO055_ADDR 0x28
//#define STOP_BIT 0x100
//
//#define UNIT_SEL_ADDR 0x3b
//#define PAGE_ID_ADDR 0x07
//
//#define OPR_MODE_ADDR 0x3d
//#define CONFIG_MODE 0x00
//#define GYRONLY_MODE 0x03
//#define ACC_GYRO_MODE 0x05
//#define AMG_MODE 0x07
//#define IMU_MODE 0x0c
//
//#define PWR_MODE_ADDR 0x3e
//#define NORMAL_MODE 0x00
//#define LOW_MODE 0x01
//#define SUSPEND_MODE 0x02
//
//#define SYS_TRIGGER_ADDR 0x3f
//#define RST_SYS_BIT 0x20
//
//#define CHIP_ID_ADDR 0x00
//#define SYS_CLK_STAT 0x38
//
//#define ACC_DATA_X_LSB 0x08
//#define ACC_DATA_X_MSB 0x09
//#define ACC_DATA_Y_LSB 0x0a
//#define ACC_DATA_Y_MSB 0x0b
//#define ACC_DATA_Z_LSB 0x0c
//#define ACC_DATA_Z_MSB 0x0d
//
//#define GYR_DATA_X_LSB 0x14
//#define GYR_DATA_X_MSB 0x15
//#define GYR_DATA_Y_LSB 0x16
//#define GYR_DATA_Y_MSB 0x17
//#define GYR_DATA_Z_LSB 0x18
//#define GYR_DATA_Z_MSB 0x19
//
//#define QUA_DATA_W_LSB 0x20
//#define QUA_DATA_W_MSB 0x21
//#define QUA_DATA_X_LSB 0x22
//#define QUA_DATA_X_MSB 0x23
//#define QUA_DATA_Y_LSB 0x24
//#define QUA_DATA_Y_MSB 0x25
//#define QUA_DATA_Z_LSB 0x26
//#define QUA_DATA_Z_MSB 0x27
//
//#define ENABLE 0x3
//#define DISABLE 0x0
//
//#define MAX_BUFFER_SIZE 32
//
//#define TRUE 1
//#define FALSE 0
//
//#define DEBUG_SERIAL
//
//typedef uint8_t u8;
//
//u8 TFR_CMD(u8 STA, u8 STO, u8 AD, u8 RW_D);
//u8 IMU_read(u8 addr);
//u8 IMU_write(u8 addr, u8 data);
//int IMU_init(void);
//void setExtCrystalUse(u8 usextal);
//void IMU_soft_reset(void); // Added function prototype for soft reset.
//
//#endif /* IMU_I2C_H_ */



//
//
//#ifndef IMU_I2C_H_
//#define IMU_I2C_H_
//
//#include <stdio.h>
//#include <stdlib.h>
//#include "system.h"
//#include <string.h>
//#include "altera_avalon_pio_regs.h" // Include for PIO (Parallel I/O) register definitions.
////#include <altera_avalon_uart.h> // UART library commented out, unused in this context.
////#include "altera_avalon_uart_regs.h" // UART register definitions, also commented out.
//#include <altera_avalon_i2c.h> // Include for I2C communication support.
//#include "altera_avalon_i2c_regs.h" // Register definitions for I2C.
//#include "sys/alt_irq.h" // Include for interrupt request handling.
//#include <math.h>
//#include <io.h>
//#include <unistd.h>
//#include <stdint.h> // Standard integer definitions.
//
//
//#define BNO055_ADDR 0x28 // I2C default address of the IMU.
//
//#define STOP_BIT 0x100 // Stop bit definition for I2C communication.
//
//// Unit selection register and other configuration definitions for the IMU.
//#define UNIT_SEL_ADDR 0x3b
//#define PAGE_ID_ADDR 0x07
//
////Operation mode setting
//#define OPR_MODE_ADDR 0x3d
//#define CONFIG_MODE 0x00
//#define GYRONLY_MODE 0x03
//#define ACC_GYRO_MODE 0x05
//#define AMG_MODE 0x07
//#define IMU_MODE 0x0c
//
////Power mode setting
//#define PWR_MODE_ADDR 0x3e
//#define NORMAL_MODE 0x00
//#define LOW_MODE 0x01
//#define SUSPEND_MODE 0x02
//
////System trigger address
//#define SYS_TRIGGER_ADDR 0x3f
//#define RST_SYS_BIT 0x20  // Bit 5 set for system reset
//
////Status registers
//#define CHIP_ID_ADDR 0x00
//#define SYS_CLK_STAT 0x38
//
//// Definitions for the accelerometer, gyroscope, and quaternion data addresses.
//#define ACC_DATA_X_LSB 0x08
//#define ACC_DATA_X_MSB 0x09
//#define ACC_DATA_Y_LSB 0x0a
//#define ACC_DATA_Y_MSB 0x0b
//#define ACC_DATA_Z_LSB 0x0c
//#define ACC_DATA_Z_MSB 0x0d
//
//#define GYR_DATA_X_LSB 0x14
//#define GYR_DATA_X_MSB 0x15
//#define GYR_DATA_Y_LSB 0x16
//#define GYR_DATA_Y_MSB 0x17
//#define GYR_DATA_Z_LSB 0x18
//#define GYR_DATA_Z_MSB 0x19
//
//
//#define QUA_DATA_W_LSB 0x20
//#define QUA_DATA_W_MSB 0x21
//#define QUA_DATA_X_LSB 0x22
//#define QUA_DATA_X_MSB 0x23
//#define QUA_DATA_Y_LSB 0x24
//#define QUA_DATA_Y_MSB 0x25
//#define QUA_DATA_Z_LSB 0x26
//#define QUA_DATA_Z_MSB 0x27
//
//
//#define ENABLE 0x3 // Configuration for bus speed and enable bit. BUS_SPEED:(400kbps)
//#define DISABLE 0x0
//
//#define MAX_BUFFER_SIZE 32 // Maximum buffer size for data transfer.
//
//#define TRUE 1
//#define FALSE 0
//
//#define DEBUG_SERIAL // Define for enabling serial debugging.
//
//typedef uint8_t u8; // Define a type alias for 8-bit unsigned integers.
//
//// Function prototypes for initializing the IMU, reading and writing data, and additional configuration.
//u8 TFR_CMD(u8 STA,u8 STO,u8 AD,u8 RW_D);
//u8 IMU_read(u8 addr);
//u8 IMU_write(u8 addr,u8 data);
//int IMU_init(void);
//void setExtCrystalUse(u8 usextal);
//
//#endif /* IMU_I2C_H_ */
