`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////
//                                                           //
// S plus I                                                  //
//                                                           //
///////////////////////////////////////////////////////////////

module s_plus_i(
    input CLK,
    input [11:0] S,
    output reg [23:0] E,
    output reg USE
);

reg [11:0] SI1;
reg [11:0] SI2;
reg [11:0] SI3;
reg [11:0] SI4;
reg [11:0] SI5;
reg [11:0] SI6;
reg [11:0] SI7;
reg [11:0] SI8;
reg [11:0] SI9;
reg [11:0] SI10;
reg [11:0] SI11;
reg [11:0] SI12;
reg [11:0] SI1_1;
reg [11:0] SI2_1;
reg [11:0] SI3_1;
reg [11:0] SI4_1;
reg [11:0] SI5_1;
reg [11:0] SI6_1;
reg [11:0] SI7_1;
reg [11:0] SI8_1;
reg [11:0] SI9_1;
reg [11:0] SI10_1;
reg [11:0] SI11_1;
reg [11:0] SI12_1;

wire [11:0]WLTEQ2;

////////////////////////////////////////////////////////////////////////////////////////////////////////
// -------------------------------------------------------------------------------------------------- //
// ================================= Error Checking and Correcting code definitiions ================ //
// -------------------------------------------------------------------------------------------------- //
////////////////////////////////////////////////////////////////////////////////////////////////////////

// Columns of Parity part of Generator Matrix for ECC code Golay(24,12)
`define  BI1   12'h7FF
`define  BI2   12'hEE2
`define  BI3   12'hDC5
`define  BI4   12'hB8B
`define  BI5   12'hF16
`define  BI6   12'hE2D
`define  BI7   12'hC5B
`define  BI8   12'h8B7
`define  BI9   12'h96E
`define  BI10  12'hADC
`define  BI11  12'hDB8
`define  BI12  12'hB71

// Rows of Parity part of Generator Matrix for ECC code Golay(24,12)
`define  BR1   12'h7FF
`define  BR2   12'hEE2
`define  BR3   12'hDC5
`define  BR4   12'hB8B
`define  BR5   12'hF16
`define  BR6   12'hE2D
`define  BR7   12'hC5B
`define  BR8   12'h8B7
`define  BR9   12'h96E
`define  BR10  12'hADC
`define  BR11  12'hDB8
`define  BR12  12'hB71

// Rows of Identity matrix
`define  IDR1   12'h800
`define  IDR2   12'h400
`define  IDR3   12'h200
`define  IDR4   12'h100
`define  IDR5   12'h080
`define  IDR6   12'h040
`define  IDR7   12'h020
`define  IDR8   12'h010
`define  IDR9   12'h008
`define  IDR10  12'h004
`define  IDR11  12'h002
`define  IDR12  12'h001


always @(posedge CLK)
begin
   SI1   <= S^`BI1;
   SI2   <= S^`BI2;
   SI3   <= S^`BI3;
   SI4   <= S^`BI4;
   SI5   <= S^`BI5;
   SI6   <= S^`BI6;
   SI7   <= S^`BI7;
   SI8   <= S^`BI8;
   SI9   <= S^`BI9;
   SI10  <= S^`BI10;
   SI11  <= S^`BI11;
   SI12  <= S^`BI12;
   SI1_1   <= SI1;
   SI2_1   <= SI2;
   SI3_1   <= SI3;
   SI4_1   <= SI4;
   SI5_1   <= SI5;
   SI6_1   <= SI6;
   SI7_1   <= SI7;
   SI8_1   <= SI8;
   SI9_1   <= SI9;
   SI10_1  <= SI10;
   SI11_1  <= SI11;
   SI12_1  <= SI12;
end

wlteq2  w2si1(.CLK(CLK),.V(SI1),.WLTEQ2(WLTEQ2[11]));
wlteq2  w2si2(.CLK(CLK),.V(SI2),.WLTEQ2(WLTEQ2[10]));
wlteq2  w2si3(.CLK(CLK),.V(SI3),.WLTEQ2(WLTEQ2[9]));
wlteq2  w2si4(.CLK(CLK),.V(SI4),.WLTEQ2(WLTEQ2[8]));
wlteq2  w2si5(.CLK(CLK),.V(SI5),.WLTEQ2(WLTEQ2[7]));
wlteq2  w2si6(.CLK(CLK),.V(SI6),.WLTEQ2(WLTEQ2[6]));
wlteq2  w2si7(.CLK(CLK),.V(SI7),.WLTEQ2(WLTEQ2[5]));
wlteq2  w2si8(.CLK(CLK),.V(SI8),.WLTEQ2(WLTEQ2[4]));
wlteq2  w2si9(.CLK(CLK),.V(SI9),.WLTEQ2(WLTEQ2[3]));
wlteq2 w2si10(.CLK(CLK),.V(SI10),.WLTEQ2(WLTEQ2[2]));
wlteq2 w2si11(.CLK(CLK),.V(SI11),.WLTEQ2(WLTEQ2[1]));
wlteq2 w2si12(.CLK(CLK),.V(SI12),.WLTEQ2(WLTEQ2[0]));

always @(posedge CLK)
begin
   casex(WLTEQ2)
      12'h000:
         E <= 24'hFFFFFF;
      12'b1xxxxxxxxxxx:
         E <= {SI1_1,`IDR1};
      12'b01xxxxxxxxxx:
         E <= {SI2_1,`IDR2};
      12'b001xxxxxxxxx:
         E <= {SI3_1,`IDR3};
      12'b0001xxxxxxxx:
         E <= {SI4_1,`IDR4};
      12'b00001xxxxxxx:
         E <= {SI5_1,`IDR5};
      12'b000001xxxxxx:
         E <= {SI6_1,`IDR6};
      12'b0000001xxxxx:
         E <= {SI7_1,`IDR7};
      12'b00000001xxxx:
         E <= {SI8_1,`IDR8};
      12'b000000001xxx:
         E <= {SI9_1,`IDR9};
      12'b0000000001xx:
         E <= {SI10_1,`IDR10};
      12'b00000000001x:
         E <= {SI11_1,`IDR11};
      12'b000000000001:
         E <= {SI12_1,`IDR12};
      default:
         E <= 24'hFFFFFF;
   endcase       
end
always @(posedge CLK)
begin
   if(WLTEQ2!=0)
      USE <= 1;
   else
      USE <= 0;
end
endmodule

