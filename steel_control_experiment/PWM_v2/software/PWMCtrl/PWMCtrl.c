/*
 * 20231229 Motor controller
 *
 * 1.push KEY0/output MAX duty rate
 * 2.push KEY1/output MIN duty rate
 * 3.push KEY0 again/5% duty rate
 * 4.DIP_switch[0]/15% duty rate
 *   DIP_switch[1]/30% duty rate
 *   DIP_switch[2]/50% duty rate
 *   DIP_switch[3]/70% duty rate
 *   all/100% duty rate
 *   else /5% duty rate
 * 5.push KEY0 again/stop motor
 */

#include "sys/alt_stdio.h"
#include "system.h"
#include  <unistd.h>
#include "altera_avalon_pio_regs.h"

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


int main(){

        int sw_0=0x1;
        int sw_1=0x1;
        int dip_0=0x1;
        int dip_1=0x1;
        int dip_2=0x1;
        int dip_3=0x1;



//        IOWR_ALTERA_AVALON_PIO_DATA(CYCLE_BASE,125000);
        IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,0);//初期化

        IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,0);
        IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,0);
        IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,0);
        IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,0);
        IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,0);
        IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,0);
        IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
        IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,0);
        while(1){
        	sw_0=IORD_ALTERA_AVALON_PIO_DATA(SW0_BASE);
        	if(sw_0==0x0){
        	    IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,116500);//100%/calibration

        		IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,1);

        	    break;
        	}
        }
        while(1){
        	sw_1=IORD_ALTERA_AVALON_PIO_DATA(SW1_BASE);
        	if(sw_1==0x0){
        		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,47000);//0%/calibration
        		IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,1);
        	    break;
        	}
        }
        while(1){
        	sw_0=IORD_ALTERA_AVALON_PIO_DATA(SW0_BASE);
            if(sw_0==0x0){
                IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,50475);//5%

                IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,0);

                usleep(1000000);
                break;
            }
        }

        while(1){
        	dip_0=IORD_ALTERA_AVALON_PIO_DATA(DIP0_BASE);
      	    dip_1=IORD_ALTERA_AVALON_PIO_DATA(DIP1_BASE);
      	    dip_2=IORD_ALTERA_AVALON_PIO_DATA(DIP2_BASE);
      	    dip_3=IORD_ALTERA_AVALON_PIO_DATA(DIP3_BASE);

      	    sw_0=IORD_ALTERA_AVALON_PIO_DATA(SW0_BASE);
      	    if(sw_0==0x0){
      	    	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,0);//STOP

      	    	IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,0);
      	    	IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,0);
      	    	IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,0);
      	    	IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,0);
      	    	IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,0);
      	    	break;
      	    }
      	    if(dip_0==0x0&&dip_1==0x1&&dip_2==0x1&&dip_3==0x1){
        		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,57425);//15%

        		IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,0);
      	    }else if(dip_0==0x1&&dip_1==0x0&&dip_2==0x1&&dip_3==0x1){
        		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,67850);//30%

        		IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,0);
      	    }else if(dip_0==0x1&&dip_1==0x1&&dip_2==0x0&&dip_3==0x1){
        		IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,81750);//50%

        		IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,0);
      	    }else if(dip_0==0x1&&dip_1==0x1&&dip_2==0x1&&dip_3==0x0){
      	    	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,95650);//70%

        		IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,0);
      	    }else if(dip_0==0x0&&dip_1==0x0&&dip_2==0x0&&dip_3==0x0){
      	    	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,116500);//100%

        		IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,1);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,1);
      	    }else{
      	    	IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,50475);//5%

        		IOWR_ALTERA_AVALON_PIO_DATA(LED0_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED1_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED2_BASE,1);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED3_BASE,0);
        		IOWR_ALTERA_AVALON_PIO_DATA(LED4_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED5_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED6_BASE,0);
                IOWR_ALTERA_AVALON_PIO_DATA(LED7_BASE,0);
      	    }
        }

        return 0;
}

