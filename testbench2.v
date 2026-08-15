`timescale 1ns/1ps
module tb;
reg clk, rst;
reg signed [15:0] x_in;
wire signed [31:0] y_out;

fir_filter uut(.clk(clk),.rst(rst),.x_in(x_in),.y_out(y_out));

always #5 clk = ~clk; // 100MHz clock

initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars(0,tb);
    $monitor("Time=%0t x_in=%6d y_out=%8d", $time, x_in, y_out);
    
    // Reset
    clk=0; rst=1; x_in=16'sd0; 
    #20 rst=0;
    
    // TEST 1: Step Input - This gives clean waveform
    #10 x_in = 16'sd0;
    #10 x_in = 16'sd1000; // Step up
    repeat(30) #10 x_in = 16'sd1000; // Hold to see settling
    
    // TEST 2: Step Down
    #10 x_in = 16'sd0;
    repeat(20) #10 x_in = 16'sd0;
    
    #50 $finish;
end
endmodule
