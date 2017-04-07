// Fault-Injection Top-Module
module TS_FI_MUX(SIG_IN, SEL_F, SEL_MAIN, TRI_E, SIG_OUT);

input SIG_IN,SEL_F,SEL_MAIN,TRI_E;
output SIG_OUT;

reg vdd=1'b1;
reg gnd=1'b0;

wire SIG_OUT_F, SIG_OUT_MAIN;

    mux MUX_F(vdd,gnd,SEL_F,SIG_OUT_F);
    mux MUX_MAIN(SIG_OUT_F, SIG_IN, SEL_MAIN, SIG_OUT_MAIN);
    tri_buffer BUF1(SIG_OUT_MAIN, TRI_E, SIG_OUT);

endmodule
