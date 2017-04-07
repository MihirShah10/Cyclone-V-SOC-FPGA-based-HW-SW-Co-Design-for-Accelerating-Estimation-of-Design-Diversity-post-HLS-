// This is Micro-Architecture 1
//y0=((a0 or b0) and c0) or (d0 and (c0 or b0))

module ma_1(
            input a0, 
            input b0, 
            input c0,
            input d0,
            input tri_e,
            output y0
            );
  
reg r1,r2,r3,r4;
reg tri_y;

tri_buffer TRI_MA_1(tri_y,tri_e,y0);

always @ (a0 or b0 or c0 or d0)

begin

	r1=(b0 | c0);
	r2=(r1 & a0);
	tri_y=(r2 & d0);

end
endmodule
