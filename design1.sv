// 16-tap FIR Low Pass Filter
// Cutoff ~ 1kHz, Fs = 100MHz
module fir_filter(
    input clk,
    input rst,
    input signed [15:0] x_in, // 16-bit signed input
    output reg signed [31:0] y_out // 32-bit signed output
);

parameter N = 16;

// 16-tap FIR Coefficients in Q1.12 format
// Designed for 1kHz cutoff @ 100MHz
reg signed [12:0] coeff [0:N-1];
initial begin
    coeff[0] = 13'sd15;
    coeff[1] = -13'sd23;
    coeff[2] = -13'sd65;
    coeff[3] = -13'sd40;
    coeff[4] = 13'sd155;
    coeff[5] = 13'sd459;
    coeff[6] = 13'sd782;
    coeff[7] = 13'sd1008;
    coeff[8] = 13'sd1008;
    coeff[9] = 13'sd782;
    coeff[10] = 13'sd459;
    coeff[11] = 13'sd155;
    coeff[12] = -13'sd40;
    coeff[13] = -13'sd65;
    coeff[14] = -13'sd23;
    coeff[15] = 13'sd15;
end

// Shift register to store past inputs
reg signed [15:0] shift_reg [0:N-1];

// Multiplication results
reg signed [28:0] prod [0:N-1];

// Accumulator
reg signed [47:0] acc;

integer i;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        for(i=0; i<N; i=i+1) 
            shift_reg[i] <= 0;
        y_out <= 0;
    end
    else begin
        // Shift new input
        shift_reg[0] <= x_in;
        for(i=1; i<N; i=i+1) 
            shift_reg[i] <= shift_reg[i-1];
            
        // Multiply
        for(i=0; i<N; i=i+1) 
            prod[i] <= shift_reg[i] * coeff[i];
            
        // Accumulate
        acc = 0;
        for(i=0; i<N; i=i+1) 
            acc = acc + prod[i];
            
        // Output: Q28.12 -> Q28.0 by shifting 12 bits
        y_out <= acc >>> 12;
    end
end

endmodule
