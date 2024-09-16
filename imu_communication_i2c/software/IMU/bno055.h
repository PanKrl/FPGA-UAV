/*
 * bno055.h
 *
 *  Created on: Jun 17, 2024
 *      Author: ironb
 */

#ifndef BNO055_H_
#define BNO055_H_

#include <stdint.h>

#define BNO055_I2C_ADDR1                 (0x28)
#define BNO055_CHIP_ID                   (0xA0)
#define BNO055_SUCCESS                   (0)
#define BNO055_ERROR                     (-1)

#define BNO055_INIT_VALUE                (0)
#define BNO055_GEN_READ_WRITE_LENGTH     (1)

#define BNO055_CHIP_ID_REG               (0x00)
#define BNO055_QUA_DATA_W_LSB_REG        (0x20)
#define BNO055_QUA_DATA_W_MSB_REG        (0x21)
#define BNO055_QUA_DATA_X_LSB_REG        (0x22)
#define BNO055_QUA_DATA_X_MSB_REG        (0x23)
#define BNO055_QUA_DATA_Y_LSB_REG        (0x24)
#define BNO055_QUA_DATA_Y_MSB_REG        (0x25)
#define BNO055_QUA_DATA_Z_LSB_REG        (0x26)
#define BNO055_QUA_DATA_Z_MSB_REG        (0x27)

typedef int8_t (*BNO055_WR_FUNC_PTR)(uint8_t, uint8_t, uint8_t *, uint8_t);
typedef int8_t (*BNO055_RD_FUNC_PTR)(uint8_t, uint8_t, uint8_t *, uint8_t);
typedef void (*delay_msec)(uint32_t);

struct bno055_t {
    uint8_t chip_id;
    uint8_t dev_addr;
    BNO055_WR_FUNC_PTR bus_write;
    BNO055_RD_FUNC_PTR bus_read;
    delay_msec delay_msec;
};

int8_t bno055_init(struct bno055_t *bno055);
int8_t bno055_read_quaternion_wxyz(struct bno055_t *bno055, int16_t *w, int16_t *x, int16_t *y, int16_t *z);


#endif /* BNO055_H_ */
