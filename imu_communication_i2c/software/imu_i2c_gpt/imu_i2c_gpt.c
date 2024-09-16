#include <stdio.h>
#include <unistd.h>
#include <stdint.h>
#include "system.h"
#include "altera_avalon_i2c.h"
#include "altera_avalon_i2c_regs.h"
#include "alt_types.h"

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


ALT_AVALON_I2C_DEV_t*i2c_dev;

// Function to read a single byte from the BNO055 sensor
alt_u8 bno055_read_byte(ALT_AVALON_I2C_DEV_t*i2c_dev, alt_u8 reg_addr) {
    alt_u8 data;
    alt_avalon_i2c_master_tx(i2c_dev,&reg_addr,1,ALT_AVALON_I2C_NO_INTERRUPTS);
    alt_avalon_i2c_master_rx(i2c_dev,&data,1,ALT_AVALON_I2C_NO_INTERRUPTS);
    return data;
}

alt_u8 read_byte(alt_u8 addr){
	return bno055_read_byte(i2c_dev,addr);
}



alt_u8 bno055_write_byte(ALT_AVALON_I2C_DEV_t*i2c_dev, alt_u8 reg_addr,alt_u8 data) {
    alt_u8 status;
    alt_avalon_i2c_master_tx(i2c_dev,&reg_addr,1,ALT_AVALON_I2C_NO_INTERRUPTS);
    alt_avalon_i2c_master_tx(i2c_dev,&data,1,ALT_AVALON_I2C_NO_INTERRUPTS);

    alt_avalon_i2c_master_rx(i2c_dev,&status,1,ALT_AVALON_I2C_NO_INTERRUPTS);
    return status;
}

alt_u8 write_byte(alt_u8 addr,alt_u8 data){
	return bno055_write_byte(i2c_dev,addr,data);
}

alt_u8 IMU_init(void){
    // Initialize I2C
    i2c_dev =alt_avalon_i2c_open(I2C_NAME);
    if (i2c_dev == NULL) {
        printf("Error: Could not open I2C device.\n");
        return 1;
    }
    alt_avalon_i2c_master_target_set(i2c_dev,BNO055_ADDR);//set device address

	int timeout=850;
		while(timeout>0){
			if(IMU_init){
				break;
			}
			usleep(10);//retry!
			timeout-=10;
		}
		if(timeout<=0)
			return FALSE;

		alt_u8 chip_id=read_byte(CHIP_ID_ADDR);
		if(chip_id!=0xa0){
			usleep(1000000);//hold on for boot
			chip_id=read_byte(CHIP_ID_ADDR);
	#ifdef DEBUG_SERIAL
			printf("chip_id=0x%x\n",chip_id);
	#endif
			if(chip_id!=0xa0){
			return FALSE;//still not
			}
		}
		write_byte(OPR_MODE_ADDR,CONFIG_MODE);//operation mode>configuration mode
		write_byte(SYS_TRIGGER_ADDR,0x20);//
		usleep(30000);
		while(read_byte(CHIP_ID_ADDR)!=0xa0){
			usleep(10000);
		}
		usleep(50000);
		write_byte(PWR_MODE_ADDR,NORMAL_MODE);//power mode>normal mode
		write_byte(PAGE_ID_ADDR,0);//page id>0
		write_byte(SYS_TRIGGER_ADDR,0x0);
		usleep(10000);
		write_byte(OPR_MODE_ADDR,IMU_MODE);//operation mode>IMU mode
		usleep(20000);

		return TRUE;
}

int main() {
	printf("I2C_START\n");
	IMU_init();

	alt_u8 quat_w,quat_x,quat_y,quat_z;
    while(1){
		quat_w=read_byte(QUA_DATA_W_LSB)|(read_byte(QUA_DATA_W_MSB)<<8);
//		quat_x=read_byte(QUA_DATA_X_LSB)|(read_byte(QUA_DATA_X_MSB)<<8);
//		quat_y=read_byte(QUA_DATA_Y_LSB)|(read_byte(QUA_DATA_Y_MSB)<<8);
//		quat_z=read_byte(QUA_DATA_Z_LSB)|(read_byte(QUA_DATA_Z_MSB)<<8);

        printf("quat_w=%04d ",quat_w);
//        printf("quat_x=%04d ",quat_x);
//        printf("quat_y=%04d ",quat_y);
//        printf("quat_z=%04d ",quat_z);
        printf("\n");
    }

    return 0;
}
