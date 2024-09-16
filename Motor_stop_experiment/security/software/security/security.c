//2023/07/05 security.c

#include <stdio.h>
#include <stdlib.h>
#include "sys/alt_stdio.h"
#include "system.h"
#include <string.h>
#include "altera_avalon_pio_regs.h"
#include "altera_avalon_uart_regs.h"
#include "sys/alt_irq.h"
#include <math.h>


int flg=0;
char data;
char nmea[3];
char lat[9];
char lon[10];

void uart_irq_handler(){
	data = IORD_ALTERA_AVALON_UART_RXDATA(UART1_BASE);
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
	char prompt[100];
//	int lat_deg;
//	int lat_min;
//	double lat_sec;
	int lon_deg;
	int lon_min;
	double lon_sec;

	alt_irq_register(UART1_IRQ,0,uart_irq_handler);
	IOWR_ALTERA_AVALON_PIO_DATA(STOP_BASE,0x1);
	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE,0x0);

	printf("Starting Secure Processor! \n");

	while(1){
		i = 0;
		while(1){
			if(flg==1){
				data = IORD_ALTERA_AVALON_UART_RXDATA(UART1_BASE);
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

//        lat_deg=NMEA2D(atof(lat));
//        lat_min=NMEA2M(atof(lat));
//        lat_sec=NMEA2S(atof(lat));
        lon_deg=NMEA2D(atof(lon));
        lon_min=NMEA2M(atof(lon));
        lon_sec=NMEA2S(atof(lon));


        //139°47'40":E　以東で停止
        if(lon_deg>=139&&lon_min>=47&&lon_sec>44){

                	IOWR_ALTERA_AVALON_PIO_DATA(STOP_BASE,0x0);
                	IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE,0x1);

                	//現在位置を出力
                	printf("<Current position>\n");
//            		printf("N %d  ",lat_deg);
//            		printf("%d'",lat_min);
//            		printf("%f''\n",lat_sec);
            		printf("%d°",lon_deg);
            		printf("%d'",lon_min);
            		printf("%f:E''\n\n",lon_sec);
            		printf("STOP!!\n");
            		break;
		}

		//現在位置を出力
                printf("<Current position>\n");
//		printf("N:%d  ",lat_deg);
//		printf("%d'",lat_min);
//		printf("%f''\n",lat_sec);
		printf("%d°",lon_deg);
		printf("%d'",lon_min);
		printf("%f'':E\n",lon_sec);
				}
	}

	}

}
	return (0);
}




