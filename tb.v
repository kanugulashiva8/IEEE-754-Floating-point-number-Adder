`timescale 1ns / 1ps

module tb();
reg [31:0] n1[1:0];
reg [31:0] n2[1:0]; 
wire [31:0] out;
reg clock = 1'b0;
reg [31:0] p,q;

initial begin       
//   n1[0] = 32'b11000111011101011010101100010001;
   n1[0] = 32'b01001001001000101000010100100001;
   
//   n2[0] = 32'b01001010100010010010010010010011;
   n2[0] = 32'b11000101001010011010101000101000;
end

always #5 clock = ~clock;
integer i = 0;
always@(posedge clock)
begin
   p = n1[i];
   q = n2[i];
   i = i+1;
end

adder add(out, p,q,clock);
endmodule

