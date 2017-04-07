#include <stdio.h>
#include <unistd.h>
#include <fcntl.h> 
#include "mman.h" 
#include <hwlib.h> 
#include "socal.h"
#include "hps.h" 
#include "alt_gpio.h"
#include "hps_0.h"
#include<stdlib.h>
#include<string.h>
#include<math.h>


#define REG_BASE 0xFF200000
#define REG_SPAN 0x00200000

void* virtual_base;
void* led_addr;
void* sw_addr;
int fd;
int switches;

void* ma1_input_addr;
void* ma1_output_addr;
//int result_1;


char value_input[32];
char value_output[32];

FILE *fp;
char line[256];
char line_test[256];

int j;
int m;
int internal_counter;

const char* test_config;
const char* input_test_data;

int stg_1_int, stg_2_int, stg_3_int, stg_4_int, stg_5_int;

uint64_t sum,pow_v;
int length;

int stg_5_counter=0;
char v0;
char v1;

FILE *fp_input_files;
char value_input_files[33];
char test_config_golden[257];

int num_inputs;
int num_inputs_comb;
int num_fault_points;
int num_test_comb;

char *buffer_stg_5;

uint64_t dec_2_int(const char* input_dec)
{
	sum=0;	
	int k,y;
	length =strlen(input_dec);
	printf("Length: %d \n", length);
	
	for (k=1; k<=length; k++)
	{
		if(input_dec[length-k]=='1')
		{	
			if(k==1)
			{
				pow_v=1;
			}
			else if(k>1)
			{
				pow_v=1;
				for(y=0;y<k-1;y++)
					{
						pow_v=pow_v*2;
					}
			}
	sum=sum + abs(pow_v);
		}
	}
	return sum;
}


void File_Write_Log(const char *data_log)
{

    fp = fopen("/proj/files/data_log.txt", "a");
	fputs(data_log, fp);
	fclose(fp);
}

void File_Write_Result(const char *data_result)
{

    fp = fopen("/proj/files/data_result.txt", "a");
	fputs(data_result, fp);
	fclose(fp);
}

void File_Write_Result_Char(char data_int)
{

    fp = fopen("/proj/files/data_result.txt", "a");
 	fputc(data_int, fp);
 	fclose(fp);
}

void File_Write_Result_Num(int data_int)
{

    fp = fopen("/proj/files/data_result.txt", "a");
 	fprintf(fp,"%d",data_int);
 	fclose(fp);
}

const char * File_Read_DUT_Inputs(int d)
 {
	int count=0;
	
	fp = fopen("/proj/files/dut_inputs.txt", "r");
    while (fgets(line, sizeof(line), fp)) 
	{
		if (count==d)
		{
			printf("%s\n", line);
			break;
		}
		count =count+1;		
    }
    fclose(fp);
	return line;
}

const char * File_Read_Test_Config(int e)
 {
	int count_test=0;
	
	fp = fopen("/proj/files/test_config.txt", "r");
    while (fgets(line_test, sizeof(line_test), fp)) 
	{
		if (count_test==e)
		{
			printf("%s\n", line_test);
			break;
		}
		count_test=count_test+1;		
    }
    fclose(fp);
	return line_test;
}

char *decimal_to_binary(int n)
{
   int c, d, count;
   char *pointer;
 
   count = 0;
   pointer = (char*)malloc(32+1);
 
   if ( pointer == NULL )
      exit(EXIT_FAILURE);
 
   for ( c = 31 ; c >= 0 ; c-- )
   {
      d = n >> c;
 
      if ( d & 1 )
         *(pointer+count) = 1 + '0';
      else
         *(pointer+count) = 0 + '0';
 
      count++;
   }
   *(pointer+count) = '\0';
 
   return  pointer;
}

void File_Write_Input_DUT(const char *data_result)
{

    fp_input_files = fopen("/proj/files/dut_inputs.txt", "a");
	fputs(data_result, fp_input_files);
	fclose(fp_input_files);
}

void File_Write_Test_Config(const char *data_result)
{

    fp_input_files = fopen("/proj/files/test_config.txt", "a");
	fputs(data_result, fp_input_files);
	fclose(fp_input_files);
}

const char * dec2bin_input_files(int rand_number, int max_length)

{
   int i = 0;
    
   for(i = (max_length-1); i >= 0; i--){
     if((rand_number & (1 << i)) != 0){
      // printf("1");
       value_input_files[i]='1';
     }else{
      // printf("0");
       value_input_files[i]='0';
     } 
   }
    
    return value_input_files;
}	

void in_file()
{
	int i;
//------------------------------ Collecting User Defined Inputs ------------------------------------------//	
	printf("\nEnter the number of Inputs to each DUT:");
	scanf("%d",&num_inputs);
	printf("Number of Inputs to each DUT: %d \n\n", num_inputs);
	
	printf("Enter the Number of Input Combinations to Test:");
	scanf("%d",&num_inputs_comb);
	printf("Number of Input Combinations to Test: %d \n\n", num_inputs_comb);
	
	printf("Enter the Number of Fault Injection Points:");
	scanf("%d",&num_fault_points);
	printf("Number of Fault Injection Points: %d \n\n", num_fault_points);
	
	printf("Enter the Number of Test Combinations:");
	scanf("%d",&num_test_comb);
	printf("Number of Test Combinations: %d \n\n", num_test_comb);
	
	//------------------------------ Setting the Golden Reference ------------------------------------------//
	for(i=0;i<num_fault_points*2;i++)
	{
		test_config_golden[i]='1';
	}	
	
	File_Write_Test_Config(test_config_golden);
	File_Write_Test_Config("\n");
	
	//------------------------------ Creating dut_inputs.txt Input File ------------------------------------------//
	for(i=0;i<num_inputs_comb;i++)
	{
		int dut_input=rand();
		const char *input;
		input = dec2bin_input_files(dut_input, num_inputs);
		File_Write_Input_DUT(input);
		File_Write_Input_DUT("\n");
	}
	
	//------------------------------ Creating test_config.txt Input File ------------------------------------------//
		for(i=0;i<num_test_comb;i++)
	{
		int test_config=rand();
		const char *fault;
		fault = dec2bin_input_files(test_config, num_fault_points*2);
		File_Write_Test_Config(fault);
		File_Write_Test_Config("\n");
	}
}

int main ()
{
	fd=open("/dev/mem",(O_RDWR|O_SYNC));
	virtual_base=mmap(NULL,REG_SPAN,(PROT_READ|PROT_WRITE),MAP_SHARED,fd,REG_BASE);
	sw_addr=virtual_base+SW_BASE;
	led_addr=virtual_base+LED_BASE;

	ma1_input_addr = virtual_base + INPUT_MA1_BASE;
	ma1_output_addr = virtual_base + OUTPUT_MA1_BASE;
	
	in_file();

	char input_data[num_inputs];

	for(m=0;m<num_test_comb;m++)
	{
		test_config=File_Read_Test_Config(m);
		File_Write_Result("\n\n");
		File_Write_Result_Num(m);
		File_Write_Result("_Test_Configuration:");
		File_Write_Result(test_config);
		File_Write_Result(" -------------------------------------------------------------------- \n");
		
		for(j=0;j<num_inputs_comb;j++)
		{
			internal_counter=1;
			char main_string[33]="00000000011111111111111111111111\0";

			switch(internal_counter)
			{
				case 1: 
						printf("\nClearing the Shift Registers & Latching the Tri-State Drivers \n");
						File_Write_Log("Clearing the Shift Registers & Latching the Tri-State Drivers\n");
						
						stg_1_int=dec_2_int(main_string);
						printf("IN_STG_1: %s ", main_string);
						printf("IN_STG_1(dec): %d\n", stg_1_int);
						
						*(uint32_t *)ma1_input_addr=stg_1_int; 
						
						File_Write_Log("IN_STG_1: ");
						File_Write_Log(main_string);
						File_Write_Log("\n");
						
						usleep(1000000);
						internal_counter=2;
						
				case 2: 
						printf("\nEnabling the Scanning of Test Configuration & Disabling the Shift Registers Clear Signal.....  \n" );								
						File_Write_Log("Enabling the Scanning of Test Configuration & Disabling the Shift Registers Clear Signal..... \n");
						
						main_string[strlen(main_string)-23]='0'; //clear sipo
						main_string[strlen(main_string)-2]='1'; // enable scanning
						printf("Binary value stg2 after adding sipo & scan = %s\n", main_string);
						
						test_config=File_Read_Test_Config(m);
						File_Write_Log("Test Configuration:");
						File_Write_Log(test_config);
						File_Write_Log("\n");
						
						
						printf("Test_Config: %s \n", test_config);
						int scan_count;
						for(scan_count=10; scan_count<=25; scan_count++)
						{
							main_string[scan_count]=*test_config; // Loading the Test Configuration
							test_config++;
						}
						
						stg_2_int=dec_2_int(main_string);																									
						printf("IN_STG_2: %s ", main_string);
						printf("IN_STG_2(dec): %d\n", stg_2_int);
						
						
						*(uint32_t *)ma1_input_addr=stg_2_int; 
						
						File_Write_Log("IN_STG_2: ");
						File_Write_Log(main_string);
						File_Write_Log("\n");
						
						usleep(3000000);
						internal_counter=3;
						
				case 3: 
						printf("\nScanning Test Configuration Completed.....  \n");								
						File_Write_Log("Scanning Test Configuration Completed.....   \n");						
						
						main_string[strlen(main_string)-2]='0'; // Disable the Scan
						stg_3_int=dec_2_int(main_string);
						
						printf("IN_STG_3: %s ", main_string);
						printf("IN_STG_3(dec): %d\n", stg_3_int);
						
						*(uint32_t *)ma1_input_addr=stg_3_int;
						
						File_Write_Log("IN_STG_3: ");
						File_Write_Log(main_string);
						File_Write_Log("\n");
						
						usleep(1000000);
						internal_counter=4;
				
				case 4: 
						printf("\nUn-Latching the Tri-State Drivers & Sending Input Stimulus to DUT's............. \n");			
						File_Write_Log("Un-Latching the Tri-State Drivers & Sending Input Stimulus to DUT's....... \n");
						
						input_test_data=File_Read_DUT_Inputs(j);
						printf("INPUT_STIMULUS TO DUT: %s\n",input_test_data);
						
						main_string[strlen(main_string)-1]='0';// TRI_E DISABLE
						int input_count;
						for(input_count=26; input_count<=29; input_count++)
						{
							main_string[input_count]=*input_test_data; // Loading the Input Data
							input_data[input_count-26]=*input_test_data;
							input_test_data++;
						}
						
						stg_4_int=dec_2_int(main_string);
						printf("IN_STG_4: %s ", main_string);
						printf("IN_STG_4(dec): %d\n", stg_4_int);
						
						*(uint32_t *)ma1_input_addr=stg_4_int;
						
						File_Write_Log("IN_STG_4: ");
						File_Write_Log(main_string);
						File_Write_Log("\n");
						
						printf("\nInput Data: %s \n", input_data);
						
						File_Write_Log("INPUT_STIMULUS TO DUT: ");
						File_Write_Log(input_test_data);
						File_Write_Log("\n");
						usleep(2000000);
						internal_counter=5;
						
				case 5: 
						printf("\n Analyzing the output results............. \n");
						File_Write_Log(" Analyzing the output results.............  \n");
						
						stg_5_int=*(uint32_t *)ma1_output_addr; //Collect the Outputs
						buffer_stg_5 = decimal_to_binary(stg_5_int);
						
						printf("OP_STG_5: %s\n", buffer_stg_5);
						printf("DUT Result 1: %c\n", buffer_stg_5[strlen(buffer_stg_5)-1]);
						printf("DUT Result 2: %c\n", buffer_stg_5[strlen(buffer_stg_5)-2]);
						
						v0=buffer_stg_5[strlen(buffer_stg_5)-1];
						v1=buffer_stg_5[strlen(buffer_stg_5)-2];
						
						printf("\n Test Completed.\n");
						
						File_Write_Log("OP_STG_5: ");
						File_Write_Log(buffer_stg_5);
						File_Write_Log("\n");
						File_Write_Log("Test Completed......");
						File_Write_Log("\n----------------------------------------------------------------------\n");
						
						if(j==0)
						{
							test_config=File_Read_Test_Config(m);
							
							File_Write_Result_Num(j);
							File_Write_Result(",");
							File_Write_Result("DUT_Result_1,");
							File_Write_Result_Char(v0);
							File_Write_Result(",");							
							File_Write_Result("DUT_Result_2,");
							File_Write_Result_Char(v1);
							File_Write_Result(",");
							File_Write_Result(input_data);
							File_Write_Result(",");
							File_Write_Result(test_config);						
							File_Write_Result("\n");
						}
						
						else if(j>0)
						{
							test_config=File_Read_Test_Config(m);
							
							File_Write_Result_Num(j);
							File_Write_Result(",");
							File_Write_Result("DUT_Result_1,");
							File_Write_Result_Char(v0);
							File_Write_Result(",");							
							File_Write_Result("DUT_Result_2,");
							File_Write_Result_Char(v1);
							File_Write_Result(",");
							File_Write_Result(input_data);							
							File_Write_Result(",");
							File_Write_Result(test_config);
							File_Write_Result("\n");
						}
						/*	
						if(stg_5_counter==0)
						{
							
							stg_5_counter=1;
						
						}
						else if(stg_5_counter>0 && stg_5_counter<num_inputs_comb)
						{
							File_Write_Result_Num(j);							
							File_Write_Result(",");
							File_Write_Result("DUT_Result_1,");
							File_Write_Result_Char(v0);
							File_Write_Result(",");							
							File_Write_Result("DUT_Result_2,");
							File_Write_Result_Char(v1);						
							File_Write_Result(",");
							File_Write_Result(input_data)
							File_Write_Result("\n");
							
							stg_5_counter=stg_5_counter+1;
						}
						else if(stg_5_counter==num_inputs_comb)
						{
							File_Write_Result_Num(j);							
							File_Write_Result(",");
							File_Write_Result("DUT_Result_1,");
							File_Write_Result_Char(v0);
							File_Write_Result(",");							
							File_Write_Result("DUT_Result_2,");
							File_Write_Result_Char(v1);
							File_Write_Result(",");
							File_Write_Result(input_data);							
							File_Write_Result("\n");
							
							stg_5_counter=0;
						}						

						break;
						*/	
			}		
		}
	}
	return 0;
}

	/* ------------------------------------------KEY SIGNALS & STAGES OF FSM EXPLAINED -------------------------------------------------------- 
	
	                    TRI_E => GPIO_0(0) ,
                        SCAN_ENABLE => GPIO_0(1),
                        TEST_DATA => GPIO_0(21 downto 6),
                        SIPO_OUT => GPIO_1(18 downto 3),
                        SIGNAL_A => GPIO_0(2),
                        SIGNAL_B => GPIO_0(3),
                        SIGNAL_C => GPIO_0(4),
                        SIGNAL_D => GPIO_0(5),
                        SIGNAL_Y0 => GPIO_1(0),
                        SIGNAL_Y1 => GPIO_1(1),
                        CTRL_FB => GPIO_1(2),
						SIPO_CLEAR => GPIO_0(22)
	
	input string 32-bit (GPIO_0): {TRI_E - SCAN_ENABLE - SIGNAL_A - SIGNAL_B - SIGNAL_C - SIGNAL_D - TEST_DATA - SIPO_CLEAR}    
	
	output string 32-bit(GPIO_1): {SIGNAL_Y0 - SIGNAL_Y1 - CTRL_FB - SIPO_OUT}
	
	STEPS: 
	1. CLEAR THE SHIFT REGISTERS (HIGH SIPO CLEAR) & ENABLE THE TRI-STATE(HIGH TRI_E) 0x007FFFFD
	2. ENABLE THE SCAN-INPUT_MA1_BASE (HIGH SCAN_ENABLE) & DISABLE THE SIPO CLEAR 0x003FFFFF;
	3. DISABLE THE SCAN-INPUT & IF CTRL_FB==1 INTERNAL COUNTER =4
	4. SEND THE INPUT DATA & DISABLE THE TRI-STATE (LOW TRI_E) 0x003FFFFE;
	5. COLLECT & READ THE OUTPUT STRING
	*/
/*	while(1)
	{
		File_Read(12);
		switches=*(uint32_t *)sw_addr;
		*(uint32_t *)led_addr=switches;
		usleep(1000000);
		printf("The value of Switches is: %u ",switches);

		*(uint32_t *)ma1_input_addr=a;
		result_1=*(uint32_t *)ma1_output_addr;
		usleep(3000000);
		printf("The result of testcase at scan_en:0x%08x ",result_1);


		*(uint32_t *)ma1_input_addr=b;
		result_1=*(uint32_t *)ma1_output_addr;
		usleep(2000000);
		printf("The result of testcase after scan:0x%08x \n",result_1);

	}
*/	