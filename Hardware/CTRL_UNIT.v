
module CTRL_UNIT(CLK,data,scan_enable,ctrl_feedback,scan_shift_feedback,scan_chain);

input CLK;
input [15:0]data;
input scan_enable;
output reg ctrl_feedback;
output reg scan_chain;
output reg scan_shift_feedback;

reg [4:0]count;

initial begin
    count=5'b01111;
end
    
always @(posedge CLK)
begin
    if (scan_enable && count >=5'b0) 
        begin  
            ctrl_feedback=1'b1;
            scan_shift_feedback=1'b1;
            scan_chain=data[count];
            count=count-1;
            $monitor("Inside the Loop");   
        end
    if(~scan_enable)
        begin
            ctrl_feedback=1'b0;
            count=5'b01111;
        end
        
end    
endmodule
