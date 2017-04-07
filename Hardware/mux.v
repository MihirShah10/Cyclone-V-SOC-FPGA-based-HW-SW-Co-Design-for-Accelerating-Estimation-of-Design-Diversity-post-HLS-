// 2-Input Multiplexer
module mux (in1,in2,sel,out); 
input in1, in2, sel; 
output out; 

reg out;

always @ (sel or in1 or in2) 
case (sel) 
  1'b0 : out <= in1; 
  1'b1 : out <= in2;   
endcase 
    
endmodule
