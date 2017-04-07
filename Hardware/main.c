#include <stdio.h>
#include <unistd.h>
#include <fcntl.h> 
#include <sys/mman.h> 
#include "hwlib.h" 
#include "socal/socal.h"
#include "socal/hps.h" 
#include "socal/alt_gpio.h"
#include "hps_0.h"


#define REG_BASE 0xFF200000
#define REG_SPAN 0x00200000

void* virtual_base;
void* led_addr;
void* sw_addr;
int fd;
int switches;

void* ma1_input_addr;
void* ma1_output_addr;

int a=7;

int main (){
fd=open("/dev/mem",(O_RDWR|O_SYNC));
virtual_base=mmap(NULL,REG_SPAN,(PROT_READ|PROT_WRITE),MAP_SHARED,fd,REG_BASE);
sw_addr=virtual_base+SW_BASE;
led_addr=virtual_base+LED_BASE;

ma1_input_addr = virtual_base + OUTPUT_MA1_BASE;
ma1_output_addr = virtual_base + INPUT_MA1_BASE;

while(1){
switches=*(uint32_t *)sw_addr;
*(uint32_t *)led_addr=switches;
usleep(1000000);
printf("The value of Switches is: %u ",switches);

*(uint32_t *)ma1_input_addr=int a;
result_1=*(uint32_t *)ma1_output_addr;
printf(" The result of DUT_1: %u",result_1);

}
return 0;




}