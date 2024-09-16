//SBUS通信に成功2023/08/21

#include <stdio.h>
#include <stdlib.h>
#include "sys/alt_stdio.h"
#include "system.h"
#include <string.h>
#include "altera_avalon_pio_regs.h"
#include <altera_avalon_uart.h>
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include <math.h>
#include <io.h>
#include <unistd.h>

#define BAUD_DIVISOR 499
#define START_BYTE 0x0f
#define END_BYTE 0x00
#define interval 20000

#define CYCLE 125000// 一周期を2500μsにするよう定義（クロック50MHz)
#define DUTY_MAX 116500// Duty比の最大値
#define DUTY_MIN 47000// Duty比の最小値

unsigned int sbus[26];//25byteの送信データを格納しておく
unsigned int rcChannel[19]={0};
static int flg;

//unsigned short sbusFailSafeCount = 0;
//unsigned long sbusFrameCount = 0;
//unsigned short sbusRate = 0;

//SBUS信号のデコード、出力
void sbus_irq_handler(){

	short data=IORD_ALTERA_AVALON_UART_RXDATA(UART1_BASE);
	if(data==START_BYTE&&flg==0){
		sbus[flg]=data;
		flg++;
	}
	else if(flg>0){
		sbus[flg]=data;
		flg++;
	}
	switch(flg){
			    case 3:
			    rcChannel[0]=(sbus[1]|sbus[2]<<8)&0x07ff;
//			    printf("%04d ",rcChannel[0]);
			    break;

			    case 4:
			    rcChannel[1]=(sbus[2]>>3|sbus[3]<<5)&0x07ff;
//			    printf("%04d ",rcChannel[1]);
			    break;

			    case 6:
			    rcChannel[2]=(sbus[3]>>6|sbus[4]<<2|sbus[5]<<10)&0x07ff;
//			    printf("%04d ",rcChannel[2]);
			    break;

			    case 7:
			    rcChannel[3]=(sbus[5]>>1|sbus[6]<<7)&0x07ff;
//			    printf("%04d ",rcChannel[3]);
			    break;

			    case 8:
			    rcChannel[4]=(sbus[6]>>4|sbus[7]<<4)&0x07ff;
//			    printf("%04d ",rcChannel[4]);
			    break;

			    case 10:
			    rcChannel[5]=(sbus[7]>>7|sbus[8]<< 1|sbus[9]<<9)&0x07ff;
//			    printf("%04d ",rcChannel[5]);
			    break;

			    case 11:
			    rcChannel[6]=((sbus[9]>>2|sbus[10] << 6) & 0x07ff);
//			    printf("%04d ",rcChannel[6]);
			    break;

			    case 12:
			    rcChannel[7]=((sbus[10] >> 5 | sbus[11] << 3) & 0x07ff);
//			    printf("%04d ",rcChannel[7]);
			    break;

			    case 14:
			    rcChannel[8]=((sbus[12]|sbus[13] << 8) & 0x07ff);
//			    printf("%04d ",rcChannel[8]);
			    break;

			    case 15:
			    rcChannel[9]=((sbus[13] >> 3 | sbus[14] << 5) & 0x07ff);
//			    printf("%04d ",rcChannel[9]);
			    break;

			    case 17:
			    rcChannel[10]=((sbus[14] >> 6 | sbus[15] << 2 | sbus[16] << 10) & 0x07ff);
//			    printf("%04d ",rcChannel[10]);
			    break;

			    case 18:
			    rcChannel[11]=((sbus[16] >> 1 | sbus[17] << 7) & 0x07FF);
//			    printf("%04d ",rcChannel[11]);
			    break;

			    case 19:
			    rcChannel[12]=((sbus[17] >> 4  | sbus[18] << 4)  & 0x07FF);
//			    printf("%04d ",rcChannel[12]);
			    break;

			    case 21:
			    rcChannel[13]=((sbus[18] >> 7 |sbus[19] << 1|sbus[20] << 9) & 0x07ff);
//			    printf("%04d ",rcChannel[13]);
			    break;

			    case 22:
			    rcChannel[14]=((sbus[20] >> 2  | sbus[21] << 6) & 0x07ff);
//			    printf("%04d ",rcChannel[14]);
			    break;

			    case 23:
			    rcChannel[15]=((sbus[21] >> 5 | sbus[22] << 3) & 0x07ff);
//			    printf("%04d ",rcChannel[15]);
			    break;

			    case 25:
//			    	printf("\n");
			    	flg=0;
			    	break;
			}
}


int main(){
	int i;
	unsigned int PWM[4]={0};

	IOWR_ALTERA_AVALON_PIO_DATA(PERIOD_BASE,CYCLE);//PWM周期を書き込み

    printf("Start calibration\n");
    IOWR_ALTERA_AVALON_UART_DIVISOR(UART1_BASE,BAUD_DIVISOR);//SBUSの通信速度を変更（１００Kbps）
	alt_irq_register(UART1_IRQ,0,sbus_irq_handler);//割り込みの定義

    //キャリブレーション開始
    while(1){//トグルスイッチを上に→最大値を出力
    	if(rcChannel[4]>1400){
    		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_1_BASE,DUTY_MAX);
    		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_2_BASE,DUTY_MAX);
    		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_3_BASE,DUTY_MAX);
    		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_4_BASE,DUTY_MAX);
    		break;
    	}
    }

    while(1){//トグルスイッチを下に→最小値を出力
    	if(rcChannel[4]<600){
    		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_1_BASE,DUTY_MIN);
    		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_2_BASE,DUTY_MIN);
    		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_3_BASE,DUTY_MIN);
    		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_4_BASE,DUTY_MIN);
    		printf("Calibration OK");
    		break;
    	}
    }
      //キャリブレーション終了
while(1){//トグルスイッチを中に→飛行モードに移行
	if(rcChannel[4]>600&&rcChannel[4]<1400){
		printf("Flight mode\n");
		break;
	}
}
    //飛行制御
	while(1){
		//割り込みを待つ
		for(i=0;i<16;i++){
			printf("%04d ",rcChannel[i]);
		}
		printf("\n");
		for(i=0;i<4;i++){
			PWM[i]=DUTY_MIN+(rcChannel[i]-352)*(DUTY_MAX-DUTY_MIN)/1344;
			if(PWM[i]>(DUTY_MAX-DUTY_MIN)/2){//出力は最大50%に制限
				PWM[i]=(DUTY_MAX-DUTY_MIN)/2;
			}
		}

		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_1_BASE,PWM[0]);
		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_2_BASE,PWM[1]);
		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_3_BASE,PWM[2]);
		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_4_BASE,PWM[3]);

		usleep(interval);
	}

return 0;

}

