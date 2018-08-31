`timescale 1ns / 1ps


///////////////////////////////////////////////////////////////
//                                                           //
// DECODER for Golay(24,12) ECC code                         //
//                                                           //
///////////////////////////////////////////////////////////////

module ecc_decode(
    input CLK,
    input [11:0] RCV_DATA,
    input [11:0] RCV_PARITY,
    output GOOD_WORD,
    output [11:0] DCD_DATA,
    output [11:0] DCD_PARITY,
    output BAD_TX
);

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

syndrome
synd1(
	.CLK(CLK),
	.RD(RCV_DATA),
	.RP(RCV_PARITY),
	.S(S)
);

bts
bts1(
	.CLK(CLK),
	.S(S),
	.BTS(BTS)
);

wlteq3
wlteq3_1(
	.CLK(CLK),
	.V(S_3),
	.WLTEQ3(S_USE)
);

s_plus_i
spi_1(
	.CLK(CLK),
	.S(S_1),
	.E(SI_E),
	.USE(SI_USE)
);

wlteq3
wlteq3_2(
	.CLK(CLK),
	.V(BTS_2),
	.WLTEQ3(BTS_USE)
);

bts_plus_r
bpr_1(
	.CLK(CLK),
	.BTS(BTS),
	.E(BTSR_E),
	.USE(BTSR_USE)
);

decode_mux
dm_1(
	.CLK(CLK),
	.S_USE(S_USE),
	.SI_USE(SI_USE),
	.BTS_USE(BTS_USE),
	.BTSR_USE(BTSR_USE),
	.RD(RCV_DATA_5),
	.RP(RCV_PARITY_5),
	.S(S_4),
	.SI_E(SI_E),
	.BTS(BTS_3),
	.BTSR_E(BTSR_E),
	.DOUT(DCD_DATA),
	.POUT(DCD_PARITY),
	.VALID(GOOD_WORD),
	.CORUPT(BAD_TX)
);

endmodule

