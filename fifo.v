`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo(d_in, d_out, empty, full, rst, wnr, enable, clk_d, clk);
//begin param
parameter data_width = 4;
parameter addy_width = 4;
parameter depth = 8;
//begin inputs
input clk;
input clk_d;
wire deb;
input rst;
input wnr;
input enable;
input [data_width-1:0]d_in;
output [data_width-1:0]d_out;
reg [data_width-1:0]d_out;
output reg full;
output reg empty;
reg [addy_width-1:0] r_ptr, w_ptr; 
reg [addy_width-1:0] status_count;
reg [data_width-1:0] mem [depth-1:0];
integer count;

button_debouncer instance1(clk, clk_d, deb);
always@(posedge deb, posedge rst)
begin 
    if(rst)
        begin r_ptr = 0; w_ptr = 0; d_out = 4'b0000;  
        count = 0;
        end
    else if(!enable)
        begin d_out = 'bz; 
        end
    else if(wnr && !full)
        begin mem[w_ptr[addy_width-1:0]] = d_in; w_ptr = w_ptr +1;
        count = count + 1;
        end
    else if(!wnr && !empty)
        begin d_out = mem[r_ptr[addy_width-1:0]]; r_ptr = r_ptr +1;
        count = count - 1;
        end 
     else 
        begin d_out = 'bz; 
        end
end
always@(r_ptr, w_ptr) 
begin

    if(r_ptr==w_ptr)
        begin empty = 1; full = 0; 
        //r_ptr = 0;
        
        end
    else if(count==depth)
        begin #125; empty = 0; full = 1;
        end
    else
        begin empty = 0; full = 0;
        end
end
endmodule
