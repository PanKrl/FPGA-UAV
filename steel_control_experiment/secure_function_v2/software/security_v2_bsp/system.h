/*
 * system.h - SOPC Builder system and BSP software package information
 *
 * Machine generated for CPU 'NIOSII' in SOPC Builder design 'nios_security'
 * SOPC Builder design path: ../../nios_security.sopcinfo
 *
 * Generated: Tue Jan 16 14:51:14 GMT+09:00 2024
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
 * DUTY configuration
 *
 */

#define ALT_MODULE_CLASS_DUTY altera_avalon_pio
#define DUTY_BASE 0x41110
#define DUTY_BIT_CLEARING_EDGE_REGISTER 0
#define DUTY_BIT_MODIFYING_OUTPUT_REGISTER 0
#define DUTY_CAPTURE 0
#define DUTY_DATA_WIDTH 32
#define DUTY_DO_TEST_BENCH_WIRING 0
#define DUTY_DRIVEN_SIM_VALUE 0
#define DUTY_EDGE_TYPE "NONE"
#define DUTY_FREQ 50000000
#define DUTY_HAS_IN 0
#define DUTY_HAS_OUT 1
#define DUTY_HAS_TRI 0
#define DUTY_IRQ -1
#define DUTY_IRQ_INTERRUPT_CONTROLLER_ID -1
#define DUTY_IRQ_TYPE "NONE"
#define DUTY_NAME "/dev/DUTY"
#define DUTY_RESET_VALUE 0
#define DUTY_SPAN 16
#define DUTY_TYPE "altera_avalon_pio"


/*
 * Define for each module class mastered by the CPU
 *
 */

#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_ONCHIP_MEMORY2
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_SYSID_QSYS
#define __ALTERA_AVALON_UART
#define __ALTERA_NIOS2_GEN2


/*
 * ID configuration
 *
 */

#define ALT_MODULE_CLASS_ID altera_avalon_sysid_qsys
#define ID_BASE 0x41140
#define ID_ID 0
#define ID_IRQ -1
#define ID_IRQ_INTERRUPT_CONTROLLER_ID -1
#define ID_NAME "/dev/ID"
#define ID_SPAN 8
#define ID_TIMESTAMP 1705384165
#define ID_TYPE "altera_avalon_sysid_qsys"


/*
 * JTAG configuration
 *
 */

#define ALT_MODULE_CLASS_JTAG altera_avalon_jtag_uart
#define JTAG_BASE 0x41148
#define JTAG_IRQ 1
#define JTAG_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_NAME "/dev/JTAG"
#define JTAG_READ_DEPTH 64
#define JTAG_READ_THRESHOLD 8
#define JTAG_SPAN 8
#define JTAG_TYPE "altera_avalon_jtag_uart"
#define JTAG_WRITE_DEPTH 64
#define JTAG_WRITE_THRESHOLD 8


/*
 * LED0 configuration
 *
 */

#define ALT_MODULE_CLASS_LED0 altera_avalon_pio
#define LED0_BASE 0x41120
#define LED0_BIT_CLEARING_EDGE_REGISTER 0
#define LED0_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED0_CAPTURE 0
#define LED0_DATA_WIDTH 32
#define LED0_DO_TEST_BENCH_WIRING 0
#define LED0_DRIVEN_SIM_VALUE 0
#define LED0_EDGE_TYPE "NONE"
#define LED0_FREQ 50000000
#define LED0_HAS_IN 0
#define LED0_HAS_OUT 1
#define LED0_HAS_TRI 0
#define LED0_IRQ -1
#define LED0_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED0_IRQ_TYPE "NONE"
#define LED0_NAME "/dev/LED0"
#define LED0_RESET_VALUE 0
#define LED0_SPAN 16
#define LED0_TYPE "altera_avalon_pio"


/*
 * LED1 configuration
 *
 */

#define ALT_MODULE_CLASS_LED1 altera_avalon_pio
#define LED1_BASE 0x410c0
#define LED1_BIT_CLEARING_EDGE_REGISTER 0
#define LED1_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED1_CAPTURE 0
#define LED1_DATA_WIDTH 1
#define LED1_DO_TEST_BENCH_WIRING 0
#define LED1_DRIVEN_SIM_VALUE 0
#define LED1_EDGE_TYPE "NONE"
#define LED1_FREQ 50000000
#define LED1_HAS_IN 0
#define LED1_HAS_OUT 1
#define LED1_HAS_TRI 0
#define LED1_IRQ -1
#define LED1_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED1_IRQ_TYPE "NONE"
#define LED1_NAME "/dev/LED1"
#define LED1_RESET_VALUE 0
#define LED1_SPAN 16
#define LED1_TYPE "altera_avalon_pio"


/*
 * LED2 configuration
 *
 */

#define ALT_MODULE_CLASS_LED2 altera_avalon_pio
#define LED2_BASE 0x41060
#define LED2_BIT_CLEARING_EDGE_REGISTER 0
#define LED2_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED2_CAPTURE 0
#define LED2_DATA_WIDTH 1
#define LED2_DO_TEST_BENCH_WIRING 0
#define LED2_DRIVEN_SIM_VALUE 0
#define LED2_EDGE_TYPE "NONE"
#define LED2_FREQ 50000000
#define LED2_HAS_IN 0
#define LED2_HAS_OUT 1
#define LED2_HAS_TRI 0
#define LED2_IRQ -1
#define LED2_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED2_IRQ_TYPE "NONE"
#define LED2_NAME "/dev/LED2"
#define LED2_RESET_VALUE 0
#define LED2_SPAN 16
#define LED2_TYPE "altera_avalon_pio"


/*
 * LED3 configuration
 *
 */

#define ALT_MODULE_CLASS_LED3 altera_avalon_pio
#define LED3_BASE 0x41070
#define LED3_BIT_CLEARING_EDGE_REGISTER 0
#define LED3_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED3_CAPTURE 0
#define LED3_DATA_WIDTH 1
#define LED3_DO_TEST_BENCH_WIRING 0
#define LED3_DRIVEN_SIM_VALUE 0
#define LED3_EDGE_TYPE "NONE"
#define LED3_FREQ 50000000
#define LED3_HAS_IN 0
#define LED3_HAS_OUT 1
#define LED3_HAS_TRI 0
#define LED3_IRQ -1
#define LED3_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED3_IRQ_TYPE "NONE"
#define LED3_NAME "/dev/LED3"
#define LED3_RESET_VALUE 0
#define LED3_SPAN 16
#define LED3_TYPE "altera_avalon_pio"


/*
 * LED4 configuration
 *
 */

#define ALT_MODULE_CLASS_LED4 altera_avalon_pio
#define LED4_BASE 0x41080
#define LED4_BIT_CLEARING_EDGE_REGISTER 0
#define LED4_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED4_CAPTURE 0
#define LED4_DATA_WIDTH 1
#define LED4_DO_TEST_BENCH_WIRING 0
#define LED4_DRIVEN_SIM_VALUE 0
#define LED4_EDGE_TYPE "NONE"
#define LED4_FREQ 50000000
#define LED4_HAS_IN 0
#define LED4_HAS_OUT 1
#define LED4_HAS_TRI 0
#define LED4_IRQ -1
#define LED4_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED4_IRQ_TYPE "NONE"
#define LED4_NAME "/dev/LED4"
#define LED4_RESET_VALUE 0
#define LED4_SPAN 16
#define LED4_TYPE "altera_avalon_pio"


/*
 * LED5 configuration
 *
 */

#define ALT_MODULE_CLASS_LED5 altera_avalon_pio
#define LED5_BASE 0x41090
#define LED5_BIT_CLEARING_EDGE_REGISTER 0
#define LED5_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED5_CAPTURE 0
#define LED5_DATA_WIDTH 1
#define LED5_DO_TEST_BENCH_WIRING 0
#define LED5_DRIVEN_SIM_VALUE 0
#define LED5_EDGE_TYPE "NONE"
#define LED5_FREQ 50000000
#define LED5_HAS_IN 0
#define LED5_HAS_OUT 1
#define LED5_HAS_TRI 0
#define LED5_IRQ -1
#define LED5_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED5_IRQ_TYPE "NONE"
#define LED5_NAME "/dev/LED5"
#define LED5_RESET_VALUE 0
#define LED5_SPAN 16
#define LED5_TYPE "altera_avalon_pio"


/*
 * LED6 configuration
 *
 */

#define ALT_MODULE_CLASS_LED6 altera_avalon_pio
#define LED6_BASE 0x410a0
#define LED6_BIT_CLEARING_EDGE_REGISTER 0
#define LED6_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED6_CAPTURE 0
#define LED6_DATA_WIDTH 1
#define LED6_DO_TEST_BENCH_WIRING 0
#define LED6_DRIVEN_SIM_VALUE 0
#define LED6_EDGE_TYPE "NONE"
#define LED6_FREQ 50000000
#define LED6_HAS_IN 0
#define LED6_HAS_OUT 1
#define LED6_HAS_TRI 0
#define LED6_IRQ -1
#define LED6_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED6_IRQ_TYPE "NONE"
#define LED6_NAME "/dev/LED6"
#define LED6_RESET_VALUE 0
#define LED6_SPAN 16
#define LED6_TYPE "altera_avalon_pio"


/*
 * LED7 configuration
 *
 */

#define ALT_MODULE_CLASS_LED7 altera_avalon_pio
#define LED7_BASE 0x410b0
#define LED7_BIT_CLEARING_EDGE_REGISTER 0
#define LED7_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED7_CAPTURE 0
#define LED7_DATA_WIDTH 1
#define LED7_DO_TEST_BENCH_WIRING 0
#define LED7_DRIVEN_SIM_VALUE 0
#define LED7_EDGE_TYPE "NONE"
#define LED7_FREQ 50000000
#define LED7_HAS_IN 0
#define LED7_HAS_OUT 1
#define LED7_HAS_TRI 0
#define LED7_IRQ -1
#define LED7_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED7_IRQ_TYPE "NONE"
#define LED7_NAME "/dev/LED7"
#define LED7_RESET_VALUE 0
#define LED7_SPAN 16
#define LED7_TYPE "altera_avalon_pio"


/*
 * LED8 configuration
 *
 */

#define ALT_MODULE_CLASS_LED8 altera_avalon_pio
#define LED8_BASE 0x41050
#define LED8_BIT_CLEARING_EDGE_REGISTER 0
#define LED8_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED8_CAPTURE 0
#define LED8_DATA_WIDTH 1
#define LED8_DO_TEST_BENCH_WIRING 0
#define LED8_DRIVEN_SIM_VALUE 0
#define LED8_EDGE_TYPE "NONE"
#define LED8_FREQ 50000000
#define LED8_HAS_IN 0
#define LED8_HAS_OUT 1
#define LED8_HAS_TRI 0
#define LED8_IRQ -1
#define LED8_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED8_IRQ_TYPE "NONE"
#define LED8_NAME "/dev/LED8"
#define LED8_RESET_VALUE 0
#define LED8_SPAN 16
#define LED8_TYPE "altera_avalon_pio"


/*
 * LED9 configuration
 *
 */

#define ALT_MODULE_CLASS_LED9 altera_avalon_pio
#define LED9_BASE 0x41040
#define LED9_BIT_CLEARING_EDGE_REGISTER 0
#define LED9_BIT_MODIFYING_OUTPUT_REGISTER 0
#define LED9_CAPTURE 0
#define LED9_DATA_WIDTH 1
#define LED9_DO_TEST_BENCH_WIRING 0
#define LED9_DRIVEN_SIM_VALUE 0
#define LED9_EDGE_TYPE "NONE"
#define LED9_FREQ 50000000
#define LED9_HAS_IN 0
#define LED9_HAS_OUT 1
#define LED9_HAS_TRI 0
#define LED9_IRQ -1
#define LED9_IRQ_INTERRUPT_CONTROLLER_ID -1
#define LED9_IRQ_TYPE "NONE"
#define LED9_NAME "/dev/LED9"
#define LED9_RESET_VALUE 0
#define LED9_SPAN 16
#define LED9_TYPE "altera_avalon_pio"


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
 * PWM_IN configuration
 *
 */

#define ALT_MODULE_CLASS_PWM_IN altera_avalon_pio
#define PWM_IN_BASE 0x410e0
#define PWM_IN_BIT_CLEARING_EDGE_REGISTER 0
#define PWM_IN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PWM_IN_CAPTURE 0
#define PWM_IN_DATA_WIDTH 1
#define PWM_IN_DO_TEST_BENCH_WIRING 0
#define PWM_IN_DRIVEN_SIM_VALUE 0
#define PWM_IN_EDGE_TYPE "NONE"
#define PWM_IN_FREQ 50000000
#define PWM_IN_HAS_IN 1
#define PWM_IN_HAS_OUT 0
#define PWM_IN_HAS_TRI 0
#define PWM_IN_IRQ -1
#define PWM_IN_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PWM_IN_IRQ_TYPE "NONE"
#define PWM_IN_NAME "/dev/PWM_IN"
#define PWM_IN_RESET_VALUE 0
#define PWM_IN_SPAN 16
#define PWM_IN_TYPE "altera_avalon_pio"


/*
 * PWM_OUT configuration
 *
 */

#define ALT_MODULE_CLASS_PWM_OUT altera_avalon_pio
#define PWM_OUT_BASE 0x410d0
#define PWM_OUT_BIT_CLEARING_EDGE_REGISTER 0
#define PWM_OUT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define PWM_OUT_CAPTURE 0
#define PWM_OUT_DATA_WIDTH 1
#define PWM_OUT_DO_TEST_BENCH_WIRING 0
#define PWM_OUT_DRIVEN_SIM_VALUE 0
#define PWM_OUT_EDGE_TYPE "NONE"
#define PWM_OUT_FREQ 50000000
#define PWM_OUT_HAS_IN 0
#define PWM_OUT_HAS_OUT 1
#define PWM_OUT_HAS_TRI 0
#define PWM_OUT_IRQ -1
#define PWM_OUT_IRQ_INTERRUPT_CONTROLLER_ID -1
#define PWM_OUT_IRQ_TYPE "NONE"
#define PWM_OUT_NAME "/dev/PWM_OUT"
#define PWM_OUT_RESET_VALUE 0
#define PWM_OUT_SPAN 16
#define PWM_OUT_TYPE "altera_avalon_pio"


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
#define STOP_BASE 0x41130
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
 * SW configuration
 *
 */

#define ALT_MODULE_CLASS_SW altera_avalon_pio
#define SW_BASE 0x410f0
#define SW_BIT_CLEARING_EDGE_REGISTER 0
#define SW_BIT_MODIFYING_OUTPUT_REGISTER 0
#define SW_CAPTURE 0
#define SW_DATA_WIDTH 1
#define SW_DO_TEST_BENCH_WIRING 0
#define SW_DRIVEN_SIM_VALUE 0
#define SW_EDGE_TYPE "NONE"
#define SW_FREQ 50000000
#define SW_HAS_IN 1
#define SW_HAS_OUT 0
#define SW_HAS_TRI 0
#define SW_IRQ -1
#define SW_IRQ_INTERRUPT_CONTROLLER_ID -1
#define SW_IRQ_TYPE "NONE"
#define SW_NAME "/dev/SW"
#define SW_RESET_VALUE 0
#define SW_SPAN 16
#define SW_TYPE "altera_avalon_pio"


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
#define ALT_STDERR_BASE 0x41148
#define ALT_STDERR_DEV JTAG
#define ALT_STDERR_IS_JTAG_UART
#define ALT_STDERR_PRESENT
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN "/dev/JTAG"
#define ALT_STDIN_BASE 0x41148
#define ALT_STDIN_DEV JTAG
#define ALT_STDIN_IS_JTAG_UART
#define ALT_STDIN_PRESENT
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT "/dev/JTAG"
#define ALT_STDOUT_BASE 0x41148
#define ALT_STDOUT_DEV JTAG
#define ALT_STDOUT_IS_JTAG_UART
#define ALT_STDOUT_PRESENT
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_SYSTEM_NAME "nios_security"


/*
 * UART configuration
 *
 */

#define ALT_MODULE_CLASS_UART altera_avalon_uart
#define UART_BASE 0x41020
#define UART_BAUD 9600
#define UART_DATA_BITS 8
#define UART_FIXED_BAUD 1
#define UART_FREQ 50000000
#define UART_IRQ 0
#define UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define UART_NAME "/dev/UART"
#define UART_PARITY 'N'
#define UART_SIM_CHAR_STREAM ""
#define UART_SIM_TRUE_BAUD 0
#define UART_SPAN 32
#define UART_STOP_BITS 1
#define UART_SYNC_REG_DEPTH 2
#define UART_TYPE "altera_avalon_uart"
#define UART_USE_CTS_RTS 0
#define UART_USE_EOP_REGISTER 0


/*
 * hal configuration
 *
 */

#define ALT_INCLUDE_INSTRUCTION_RELATED_EXCEPTION_API
#define ALT_MAX_FD 32
#define ALT_SYS_CLK none
#define ALT_TIMESTAMP_CLK none

#endif /* __SYSTEM_H_ */
