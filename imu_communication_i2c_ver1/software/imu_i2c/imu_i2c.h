/*
 * imu_i2c.h
 *
 *  Created on: 2023/11/16
 *      Author: space
 */

#ifndef IMU_I2C_H_
#define IMU_I2C_H_

#include <stdio.h>
#include <stdlib.h>
#include "system.h"
#include <string.h>
#include "altera_avalon_pio_regs.h"
//#include <altera_avalon_uart.h>
//#include "altera_avalon_uart_regs.h"
#include <altera_avalon_i2c.h>
#include "altera_avalon_i2c_regs.h"
#include "sys/alt_irq.h"
#include <math.h>
#include <io.h>
#include <unistd.h>
#include <stdint.h>

#define BNO055_ADDR 0x28
#define STOP_BIT 0x100

//Unit selection register
#define UNIT_SEL_ADDR 0x3b

//PAGE_ID
#define PAGE_ID_ADDR 0x07

//Operation mode setting
#define OPR_MODE_ADDR 0x3d
#define CONFIG_MODE 0x00
#define GYRONLY_MODE 0x03
#define ACC_GYRO_MODE 0x05
#define AMG_MODE 0x07
#define IMU_MODE 0x0c

//Power mode setting
#define PWR_MODE_ADDR 0x3e
#define NORMAL_MODE 0x00
#define LOW_MODE 0x01
#define SUSPEND_MODE 0x02

//system trigger address
#define SYS_TRIGGER_ADDR 0x3f

//Status registers
#define CHIP_ID_ADDR 0x00
#define SYS_CLK_STAT 0x38


//加速度アドレス
#define ACC_DATA_X_LSB 0x08
#define ACC_DATA_X_MSB 0x09
#define ACC_DATA_Y_LSB 0x0a
#define ACC_DATA_Y_MSB 0x0b
#define ACC_DATA_Z_LSB 0x0c
#define ACC_DATA_Z_MSB 0x0d
//角速度アドレス
#define GYR_DATA_X_LSB 0x14
#define GYR_DATA_X_MSB 0x15
#define GYR_DATA_Y_LSB 0x16
#define GYR_DATA_Y_MSB 0x17
#define GYR_DATA_Z_LSB 0x18
#define GYR_DATA_Z_MSB 0x19

//クォータニオン(姿勢）
#define QUA_DATA_W_LSB 0x20
#define QUA_DATA_W_MSB 0x21
#define QUA_DATA_X_LSB 0x22
#define QUA_DATA_X_MSB 0x23
#define QUA_DATA_Y_LSB 0x24
#define QUA_DATA_Y_MSB 0x25
#define QUA_DATA_Z_LSB 0x26
#define QUA_DATA_Z_MSB 0x27

#define ENABLE 0x3//BUS_SPEED:高速(400kbps),ENABLE:有効
#define DISABLE 0x0

#define MAX_BUFFER_SIZE 32

#define TRUE 1
#define FALSE 0

#define DEBUG_SERIAL

typedef uint8_t u8;//関数の定義
u8 TFR_CMD(u8 STA,u8 STO,u8 AD,u8 RW_D);
u8 IMU_read(u8 addr);
u8 IMU_write(u8 addr,u8 data);
int IMU_init(void);
void setExtCrystalUse(u8 usextal);

#endif /* IMU_I2C_H_ */
