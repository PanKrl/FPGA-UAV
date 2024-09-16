/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'NIOSII' in SOPC Builder design 'nios_security'
 * SOPC Builder design path: ../../nios_security.sopcinfo
 *
 * Generated: Mon Dec 04 17:41:02 GMT+09:00 2023
 */

/*
 * DO NOT MODIFY THIS FILE
 *
 * Changing this file will have subtle consequences
 * which will almost certainly lead to a nonfunctioning
 * system. If you do modify this file, be aware that your
 * changes will be overwritten and lost when this file
 * is generated again.
 *
 * DO NOT MODIFY THIS FILE
 */

/*
 * License Agreement
 *
 * Copyright (c) 2008
 * Altera Corporation, San Jose, California, USA.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 *
 * This agreement shall be governed in all respects by the laws of the State
 * of California and by the laws of the United States of America.
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/* Include definitions from linker script generator */
#include "linker.h"


/*
 * CPU configuration
 *
 */

#define ALT_CPU_ARCHITECTURE "altera_nios2_gen2"
#define ALT_CPU_BIG_ENDIAN 0
#define ALT_CPU_BREAK_ADDR 0x00040820
#define ALT_CPU_CPU_ARCH_NIOS2_R1
#define ALT_CPU_CPU_FREQ 50000000u
#define ALT_CPU_CPU_ID_SIZE 1
#define ALT_CPU_CPU_ID_VALUE 0x00000000
#define ALT_CPU_CPU_IMPLEMENTATION "tiny"
#define ALT_CPU_DATA_ADDR_WIDTH 0x13
#define ALT_CPU_DCACHE_LINE_SIZE 0
#define ALT_CPU_DCACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_DCACHE_SIZE 0
#define ALT_CPU_EXCEPTION_ADDR 0x00020020
#define ALT_CPU_FLASH_ACCELERATOR_LINES 0
#define ALT_CPU_FLASH_ACCELERATOR_LINE_SIZE 0
#define ALT_CPU_FLUSHDA_SUPPORTED
#define ALT_CPU_FREQ 50000000
#define ALT_CPU_HARDWARE_DIVIDE_PRESENT 0
#define ALT_CPU_HARDWARE_MULTIPLY_PRESENT 0
#define ALT_CPU_HARDWARE_MULX_PRESENT 0
#define ALT_CPU_HAS_DEBUG_CORE 1
#define ALT_CPU_HAS_DEBUG_STUB
#define ALT_CPU_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define ALT_CPU_HAS_JMPI_INSTRUCTION
#define ALT_CPU_ICACHE_LINE_SIZE 0
#define ALT_CPU_ICACHE_LINE_SIZE_LOG2 0
#define ALT_CPU_ICACHE_SIZE 0
#define ALT_CPU_INST_ADDR_WIDTH 0x13
#define ALT_CPU_NAME "NIOSII"
#define ALT_CPU_OCI_VERSION 1
#define ALT_CPU_RESET_ADDR 0x00020000


/*
 * CPU configuration (with legacy prefix - don't use these anymore)
 *
 */

#define NIOS2_BIG_ENDIAN 0
#define NIOS2_BREAK_ADDR 0x00040820
#define NIOS2_CPU_ARCH_NIOS2_R1
#define NIOS2_CPU_FREQ 50000000u
#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0x00000000
#define NIOS2_CPU_IMPLEMENTATION "tiny"
#define NIOS2_DATA_ADDR_WIDTH 0x13
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_EXCEPTION_ADDR 0x00020020
#define NIOS2_FLASH_ACCELERATOR_LINES 0
#define NIOS2_FLASH_ACCELERATOR_LINE_SIZE 0
#define NIOS2_FLUSHDA_SUPPORTED
#define NIOS2_HARDWARE_DIVIDE_PRESENT 0
#define NIOS2_HARDWARE_MULTIPLY_PRESENT 0
#define NIOS2_HARDWARE_MULX_PRESENT 0
#define NIOS2_HAS_DEBUG_CORE 1
#define NIOS2_HAS_DEBUG_STUB
#define NIOS2_HAS_ILLEGAL_INSTRUCTION_EXCEPTION
#define NIOS2_HAS_JMPI_INSTRUCTION
#define NIOS2_ICACHE_LINE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE_LOG2 0
#define NIOS2_ICACHE_SIZE 0
#define NIOS2_INST_ADDR_WIDTH 0x13
#define NIOS2_OCI_VERSION 1
#define NIOS2_RESET_ADDR 0x00020000


/*
 * DUTY_1 configuration
 *
 */

#define ALT_MODULE_CLASS_DUTY_1 altera_avalon_pio
#define DUTY_1_BASE 0x41140
#define DUTY_1_BIT_CLEARING_EDGE_REGISTER 0
#define DUTY_1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DUTY_1_CAPTURE 0
#define DUTY_1_DATA_WIDTH 32
#define DUTY_1_DO_TEST_BENCH_WIRING 0
#define DUTY_1_DRIVEN_SIM_VALUE 0
#define DUTY_1_EDGE_TYPE "NONE"
#define DUTY_1_FREQ 50000000
#define DUTY_1_HAS_IN 0
#define DUTY_1_HAS_OUT 1
#define DUTY_1_HAS_TRI 0
#define DUTY_1_IRQ -1
#define DUTY_1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DUTY_1_IRQ_TYPE "NONE"
#define DUTY_1_NAME "/dev/DUTY_1"
#define DUTY_1_RESET_VALUE 0
#define DUTY_1_SPAN 16
#define DUTY_1_TYPE "altera_avalon_pio"


/*
 * DUTY_2 configuration
 *
 */

#define ALT_MODULE_CLASS_DUTY_2 altera_avalon_pio
#define DUTY_2_BASE 0x41110
#define DUTY_2_BIT_CLEARING_EDGE_REGISTER 0
#define DUTY_2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DUTY_2_CAPTURE 0
#define DUTY_2_DATA_WIDTH 32
#define DUTY_2_DO_TEST_BENCH_WIRING 0
#define DUTY_2_DRIVEN_SIM_VALUE 0
#define DUTY_2_EDGE_TYPE "NONE"
#define DUTY_2_FREQ 50000000
#define DUTY_2_HAS_IN 0
#define DUTY_2_HAS_OUT 1
#define DUTY_2_HAS_TRI 0
#define DUTY_2_IRQ -1
#define DUTY_2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DUTY_2_IRQ_TYPE "NONE"
#define DUTY_2_NAME "/dev/DUTY_2"
#define DUTY_2_RESET_VALUE 0
#define DUTY_2_SPAN 16
#define DUTY_2_TYPE "altera_avalon_pio"


/*
 * DUTY_3 configuration
 *
 */

#define ALT_MODULE_CLASS_DUTY_3 altera_avalon_pio
#define DUTY_3_BASE 0x41120
#define DUTY_3_BIT_CLEARING_EDGE_REGISTER 0
#define DUTY_3_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DUTY_3_CAPTURE 0
#define DUTY_3_DATA_WIDTH 32
#define DUTY_3_DO_TEST_BENCH_WIRING 0
#define DUTY_3_DRIVEN_SIM_VALUE 0
#define DUTY_3_EDGE_TYPE "NONE"
#define DUTY_3_FREQ 50000000
#define DUTY_3_HAS_IN 0
#define DUTY_3_HAS_OUT 1
#define DUTY_3_HAS_TRI 0
#define DUTY_3_IRQ -1
#define DUTY_3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DUTY_3_IRQ_TYPE "NONE"
#define DUTY_3_NAME "/dev/DUTY_3"
#define DUTY_3_RESET_VALUE 0
#define DUTY_3_SPAN 16
#define DUTY_3_TYPE "altera_avalon_pio"


/*
 * DUTY_4 configuration
 *
 */

#define ALT_MODULE_CLASS_DUTY_4 altera_avalon_pio
#define DUTY_4_BASE 0x41130
#define DUTY_4_BIT_CLEARING_EDGE_REGISTER 0
#define DUTY_4_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DUTY_4_CAPTURE 0
#define DUTY_4_DATA_WIDTH 32
#define DUTY_4_DO_TEST_BENCH_WIRING 0
#define DUTY_4_DRIVEN_SIM_VALUE 0
#define DUTY_4_EDGE_TYPE "NONE"
#define DUTY_4_FREQ 50000000
#define DUTY_4_HAS_IN 0
#define DUTY_4_HAS_OUT 1
#define DUTY_4_HAS_TRI 0
#define DUTY_4_IRQ -1
#define DUTY_4_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DUTY_4_IRQ_TYPE "NONE"
#define DUTY_4_NAME "/dev/DUTY_4"
#define DUTY_4_RESET_VALUE 0
#define DUTY_4_SPAN 16
#define DUTY_4_TYPE "altera_avalon_pio"


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_I2C
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_UART
#define __ALTERA_NIOS2_GEN2


/*
 * I2C configuration
 *
 */

#define ALT_MODULE_CLASS_I2C altera_avalon_i2c
#define I2C_BASE 0x41040
#define I2C_FIFO_DEPTH 4
#define I2C_FREQ 50000000
#define I2C_IRQ 1
#define I2C_IRQ_INTERRUPT_CONTROLLER_ID 0
#define I2C_NAME "/dev/I2C"
#define I2C_SPAN 64
#define I2C_TYPE "altera_avalon_i2c"
#define I2C_USE_AV_ST 0


/*
 * ID configuration
 *
 */

#define ALT_MODULE_CLASS_ID altera_avalon_sysid_qsys
#define ID_BASE 0x41170
#define ID_ID 0
#define ID_IRQ -1
#define ID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ID_NAME "/dev/ID"
#define ID_SPAN 8
#define ID_TIMESTAMP 1701678937
#define ID_TYPE "altera_avalon_sysid_qsys"


/*
 * JTAG configuration
 *
 */

#define ALT_MODULE_CLASS_JTAG altera_avalon_jtag_uart
#define JTAG_BASE 0x41178
#define JTAG_IRQ 0
#define JTAG_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_NAME "/dev/JTAG"
#define JTAG_READ_DEPTH 64
#define JTAG_READ_THRESHOLD 8
#define JTAG_SPAN 8
#define JTAG_TYPE "altera_avalon_jtag_uart"
#define JTAG_WRITE_DEPTH 64
#define JTAG_WRITE_THRESHOLD 8


/*
 * LED configuration
 *
 */

#define ALT_MODULE_CLASS_LED altera_avalon_pio
#define LED_BASE 0x41150
#define LED_BIT_CLEARING_EDGE_REGISTER 0
#define LED_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED_CAPTURE 0
#define LED_DATA_WIDTH 32
#define LED_DO_TEST_BENCH_WIRING 0
#define LED_DRIVEN_SIM_VALUE 0
#define LED_EDGE_TYPE "NONE"
#define LED_FREQ 50000000
#define LED_HAS_IN 0
#define LED_HAS_OUT 1
#define LED_HAS_TRI 0
#define LED_IRQ -1
#define LED_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED_IRQ_TYPE "NONE"
#define LED_NAME "/dev/LED"
#define LED_RESET_VALUE 0
#define LED_SPAN 16
#define LED_TYPE "altera_avalon_pio"


/*
 * PERIOD configuration
 *
 */

#define ALT_MODULE_CLASS_PERIOD altera_avalon_pio
#define PERIOD_BASE 0x41100
#define PERIOD_BIT_CLEARING_EDGE_REGISTER 0
#define PERIOD_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PERIOD_CAPTURE 0
#define PERIOD_DATA_WIDTH 32
#define PERIOD_DO_TEST_BENCH_WIRING 0
#define PERIOD_DRIVEN_SIM_VALUE 0
#define PERIOD_EDGE_TYPE "NONE"
#define PERIOD_FREQ 50000000
#define PERIOD_HAS_IN 0
#define PERIOD_HAS_OUT 1
#define PERIOD_HAS_TRI 0
#define PERIOD_IRQ -1
#define PERIOD_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PERIOD_IRQ_TYPE "NONE"
#define PERIOD_NAME "/dev/PERIOD"
#define PERIOD_RESET_VALUE 0
#define PERIOD_SPAN 16
#define PERIOD_TYPE "altera_avalon_pio"


/*
 * RAM configuration
 *
 */

#define ALT_MODULE_CLASS_RAM altera_avalon_onchip_memory2
#define RAM_ALLOW_IN_SYSTEM_MEMORY_CONTENT_EDITOR 0
#define RAM_ALLOW_MRAM_SIM_CONTENTS_ONLY_FILE 0
#define RAM_BASE 0x20000
#define RAM_CONTENTS_INFO ""
#define RAM_DUAL_PORT 0
#define RAM_GUI_RAM_BLOCK_TYPE "AUTO"
#define RAM_INIT_CONTENTS_FILE "nios_security_RAM"
#define RAM_INIT_MEM_CONTENT 0
#define RAM_INSTANCE_ID "NONE"
#define RAM_IRQ -1
#define RAM_IRQ_INTERRUPT_CONTROLLER_ID -1
#define RAM_NAME "/dev/RAM"
#define RAM_NON_DEFAULT_INIT_FILE_ENABLED 0
#define RAM_RAM_BLOCK_TYPE "AUTO"
#define RAM_READ_DURING_WRITE_MODE "DONT_CARE"
#define RAM_SINGLE_CLOCK_OP 0
#define RAM_SIZE_MULTIPLE 1
#define RAM_SIZE_VALUE 131072
#define RAM_SPAN 131072
#define RAM_TYPE "altera_avalon_onchip_memory2"
#define RAM_WRITABLE 1


/*
 * STOP configuration
 *
 */

#define ALT_MODULE_CLASS_STOP altera_avalon_pio
#define STOP_BASE 0x41160
#define STOP_BIT_CLEARING_EDGE_REGISTER 0
#define STOP_BIT_MODIFYING_OUTPUT_REGISTER 0
#define STOP_CAPTURE 0
#define STOP_DATA_WIDTH 32
#define STOP_DO_TEST_BENCH_WIRING 0
#define STOP_DRIVEN_SIM_VALUE 0
#define STOP_EDGE_TYPE "NONE"
#define STOP_FREQ 50000000
#define STOP_HAS_IN 0
#define STOP_HAS_OUT 1
#define STOP_HAS_TRI 0
#define STOP_IRQ -1
#define STOP_IRQ_INTERRUPT_CONTROLLER_ID -1
#define STOP_IRQ_TYPE "NONE"
#define STOP_NAME "/dev/STOP"
#define STOP_RESET_VALUE 0
#define STOP_SPAN 16
#define STOP_TYPE "altera_avalon_pio"


/*
 * System configuration
 *
 */

#define ALT_DEVICE_FAMILY "MAX 10"
#define ALT_ENHANCED_INTERRUPT_API_PRESENT
#define ALT_IRQ_BASE NULL
#define ALT_LOG_PORT "/dev/null"
#define ALT_LOG_PORT_BASE 0x0
#define ALT_LOG_PORT_DEV null
#define ALT_LOG_PORT_TYPE ""
#define ALT_NUM_EXTERNAL_INTERRUPT_CONTROLLERS 0
#define ALT_NUM_INTERNAL_INTERRUPT_CONTROLLERS 1
#define ALT_NUM_INTERRUPT_CONTROLLERS 1
#define ALT_STDERR "/dev/JTAG"
#define ALT_STDERR_BASE 0x41178
#define ALT_STDERR_DEV JTAG
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/JTAG"
#define ALT_STDIN_BASE 0x41178
#define ALT_STDIN_DEV JTAG
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/JTAG"
#define ALT_STDOUT_BASE 0x41178
#define ALT_STDOUT_DEV JTAG
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "nios_security"


/*
 * UART1 configuration
 *
 */

#define ALT_MODULE_CLASS_UART1 altera_avalon_uart
#define UART1_BASE 0x410e0
#define UART1_BAUD 115200
#define UART1_DATA_BITS 8
#define UART1_FIXED_BAUD 0
#define UART1_FREQ 50000000
#define UART1_IRQ 2
#define UART1_IRQ_INTERRUPT_CONTROLLER_ID 0
#define UART1_NAME "/dev/UART1"
#define UART1_PARITY 'E'
#define UART1_SIM_CHAR_STREAM ""
#define UART1_SIM_TRUE_BAUD 0
#define UART1_SPAN 32
#define UART1_STOP_BITS 2
#define UART1_SYNC_REG_DEPTH 2
#define UART1_TYPE "altera_avalon_uart"
#define UART1_USE_CTS_RTS 0
#define UART1_USE_EOP_REGISTER 0


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none

#endif /* __SYSTEM_H_ */
