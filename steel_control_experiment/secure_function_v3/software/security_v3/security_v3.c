//2024/01/18 security.c

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

//Duty比ごとのカウンタ
#define DUTY5 50475
#define DUTY10 53950
#define DUTY15 57425
#define DUTY20 60900
#define DUTY25 60900
#define DUTY30 67850
#define DUTY35 71325
#define DUTY40 74800
#define DUTY45 78275
#define DUTY50 81750
#define DUTY55 85225
#define DUTY60 88700
#define DUTY65 92175
#define DUTY70 95650
#define DUTY75 99125
#define DUTY80 102600
#define DUTY85 106075
#define DUTY90 109550
#define DUTY95 113025

#define USE_GPS //GPS信号に基づいて制御乗っ取り
//#define USE_KEY //スイッチ押下で制御乗っ取り
//#define FORCED_STOP//急停止


int flg=0;
char data;
int duty;

void REDUCE_PWM_DUTY(){//軟着陸を行う
	int i;
    for(i=0;i<300;i++){
    	duty=DUTY70-((DUTY70-DUTY50)*i/300);
    	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,duty);
    	printf("=Reduced output=\n");
    	usleep(10000);
    }
    usleep(500000);
}


void uart_irq_handler(){//GPSからのデータを読み取る。flg=1にする
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



int main(){
	int i;



	alt_irq_register(UART_IRQ,0,uart_irq_handler);//割り込みハンドラの定義

	IOWR_ALTERA_AVALON_PIO_DATA(STOP_BASE,1);//リセット信号無効化

	IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,0);//LED消灯
    IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,0);
    IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,0);
    IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,0);
    IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,0);
    IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,0);
    IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
    IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,0);
    IOWR_ALTERA_AVALON_PIO_DATA(LED8_BASE,0);
    IOWR_ALTERA_AVALON_PIO_DATA(LED9_BASE,0);

	IOWR_ALTERA_AVALON_PIO_DATA(PERIOD_BASE,PERIOD);//周期2500us
	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,0);//PWM出力=0
//	printf("================================ \n");
	printf("<<Starting Secure Processor!>> \n");


#ifdef USE_KEY
	int sw=1;

	while(1){
		sw=IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);

		if(sw==0){
			printf("<<Steel motor control>>\n");
			IOWR_ALTERA_AVALON_PIO_DATA(STOP_BASE,0);//リセット信号有効化

			IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,1);//LED点灯
	        IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,1);
	        IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,1);
	        IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,1);
	        IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,1);
	        IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,1);
	        IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,1);
	        IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,1);
	        IOWR_ALTERA_AVALON_PIO_DATA(LED8_BASE,1);
	        IOWR_ALTERA_AVALON_PIO_DATA(LED9_BASE,1);
			break;
		}
	}
	REDUCE_PWM_DUTY();

#endif

#ifdef USE_GPS

	char prompt[100];
	char nmea[3];
	char lat[9];
	char lon[10];
	int lon_deg;
	int lon_min;
	double lon_sec;

	while(1){
		i=0;

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

					if(lon_deg>=139&&lon_min>=47&&lon_sec>44){//停止位置
						IOWR_ALTERA_AVALON_PIO_DATA(STOP_BASE,0x0);

						IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,1);//LED点灯
				        IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,1);
				        IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,1);
				        IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,1);
				        IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,1);
				        IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,1);
				        IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,1);
				        IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,1);
				        IOWR_ALTERA_AVALON_PIO_DATA(LED8_BASE,1);
				        IOWR_ALTERA_AVALON_PIO_DATA(LED9_BASE,1);

				        printf("\n");
						printf("%d°",lon_deg);
						printf("%d'",lon_min);
						printf("%f”:E\n",lon_sec);
						printf("<<STOP!>>\n");

						break;
					}
					printf("%d°",lon_deg);
					printf("%d'",lon_min);
					printf("%f”:E\n",lon_sec);
				}
			}
		}
	}
	REDUCE_PWM_DUTY();
#endif

#ifdef FORCED_STOP

		while(1){
			sw=IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);

			pwm_in=IORD_ALTERA_AVALON_PIO_DATA(PWM_IN_BASE);//PWM_IN
			if(pwm_in==0){
				IOWR_ALTERA_AVALON_PIO_DATA(PWM_OUT_BASE,0);//PWM_OUT(LOW)
			}else if(pwm_in==1){
				IOWR_ALTERA_AVALON_PIO_DATA(PWM_OUT_BASE,1);//PWM_OUT(HIGH)
			}
			if(sw==0){
				printf("<<Steel motor control>>\n");
				IOWR_ALTERA_AVALON_PIO_DATA(STOP_BASE,0);//リセット信号有効化

				IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,0);//LED点灯
		        IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,1);
		        IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,0);
		        IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,1);
		        IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,0);
		        IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,1);
		        IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
		        IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,1);
		        IOWR_ALTERA_AVALON_PIO_DATA(LED8_BASE,0);
		        IOWR_ALTERA_AVALON_PIO_DATA(LED9_BASE,1);
				break;
			}
		}
		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,0);//PWM出力=0
		printf("<<The motor was stopped completely>>\n");
		return (0);
#endif

	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,0);//PWM出力=0
	printf("<<The motor was stopped completely>>\n");
	return (0);
}




