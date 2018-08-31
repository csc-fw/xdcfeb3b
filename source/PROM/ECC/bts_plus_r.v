`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////
//                                                           //
// (B transpose * S) plus R                                  //
//                                                           //
///////////////////////////////////////////////////////////////

module bts_plus_r(
    input CLK,
    input [11:0] BTS,
    output reg [23:0] E,
    output reg USE
);

reg [11:0] BTSR1;
reg [11:0] BTSR2;
reg [11:0] BTSR3;
reg [11:0] BTSR4;
reg [11:0] BTSR5;
reg [11:0] BTSR6;
reg [11:0] BTSR7;
reg [11:0] BTSR8;
reg [11:0] BTSR9;
reg [11:0] BTSR10;
reg [11:0] BTSR11;
reg [11:0] BTSR12;
reg [11:0] BTSR1_1;
reg [11:0] BTSR2_1;
reg [11:0] BTSR3_1;
reg [11:0] BTSR4_1;
reg [11:0] BTSR5_1;
reg [11:0] BTSR6_1;
reg [11:0] BTSR7_1;
reg [11:0] BTSR8_1;
reg [11:0] BTSR9_1;
reg [11:0] BTSR10_1;
reg [11:0] BTSR11_1;
reg [11:0] BTSR12_1;

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
   BTSR1   <= BTS^`BR1;
   BTSR2   <= BTS^`BR2;
   BTSR3   <= BTS^`BR3;
   BTSR4   <= BTS^`BR4;
   BTSR5   <= BTS^`BR5;
   BTSR6   <= BTS^`BR6;
   BTSR7   <= BTS^`BR7;
   BTSR8   <= BTS^`BR8;
   BTSR9   <= BTS^`BR9;
   BTSR10  <= BTS^`BR10;
   BTSR11  <= BTS^`BR11;
   BTSR12  <= BTS^`BR12;
   BTSR1_1   <= BTSR1;
   BTSR2_1   <= BTSR2;
   BTSR3_1   <= BTSR3;
   BTSR4_1   <= BTSR4;
   BTSR5_1   <= BTSR5;
   BTSR6_1   <= BTSR6;
   BTSR7_1   <= BTSR7;
   BTSR8_1   <= BTSR8;
   BTSR9_1   <= BTSR9;
   BTSR10_1  <= BTSR10;
   BTSR11_1  <= BTSR11;
   BTSR12_1  <= BTSR12;
end

wlteq2  w2btsr1(.CLK(CLK),.V(BTSR1),.WLTEQ2(WLTEQ2[11]));
wlteq2  w2btsr2(.CLK(CLK),.V(BTSR2),.WLTEQ2(WLTEQ2[10]));
wlteq2  w2btsr3(.CLK(CLK),.V(BTSR3),.WLTEQ2(WLTEQ2[9]));
wlteq2  w2btsr4(.CLK(CLK),.V(BTSR4),.WLTEQ2(WLTEQ2[8]));
wlteq2  w2btsr5(.CLK(CLK),.V(BTSR5),.WLTEQ2(WLTEQ2[7]));
wlteq2  w2btsr6(.CLK(CLK),.V(BTSR6),.WLTEQ2(WLTEQ2[6]));
wlteq2  w2btsr7(.CLK(CLK),.V(BTSR7),.WLTEQ2(WLTEQ2[5]));
wlteq2  w2btsr8(.CLK(CLK),.V(BTSR8),.WLTEQ2(WLTEQ2[4]));
wlteq2  w2btsr9(.CLK(CLK),.V(BTSR9),.WLTEQ2(WLTEQ2[3]));
wlteq2 w2btsr10(.CLK(CLK),.V(BTSR10),.WLTEQ2(WLTEQ2[2]));
wlteq2 w2btsr11(.CLK(CLK),.V(BTSR11),.WLTEQ2(WLTEQ2[1]));
wlteq2 w2btsr12(.CLK(CLK),.V(BTSR12),.WLTEQ2(WLTEQ2[0]));

always @(posedge CLK)
begin
   casex(WLTEQ2)
      12'h000:
         E <= 24'hFFFFFF;
      12'b1xxxxxxxxxxx:
         E <= {`IDR1,BTSR1_1};
      12'b01xxxxxxxxxx:
         E <= {`IDR2,BTSR2_1};
      12'b001xxxxxxxxx:
         E <= {`IDR3,BTSR3_1};
      12'b0001xxxxxxxx:
         E <= {`IDR4,BTSR4_1};
      12'b00001xxxxxxx:
         E <= {`IDR5,BTSR5_1};
      12'b000001xxxxxx:
         E <= {`IDR6,BTSR6_1};
      12'b0000001xxxxx:
         E <= {`IDR7,BTSR7_1};
      12'b00000001xxxx:
         E <= {`IDR8,BTSR8_1};
      12'b000000001xxx:
         E <= {`IDR9,BTSR9_1};
      12'b0000000001xx:
         E <= {`IDR10,BTSR10_1};
      12'b00000000001x:
         E <= {`IDR11,BTSR11_1};
      12'b000000000001:
         E <= {`IDR12,BTSR12_1};
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

