`timescale 1ns/1ps
module tb_fir;

reg clk, rst;
reg signed [15:0] x_in;
wire signed [31:0] y_out;

// Instantiate DUT
fir_filter uut(
   .clk(clk),
   .rst(rst),
   .x_in(x_in),
   .y_out(y_out)
);

// 100MHz Clock = 10ns period
always #5 clk = ~clk; 

initial begin
    // IMPORTANT: for waveform
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_fir);
    
    // Reset
    clk = 0; rst = 1; x_in = 0;
    #20 rst = 0;
    
    // TEST 1: 500Hz sine wave - Should PASS through filter
    $display("Testing 500Hz - PASS BAND");
    repeat(320) begin
        x_in = $rtoi(10000 * $sin(2*3.14159*500*($time/1e9)));
        #10; // 10ns = 100MHz
    end
    
    // TEST 2: 3000Hz sine wave - Should ATTENUATE 
    $display("Testing 3000Hz - STOP BAND");
    repeat(320) begin
        x_in = $rtoi(10000 * $sin(2*3.14159*3000*($time/1e9)));
        #10;
    end
    
    #100 $finish;
end

endmodule
