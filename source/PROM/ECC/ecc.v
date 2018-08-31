
`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////
//                                                           //
// ENCODER for Golay(24,12) ECC code                         //
//                                                           //
///////////////////////////////////////////////////////////////

module ecc_encode(CLK,DATA,PARITY);
    input CLK;
    input [11:0] DATA;
    output [11:0] PARITY;

reg [11:0] PARITY;

`ifdef HEADER
`else
`include "header.v"
`endif

always @(posedge CLK)
begin
   PARITY[11] <= ^(DATA&`BI1);
   PARITY[10] <= ^(DATA&`BI2);
   PARITY[9] <= ^(DATA&`BI3);
   PARITY[8] <= ^(DATA&`BI4);
   PARITY[7] <= ^(DATA&`BI5);
   PARITY[6] <= ^(DATA&`BI6);
   PARITY[5] <= ^(DATA&`BI7);
   PARITY[4] <= ^(DATA&`BI8);
   PARITY[3] <= ^(DATA&`BI9);
   PARITY[2] <= ^(DATA&`BI10);
   PARITY[1] <= ^(DATA&`BI11);
   PARITY[0] <= ^(DATA&`BI12);
end

endmodule



///////////////////////////////////////////////////////////////
//                                                           //
// DECODER for Golay(24,12) ECC code                         //
//                                                           //
///////////////////////////////////////////////////////////////

module ecc_decode(CLK,RCV_DATA,RCV_PARITY,GOOD_WORD,DCD_DATA,DCD_PARITY,BAD_TX);

    input CLK;
    input [11:0] RCV_DATA;
    input [11:0] RCV_PARITY;
    output GOOD_WORD;
    output [11:0] DCD_DATA;
    output [11:0] DCD_PARITY;
    output BAD_TX;


wire GOOD_WORD;
wire [11:0] DCD_DATA;
wire [11:0] DCD_PARITY;
wire BAD_TX;

reg [11:0] RCV_DATA_1;
reg [11:0] RCV_DATA_2;
reg [11:0] RCV_DATA_3;
reg [11:0] RCV_DATA_4;
reg [11:0] RCV_DATA_5;
reg [11:0] RCV_PARITY_1;
reg [11:0] RCV_PARITY_2;
reg [11:0] RCV_PARITY_3;
reg [11:0] RCV_PARITY_4;
reg [11:0] RCV_PARITY_5;
wire [11:0] S;
reg [11:0] S_1;
reg [11:0] S_2;
reg [11:0] S_3;
reg [11:0] S_4;
wire [11:0] BTS;
reg [11:0] BTS_1;
reg [11:0] BTS_2;
reg [11:0] BTS_3;

wire S_USE;
wire SI_USE;
wire BTS_USE;
wire BTSR_USE;
wire [23:0] SI_E;
wire [23:0] BTSR_E;

always @(posedge CLK)
begin
   RCV_DATA_1 <= RCV_DATA;
   RCV_DATA_2 <= RCV_DATA_1;
   RCV_DATA_3 <= RCV_DATA_2;
   RCV_DATA_4 <= RCV_DATA_3;
   RCV_DATA_5 <= RCV_DATA_4;
   RCV_PARITY_1 <= RCV_PARITY;
   RCV_PARITY_2 <= RCV_PARITY_1;
   RCV_PARITY_3 <= RCV_PARITY_2;
   RCV_PARITY_4 <= RCV_PARITY_3;
   RCV_PARITY_5 <= RCV_PARITY_4;
   S_1 <= S;
   S_2 <= S_1;
   S_3 <= S_2;
   S_4 <= S_3;
   BTS_1 <= BTS;
   BTS_2 <= BTS_1;
   BTS_3 <= BTS_2;
end

syndrome    synd1(.CLK(CLK),.RD(RCV_DATA),.RP(RCV_PARITY),.S(S));
bts         bts1(.CLK(CLK),.S(S),.BTS(BTS));
wlteq3      wlteq3_1(.CLK(CLK),.V(S_3),.WLTEQ3(S_USE));
s_plus_i    spi_1(.CLK(CLK),.S(S_1),.E(SI_E),.USE(SI_USE));
wlteq3      wlteq3_2(.CLK(CLK),.V(BTS_2),.WLTEQ3(BTS_USE));
bts_plus_r  bpr_1(.CLK(CLK),.BTS(BTS),.E(BTSR_E),.USE(BTSR_USE));
decode_mux  dm_1(.CLK(CLK),.S_USE(S_USE),.SI_USE(SI_USE),.BTS_USE(BTS_USE),.BTSR_USE(BTSR_USE),.RD(RCV_DATA_5),.RP(RCV_PARITY_5),
                 .S(S_4),.SI_E(SI_E),.BTS(BTS_3),.BTSR_E(BTSR_E),.DOUT(DCD_DATA),.POUT(DCD_PARITY),.VALID(GOOD_WORD),.CORUPT(BAD_TX));

endmodule



///////////////////////////////////////////////////////////////
//                                                           //
// Sub modules for DECODER                                   //
//                                                           //
///////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////
//                                                           //
// B transpose * S                                           //
//                                                           //
///////////////////////////////////////////////////////////////

module bts(CLK,S,BTS);
    input CLK;
    input [11:0] S;
    output [11:0] BTS;

reg [11:0] BTS;

`ifdef HEADER
`else
`include "header.v"
`endif

always @(posedge CLK)
begin
   BTS[11] <= ^(`BR1&S);
   BTS[10] <= ^(`BR2&S);
   BTS[9]  <= ^(`BR3&S);
   BTS[8]  <= ^(`BR4&S);
   BTS[7]  <= ^(`BR5&S);
   BTS[6]  <= ^(`BR6&S);
   BTS[5]  <= ^(`BR7&S);
   BTS[4]  <= ^(`BR8&S);
   BTS[3]  <= ^(`BR9&S);
   BTS[2]  <= ^(`BR10&S);
   BTS[1]  <= ^(`BR11&S);
   BTS[0]  <= ^(`BR12&S);
end
endmodule

///////////////////////////////////////////////////////////////
//                                                           //
// (B transpose * S) plus R                                  //
//                                                           //
///////////////////////////////////////////////////////////////

module bts_plus_r(CLK,BTS,E,USE);
    input CLK;
    input [11:0] BTS;
    output [23:0] E;
    output USE;

reg [23:0] E;
reg USE;

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

`ifdef HEADER
`else
`include "header.v"
`endif

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


///////////////////////////////////////////////////////////////
//                                                           //
// Decode MUX                                                //
//                                                           //
///////////////////////////////////////////////////////////////

module decode_mux(CLK,S_USE,SI_USE,BTS_USE,BTSR_USE,RD,RP,S,SI_E,BTS,BTSR_E,DOUT,POUT,VALID,CORUPT);
    input CLK;
    input S_USE;
    input SI_USE;
    input BTS_USE;
    input BTSR_USE;
    input [11:0] RD;
    input [11:0] RP;
    input [11:0] S;
    input [23:0] SI_E;
    input [11:0] BTS;
    input [23:0] BTSR_E;
    output [11:0] DOUT;
    output [11:0] POUT;
    output VALID;
    output CORUPT;

reg [11:0] DOUT;
reg [11:0] POUT;
reg VALID;
reg CORUPT;

always @(posedge CLK)
begin
   casex({S_USE,SI_USE,BTS_USE,BTSR_USE})
      4'b1xxx:
         begin
            DOUT <= RD^S;
            POUT <= RP;
            VALID <= 1;
            CORUPT <= |S;
         end
      4'b01xx:
         begin
            DOUT <= RD^SI_E[23:12];
            POUT <= RP^SI_E[11:0];
            VALID <= 1;
            CORUPT <= |SI_E;
         end
      4'b001x:
         begin
            DOUT <= RD;
            POUT <= RP^BTS;
            VALID <= 1;
            CORUPT <= |BTS;
         end
      4'b0001:
         begin
            DOUT <= RD^BTSR_E[23:12];
            POUT <= RP^BTSR_E[11:0];
            VALID <= 1;
            CORUPT <= |BTSR_E;
         end
      default:
         begin
            DOUT <= RD;
            POUT <= RP;
            VALID <= 0;
            CORUPT <= 1;
         end
   endcase
end

endmodule


///////////////////////////////////////////////////////////////
//                                                           //
// S plus I                                                  //
//                                                           //
///////////////////////////////////////////////////////////////

module s_plus_i(CLK,S,E,USE);
    input CLK;
    input [11:0] S;
    output [23:0] E;
    output USE;


reg [23:0] E;
reg USE;

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

`ifdef HEADER
`else
`include "header.v"
`endif

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


///////////////////////////////////////////////////////////////
//                                                           //
// Syndrome                                                  //
//                                                           //
///////////////////////////////////////////////////////////////

module syndrome(CLK,RD,RP,S);
    input CLK;
    input [11:0] RD;
    input [11:0] RP;
    output [11:0] S;

reg [11:0] S;

`ifdef HEADER
`else
`include "header.v"
`endif

always @(posedge CLK)
begin
   S[11] <= ^({`IDR1,`BI1}&{RD,RP});
   S[10] <= ^({`IDR2,`BI2}&{RD,RP});
   S[9]  <= ^({`IDR3,`BI3}&{RD,RP});
   S[8]  <= ^({`IDR4,`BI4}&{RD,RP});
   S[7]  <= ^({`IDR5,`BI5}&{RD,RP});
   S[6]  <= ^({`IDR6,`BI6}&{RD,RP});
   S[5]  <= ^({`IDR7,`BI7}&{RD,RP});
   S[4]  <= ^({`IDR8,`BI8}&{RD,RP});
   S[3]  <= ^({`IDR9,`BI9}&{RD,RP});
   S[2]  <= ^({`IDR10,`BI10}&{RD,RP});
   S[1]  <= ^({`IDR11,`BI11}&{RD,RP});
   S[0]  <= ^({`IDR12,`BI12}&{RD,RP});
end
endmodule



///////////////////////////////////////////////////////////////
//                                                           //
// Weight <= 2                                               //
//                                                           //
///////////////////////////////////////////////////////////////

module wlteq2(CLK,V,WLTEQ2);
    input CLK;
    input [11:0] V;
    output WLTEQ2;

reg WLTEQ2;

`ifdef HEADER
`else
`include "header.v"
`endif

always @(posedge CLK)
begin
   casex(V)
      12'h00x:
         case(V[3:0])
            4'h7,4'hB,4'hD,4'hE,4'hF:
               WLTEQ2 <= 0;
            default:
               WLTEQ2 <= 1;
         endcase
      12'h01x,12'h02x,12'h04x,12'h08x,12'h10x,12'h20x,12'h40x,12'h80x:
         case(V[3:0])
            4'h0,4'h1,4'h2,4'h4,4'h8:
               WLTEQ2 <= 1;
            default:
               WLTEQ2 <= 0;
         endcase
      12'h1x0,12'h2x0,12'h4x0,12'h8x0:
         case(V[7:4])
            4'h1,4'h2,4'h4,4'h8:
               WLTEQ2 <= 1;
            default:
               WLTEQ2 <= 0;
         endcase
     12'h030,12'h050,12'h060,12'h090,12'h0A0,12'h0C0,12'h300,12'h500,12'h600,12'h900,12'hA00,12'hC00:
         WLTEQ2 <= 1;
     default:
         WLTEQ2 <= 0;
   endcase
end
endmodule



///////////////////////////////////////////////////////////////
//                                                           //
// Weight <= 3                                               //
//                                                           //
///////////////////////////////////////////////////////////////

module wlteq3(CLK,V,WLTEQ3);
    input CLK;
    input [11:0] V;
    output WLTEQ3;

reg WLTEQ3;

`ifdef HEADER
`else
`include "header.v"
`endif

always @(posedge CLK)
begin
   casex(V)
      12'h00x:
         case(V[3:0])
            4'hF: 
               WLTEQ3 <= 0;
            default:
               WLTEQ3 <= 1;
         endcase
      12'h01x,12'h02x,12'h04x,12'h08x,12'h10x,12'h20x,12'h40x,12'h80x:
         case(V[3:0])
            4'h7,4'hB,4'hD,4'hE,4'hF:
               WLTEQ3 <= 0;
            default:
               WLTEQ3 <= 1;
         endcase
      12'h03x,12'h05x,12'h06x,12'h09x,12'h0Ax,12'h0Cx,12'h11x,12'h12x,12'h14x,12'h18x,12'h21x,12'h22x,12'h24x,12'h28x:
         case(V[3:0])
            4'h0,4'h1,4'h2,4'h4,4'h8:
               WLTEQ3 <= 1;
            default:
               WLTEQ3 <= 0;
         endcase
      12'h30x,12'h41x,12'h42x,12'h44x,12'h48x,12'h50x,12'h60x,12'h81x,12'h82x,12'h84x,12'h88x,12'h90x,12'hA0x,12'hC0x:
         case(V[3:0])
            4'h0,4'h1,4'h2,4'h4,4'h8:
               WLTEQ3 <= 1;
            default:
               WLTEQ3 <= 0;
         endcase
      12'h1x0,12'h2x0,12'h4x0,12'h8x0:
         case(V[7:4])
            4'h3,4'h5,4'h6,4'h9,4'hA,4'hC:
               WLTEQ3 <= 1;
            default:
               WLTEQ3 <= 0;
         endcase
      12'h3x0,12'h5x0,12'h6x0,12'h9x0,12'hAx0,12'hCx0:
         case(V[7:4])
            4'h1,4'h2,4'h4,4'h8:
               WLTEQ3 <= 1;
            default:
               WLTEQ3 <= 0;
         endcase
      12'h070,12'h0B0,12'h0D0,12'h0E0,12'h700,12'hB00,12'hD00,12'hE00:
         WLTEQ3 <= 1;
      default:
         WLTEQ3 <= 0;
   endcase
end
endmodule
