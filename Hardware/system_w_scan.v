module system_w_scan ( 
                       input CLK,
                       input TRI_E,
                       input SCAN_ENABLE,
                       input [15:0]TEST_DATA,
                       output [15:0]SIPO_OUT,
                       input SIGNAL_A,
                       input SIGNAL_B,
                       input SIGNAL_C,
                       input SIGNAL_D,
                       output SIGNAL_Y0,
                       output SIGNAL_Y1,
                       output CTRL_FB,
                       input SIPO_CLEAR
                       );
                       
wire SIG_A0_OUT,SIG_B0_OUT,SIG_C0_OUT,SIG_D0_OUT;
wire SIG_A1_OUT,SIG_B1_OUT,SIG_C1_OUT,SIG_D1_OUT;
wire SCAN_SHIFT_FB;
wire SCAN_IN;

CTRL_UNIT TOP_CTRL(CLK,TEST_DATA,SCAN_ENABLE,SCAN_SHIFT_FB,CTRL_FB,SCAN_IN);

shift_large SIPO(CLK, SCAN_IN, SCAN_SHIFT_FB, SIPO_OUT,SIPO_CLEAR); // Calling Shift-Reg Module

TS_FI_MUX SYS_1(SIGNAL_A, SIPO_OUT[0], SIPO_OUT[1], TRI_E, SIG_A0_OUT);
TS_FI_MUX SYS_2(SIGNAL_B, SIPO_OUT[2], SIPO_OUT[3], TRI_E, SIG_B0_OUT);
TS_FI_MUX SYS_3(SIGNAL_C, SIPO_OUT[4], SIPO_OUT[5], TRI_E, SIG_C0_OUT);
TS_FI_MUX SYS_4(SIGNAL_D, SIPO_OUT[6], SIPO_OUT[7], TRI_E, SIG_D0_OUT);

TS_FI_MUX SYS_5(SIGNAL_A, SIPO_OUT[8], SIPO_OUT[9], TRI_E, SIG_A1_OUT);
TS_FI_MUX SYS_6(SIGNAL_B, SIPO_OUT[10], SIPO_OUT[11], TRI_E, SIG_B1_OUT);
TS_FI_MUX SYS_7(SIGNAL_C, SIPO_OUT[12], SIPO_OUT[13], TRI_E, SIG_C1_OUT);
TS_FI_MUX SYS_8(SIGNAL_D, SIPO_OUT[14], SIPO_OUT[15], TRI_E, SIG_D1_OUT);

ma_1 dut1(SIG_A0_OUT,SIG_B0_OUT,SIG_C0_OUT,SIG_D0_OUT,TRI_E,SIGNAL_Y0);
ma_2 dut2(SIG_A1_OUT,SIG_B1_OUT,SIG_C1_OUT,SIG_D1_OUT,TRI_E,SIGNAL_Y1);

endmodule
