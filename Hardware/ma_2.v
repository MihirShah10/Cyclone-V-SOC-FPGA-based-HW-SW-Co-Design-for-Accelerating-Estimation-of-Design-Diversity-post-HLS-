// This is Micro-Architecture 2

module ma_2(
            input a1, 
            input b1, 
            input c1,
            input d1,
            input tri_en,
            output y1
            );
  
reg j1,j2,j3,j4,j5;
reg a1_not,b1_not,c1_not,d1_not;
reg tri_y1;

tri_buffer TRI_MA_2(tri_y1,tri_en,y1);

always @ (a1 or b1 or c1 or d1)

begin
	a1_not=(~a1);
	b1_not=(~b1);
	c1_not=(~c1);
	d1_not=(~d1);

	j1=(c1_not & b1_not);
	j2=(j1|a1_not);
	j3=(j2|d1_not);

	tri_y1=(~j3);

end
endmodule
