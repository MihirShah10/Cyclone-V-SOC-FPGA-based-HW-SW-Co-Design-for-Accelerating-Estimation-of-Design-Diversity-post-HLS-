module tri_buffer(in,en,out);

input in,en;
output out;

assign out = (en)?1'bz:in;

endmodule
