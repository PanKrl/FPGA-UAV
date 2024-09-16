/*
 * imu_i2c.c
 *
 *  Created on: 2023/11/16
 *      Author: space
 */
#include "imu_i2c.h"

u8 TFR_CMD(u8 STA,u8 STO,u8 AD,u8 RW_D){//コマンドの生成
	u8 cmd=((STA<<9)|(STO<<8)|(AD<<1)|(RW_D));//()で囲ってみた 11/21
	return cmd;
}


u8 IMU_read(u8 addr){
		u8 rd_data;

		IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE,BNO055_ADDR);
		usleep(100);
		IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE,(STOP_BIT|addr));
		usleep(100);
		IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE,BNO055_ADDR);

		for(int i=0;i<10000;i++)
		rd_data=IORD_ALT_AVALON_I2C_RX_DATA(I2C_BASE);

		IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE,STOP_BIT);

		return rd_data;
}

u8 IMU_write(u8 addr,u8 data){
	IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE,TFR_CMD(0x1,0x0,BNO055_ADDR,0x0));
	IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE,addr);
	IOWR_ALT_AVALON_I2C_TFR_CMD(I2C_BASE,(STOP_BIT|data));
	return 1;
}


int IMU_init(void){//IMU通信を始める
	IOWR_ALT_AVALON_I2C_CTRL(I2C_BASE,ENABLE);//I2C enable
	int timeout=850;
//	while(timeout>0){
//		if(IMU_init()){
//			break;
//		}
//		usleep(10);//retry!
//		timeout-=10;
//	}
//	if(timeout<=0){
//#ifdef DEBUG_SERIAL
//		printf("Fail init\n");
//#endif
//		return FALSE;
//	}
	printf("I2C Start!\n");
	u8 chip_id=IMU_read(CHIP_ID_ADDR);
#ifdef DEBUG_SERIAL
		printf("chip_id=%04x\n",chip_id);
#endif
	if(chip_id!=0xa0){
		usleep(1000000);//hold on for boot
		chip_id=IMU_read(CHIP_ID_ADDR);

		if(chip_id!=0xa0){
#ifdef DEBUG_SERIAL
			printf("Error: Invalid Chip ID for BNO055 sensor.\n");
#endif
		return FALSE;//still not
		}
	}
	IMU_write(OPR_MODE_ADDR,CONFIG_MODE);//operation mode>configuration mode
	IMU_write(SYS_TRIGGER_ADDR,0x20);//
	usleep(30000);
	while(IMU_read(CHIP_ID_ADDR)!=0xa0){
		usleep(10000);
		timeout-=10;
		if(timeout<=0){
//			return FALSE;
			break;break;
		}

	}
	usleep(50000);
	IMU_write(PWR_MODE_ADDR,NORMAL_MODE);//power mode>normal mode
	IMU_write(PAGE_ID_ADDR,0);//page id>0
	IMU_write(SYS_TRIGGER_ADDR,0x0);
	usleep(10000);
	IMU_write(OPR_MODE_ADDR,IMU_MODE);//operation mode>IMU mode
	usleep(20000);

	return TRUE;
}

void setExtCrystalUse(u8 usextal){//use external crystal
	IMU_write(OPR_MODE_ADDR,CONFIG_MODE);//operation mode>configuration mode
	usleep(25000);
	IMU_write(PAGE_ID_ADDR,0);//page id>0
	if(usextal){
		IMU_write(SYS_TRIGGER_ADDR,0x80);
	}else{
		IMU_write(SYS_TRIGGER_ADDR,0x0);
	}
	usleep(10000);
	IMU_write(OPR_MODE_ADDR,IMU_MODE);//operation mode>configuration mode
	usleep(20000);

}



