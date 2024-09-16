//IMU_communication

#include "imu_i2c.h"

int main(){

	u8 quat_w,quat_x,quat_y,quat_z;

    IMU_init();
    setExtCrystalUse(TRUE);

	while(1){
		quat_w=IMU_read(QUA_DATA_W_LSB)|(IMU_read(QUA_DATA_W_MSB)<<8);
		quat_x=IMU_read(QUA_DATA_X_LSB)|(IMU_read(QUA_DATA_X_MSB)<<8);
		quat_y=IMU_read(QUA_DATA_Y_LSB)|(IMU_read(QUA_DATA_Y_MSB)<<8);
		quat_z=IMU_read(QUA_DATA_Z_LSB)|(IMU_read(QUA_DATA_Z_MSB)<<8);

        printf("quat_w=%04x ",quat_w);
        printf("quat_x=%04x ",quat_x);
        printf("quat_y=%04x ",quat_y);
        printf("quat_z=%04x ",quat_z);
        printf("\n");
        usleep(100);

	}

return 0;

}

