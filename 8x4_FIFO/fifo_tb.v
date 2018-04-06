`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 

// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module fifo_tb;
reg [3:0]  data_in;
reg        clk,rst_a,wnr;
wire [3:0] data_out;
wire    full,empty;

reg enable;
integer i,j;  
reg [3:0]compare, d_in;

fifo u1 (.d_out(data_out),.full(full), .empty(empty), .wnr(wnr), .clk_d(clk), .rst(rst_a), .d_in(data_in));

//CLK TICK
always
begin
clk=1'b1;
enable = 1'b1;
forever #50 clk=~clk;
end

//BEGIN WRITE DATA
initial
begin 
//clear memory on start
    rst_a = 1'b1;
    #100;
 
 d_in = 4'b0000; //TEST DATA FOR WRTITING
 wnr = 1'b1;
 rst_a = 1'b0;
 //LOOP TO FILL FIFO MEM   
  for(j = 4'b0001; j <= 4'b1000; j = j + 1'b1)
           begin
           
           d_in = d_in + 1'b1;
           data_in = d_in;
           #100;      
           end   
//Begin READ
   #50; wnr=1'b0;
   compare = 4'b0000;
 

    for(i = 4'b0001; i <= 4'b1000; i = i + 1'b1)
        begin
        compare = compare + 1'b1;
        #100.5;
            if(data_out != compare)
                begin $display("ERRORRRRRR iteration:%b != d_out:%b",compare, data_out);
                $stop;
                //#101; //To ensure incrementation does not overlap read speed
                end   
            else
               // #101; //To ensure incrementation does not overlap read speed
                begin
                $display("Congrats homie, it works. iteration:%b == d_out:%b", compare, data_out); 
                
                end       
        end
   #1600;
   
$stop;
end
endmodule

