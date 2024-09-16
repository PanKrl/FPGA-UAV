//2023/12/13 security.c

#include <stdio.h>
#include <stdlib.h>
#include "sys/alt_stdio.h"
#include "system.h"
#include <string.h>
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include <math.h>
#include<unistd.h>

#define PERIOD 125000 //period
#define MAX_DUTY 116500 //100%
#define MIN_DUTY 47000 //0%
#define DRIVE_DUTY 57425 //15%

//#define ACTIVATE_GPS //GPS信号に基づいて制御乗っ取り
#define ACTIVATE_KEY //スイッチ押下で制御乗っ取り


int flg=0;
char data;
char nmea[3];
char lat[9];
char lon[10];

int duty;

void uart_irq_handler(){
	data = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);
	flg = 1;
}


int NMEA2D(double val) {
  int d = val / 100;
  return d ;
}

int NMEA2M(double val) {
  int d = val / 100;
  int m = ((val / 100.0) - d) * 100.0;
  return m ;
}

double NMEA2S(double val) {
  int d = val / 100;
  int m = ((val / 100.0) - d) * 100.0;
  float s = ((((val / 100.0) - d) * 100.0) - m) * 60;
  return s ;
}



int main()
{
	int i;
	int sw;
	char prompt[100];

	int lon_deg;
	int lon_min;
	double lon_sec;


	alt_irq_register(UART_IRQ,0,uart_irq_handler);//割り込みハンドラの定義
	IOWR_ALTERA_AVALON_PIO_DATA(STOP_BASE,0x1);//リセット信号無効化
	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE,0x0);//LED消灯
	IOWR_ALTERA_AVALON_PIO_DATA(PERIOD_BASE,PERIOD);//周期2500us
	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,0x0);//PWM出力=0
	printf("================================ \n");
	printf("<<Starting Secure Processor!>> \n");

#ifdef ACTIVATE_KEY
	while(1){
		sw=IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);
		if(sw==0x0){
			printf("<<Steel motor control>>\n");
			IOWR_ALTERA_AVALON_PIO_DATA(STOP_BASE,0x0);//リセット信号有効化
			IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE,0x1);//LED点灯
			break;
		}
	}
#endif

#ifdef ACTIVATE_GPS
	while(1){//GPS受信処理ループ
		i = 0;
		while(1){
			if(flg==1){
				data = IORD_ALTERA_AVALON_UART_RXDATA(UART_BASE);//UARTからデータ読み取り
				prompt[i] = data;
				if(data==36){
					i = 0;
				}
				if(data==10){
					break;
				}
				i++;
				flg=0;
			}
		}

		for(i=0;i<3;i++){
			nmea[i] = prompt[i+3];
		}
		for(i=0;i<9;i++){
			lat[i] = prompt[i+18];
		}
		for(i=0;i<10;i++){
			lon[i] = prompt[i+30];
		}
		if(nmea[0]==71){
			if(nmea[1]==71){
				if(nmea[2]==65){
					lon_deg=NMEA2D(atof(lon));
					lon_min=NMEA2M(atof(lon));
					lon_sec=NMEA2S(atof(lon));
					if(lon_deg>=139&&lon_min>=47&&lon_sec>44){
						IOWR_ALTERA_AVALON_PIO_DATA(STOP_BASE,0x0);
						IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE,0x1);

						printf("<Current position>\n");
						printf("%d°",lon_deg);
						printf("%d'",lon_min);
						printf("%f:E''\n\n",lon_sec);
						printf("<<Steel motor control>>\n");

						break;
					}
					printf("%d°",lon_deg);
					printf("%d'",lon_min);
					printf("%f:E''\n",lon_sec);
				}
			}
		}
	}
#endif


    for(i=0;i<50;i++){
    	duty=DRIVE_DUTY-200*i;
    	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,duty);//緩やかに出力を落とす
    	printf("=Reduced output=\n");
    	usleep(100000);
    }

	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,0);//PWM出力=0
	printf("<<The motor was stopped completely>>\n");
	return (0);
}




