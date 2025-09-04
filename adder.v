`timescale 1ns / 1ps

module block1(output reg [31:0] O1,
              output reg [31:0] O2,
              input wire [31:0] I1,
              input wire [31:0] I2,
              input wire clk);
    always@(posedge clk)
    begin
       if(I2[30:23] > I1[30:23])
       begin
          O1 <= I2;
          O2 <= I1;
       end
       else
       begin
          O1 <= I1;
          O2 <= I2;
       end
    end
endmodule

module block2(output reg O1_2,
              output reg O2_2,
              output reg [7:0] O3_2,
              output reg [7:0] O4_2,
              output reg [23:0] O5_2,
              output reg [23:0] O6_2,
              input wire [31:0] I1,
              input wire [31:0] I2,
              input wire clk
              );
    reg [8:0] exp1,exp;
    reg [7:0] r1;          
    always@(posedge clk)    
    begin
       O1_2 <= I1[31];
       O2_2 <= I2[31];
       O3_2 <= I1[30:23];
       O4_2 <= I2[30:23];
       
       exp1 = {1'b0, ~I1[30:23]} + 9'b000000001;
       exp = {1'b0, I2[30:23]} + exp1;
       if(exp[8] == 0)
       r1 = (~exp[7:0]) + 1'b1;
       else
       r1 = exp[7:0];
       
       O5_2 = {1'b1 ,I1[22:0]};
       O6_2 = {1'b1 ,I2[22:0]} >> r1;
    end          
endmodule

module block3(output reg O1_3,
              output reg O2_3,
              output reg [7:0] O3_3,
              output reg [7:0] O4_3,
              output reg [23:0] O5_3,
              output reg O6_3,
              input I1_3,
              input I2_3,
              input [7:0] I3_3,
              input [7:0] I4_3,
              input [23:0] I5_3,
              input [23:0] I6_3,
              input clk
              );
    reg [24:0] r1,r2;
    reg [23:0] r3;          
    always@(posedge clk)
    begin
       O1_3 <= I1_3;
       O2_3 <= I2_3;
       O3_3 <= I3_3;
       O4_3 <= I4_3;
       
       if(I1_3 != I2_3)
       begin
          r3 = (~I6_3[23:0]) + 1'b1;
       end
       else
       begin
          r3 = I6_3;
       end
       
       r1 = I5_3 + r3;
       
       if(r1[24] == 1'b1)
       O6_3 = 1'b1;
       else
       O6_3 = 1'b0;
       
       if(I1_3 != I2_3 && r1[24] == 0 && r1[23] == 1 )
       begin
          r2 = (~r1[23:0]) + 1'b1;
       end
       else
          r2 = r1[23:0];
       
       O5_3 = r2;
    end          
endmodule

module block4(output reg O1_4,
              output reg O2_4,
              output reg [7:0] O3_4,
              output reg [7:0] O4_4,
              output reg [23:0] O5_4,
              output reg [5:0] O6_4,
              input I1_4,
              input I2_4,
              input [7:0] I3_4,
              input [7:0] I4_4,
              input [23:0] I5_4,
              input I6_4,
              input clk);
    
    reg [23:0] r1_4,r2_4;
    integer i;          
    always@(posedge clk)
    begin
       // Normalization
       i = 23;
       O1_4 = I1_4;
       O2_4 = I2_4;
       O3_4 = I3_4;
       O4_4 = I4_4;
       
       
       r2_4 = I5_4;
       if(I1_4 == I2_4 && I6_4 == 1'b1)
       begin
//          r1_4 = I5_4 >> 1;
//          r1_4[23] = 1'b1;
          r1_4 = {1'b1, I5_4[23:1]};  
       end
       else
       begin
          while(r2_4[i] == 1'b0 && i >= 0)
          begin
             i=i-1;
          end
          
          r1_4 = r2_4 << (23-i);
       end
       
       O5_4 = r1_4;
       O6_4 = 23-i;
    end          
endmodule

module block5(output reg [31:0] O1_5,
              input I1_5,
              input I2_5,
              input [7:0] I3_5,
              input [7:0] I4_5,
              input [23:0] I5_5,
              input [5:0] I6_5,
              input clk);
              
    always@(posedge clk)
    begin
       if(I3_5 > I4_5)
         O1_5[31] = I1_5;
       else if(I3_5 < I4_5)
         O1_5[31] = I2_5;

       O1_5[30:23] = I3_5 + I6_5;
       O1_5[22:0] = I5_5[22:0];
    end
endmodule


module adder(output reg [31:0] N,
             input wire [31:0] A_0,
             input wire [31:0] B_0,
             input clk 
             );
    
    reg [31:0] result[31:0];
    integer i = -1;         
    reg [31:0] N1_1,N2_1;
    wire [31:0] w1_1, w2_1;
    
    block1 b1(w1_1,w2_1,A_0,B_0,clk);
    
    always@(w1_1,w2_1)
    begin
       N1_1 <= w1_1;
       N2_1 <= w2_1;
    end  
    
    reg sn1_2, sn2_2;
    reg [7:0] e1_2,e2_2;
    reg [23:0] s1_2,s2_2;
    wire w1_2,w2_2;
    wire [7:0] w3_2,w4_2;
    wire [23:0] w5_2,w6_2;
    
    block2 b2(w1_2,w2_2,w3_2,w4_2,w5_2,w6_2,N1_1,N2_1,clk);
    
    always@(w1_2, w2_2, w3_2, w4_2, w5_2, w6_2)
    begin
       sn1_2 <= w1_2;
       sn2_2 <= w2_2;
       e1_2 <= w3_2;
       e2_2 <= w4_2;
       s1_2 <= w5_2;
       s2_2 <= w6_2;
    end
    
    reg sn1_3, sn2_3;
    reg [7:0] e1_3, e2_3;
    reg [23:0] s_3;
    reg c_3;
    wire w1_3,w2_3;
    wire [7:0] w3_3, w4_3;
    wire [23:0] w5_3;
    wire w6_3;
     
    block3 b3(w1_3,w2_3,w3_3,w4_3,w5_3,w6_3,sn1_2,sn2_2,e1_2,e2_2,s1_2,s2_2,clk);
    
    always@(w1_3, w2_3, w3_3, w4_3, w5_3, w6_3)
    begin
       sn1_3 <= #1 w1_3;
       sn2_3 <= #1 w2_3;
       e1_3 <= #1 w3_3;
       e2_3 <= #1 w4_3;
       s_3 <= #1 w5_3;
       c_3 <= #1 w6_3;
    end
    
    reg sn1_4, sn2_4;
    reg [7:0] e1_4, e2_4;
    reg [31:0] s_4;
    reg [5:0] counter_4;
    wire w1_4,w2_4;
    wire [7:0] w3_4, w4_4;
    wire [31:0] w5_4;
    wire [5:0] w6_4;
    
    block4 b4(w1_4,w2_4,w3_4,w4_4,w5_4,w6_4,sn1_3,sn2_3,e1_3,e2_3,s_3,c_3,clk);
    
    always@(w1_4, w2_4, w3_4, w4_4, w5_4, w6_4)
    begin
       sn1_4 <= #1 w1_4;
       sn2_4 <= #1 w2_4;
       e1_4 <= #1 w3_4;
       e2_4 <= #1 w4_4;
       s_4 <= #1 w5_4;
       counter_4 <= #1 w6_4;
    end
    
    
    wire [31:0] w1_5;
    
    block5 b5(w1_5,sn1_4,sn2_4,e1_4,e2_4,s_4,counter_4,clk);
    
    always@(w1_5)
    begin
       N <= w1_5;
    end
    
    always@(N)
    begin
       result[i] = N;
       i = i+1;
    end
    
endmodule
