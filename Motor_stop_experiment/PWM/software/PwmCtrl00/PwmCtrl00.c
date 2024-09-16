//2023/07/05　PWM制御

#include "sys/alt_stdio.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"

int main()
{
	  //周期の設定
	IOWR_ALTERA_AVALON_PIO_DATA(CYCLE_BASE,125000);
        int sw1=0x1;
        int sw2=0x1;
        int sw3=0x1;

  while (1){
	  sw1=IORD_ALTERA_AVALON_PIO_DATA(SW1_BASE);
	  sw2=IORD_ALTERA_AVALON_PIO_DATA(SW2_BASE);
	  sw3=IORD_ALTERA_AVALON_PIO_DATA(SW3_BASE);

	  if(sw1==0x0&&sw2==0x1&&sw3==0x1){
				 IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,116500);//100%

			 }else if(sw1==0x0&&sw2==0x0&&sw3==0x1){
			  IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,47000);//0%

		 }else if(sw1==0x0&&sw2==0x0&&sw3==0x0){
			  IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,50475);//5%

		  }else{
			  IOWR_ALTERA_AVALON_PIO_DATA(DUTY_BASE,0);//PWM信号を停止


}

  }

  return 0;
}

