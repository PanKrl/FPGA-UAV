/*
 * bno055.c
 *
 *  Created on: Jun 17, 2024
 *      Author: ironb
 */

#include "bno055.h"

int8_t bno055_init(struct bno055_t *bno055) {
    uint8_t data = 0;
    bno055->bus_read(bno055->dev_addr, BNO055_CHIP_ID_REG, &data, BNO055_GEN_READ_WRITE_LENGTH);
    bno055->chip_id = data;

    if (bno055->chip_id != BNO055_CHIP_ID) {
        return BNO055_ERROR;
    }

    // Additional initialization steps can be added here

    return BNO055_SUCCESS;
}

int8_t bno055_read_quaternion_wxyz(struct bno055_t *bno055, int16_t *w, int16_t *x, int16_t *y, int16_t *z) {
    uint8_t data[8];
    bno055->bus_read(bno055->dev_addr, BNO055_QUA_DATA_W_LSB_REG, data, 8);

    *w = (int16_t)((data[1] << 8) | data[0]);
    *x = (int16_t)((data[3] << 8) | data[2]);
    *y = (int16_t)((data[5] << 8) | data[4]);
    *z = (int16_t)((data[7] << 8) | data[6]);

    return BNO055_SUCCESS;
}

