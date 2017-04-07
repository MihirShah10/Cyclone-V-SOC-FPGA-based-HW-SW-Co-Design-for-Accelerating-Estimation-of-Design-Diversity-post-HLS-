//Shift Register : Serial-In & Parallel-Out
module shift_large(C, SI,scan_shift_feedback, PO, sipo_clear); 
input  C,SI,scan_shift_feedback;
input sipo_clear; 
output [15:0] PO; 
reg [15:0] tmp; 
reg [4:0]count;

initial begin
    count=5'b0;
end 

always @(posedge C)
    begin : disable_block 
        if(count<5'b10000 && scan_shift_feedback && ~sipo_clear)
            begin
                tmp = {tmp[14:0], SI};
                count=count+1;
                $monitor("Enetered the SIPO"); 
   //assign PO = tmp; 
            end
            else if(sipo_clear) 
                begin
                    tmp=16'b0; 
                    count =5'b0;
                end
                  
            else if(count>=5'b10000)
                begin
                    disable disable_block;
                end
end
    assign PO = tmp;
endmodule
