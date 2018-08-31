`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////
//                                                           //
// ENCODER for Golay(24,12) ECC code                         //
//                                                           //
///////////////////////////////////////////////////////////////

module ecc_encode(
    input CLK,
    input [11:0] DATA,
    output [11:0] PARITY
);

reg [11:0] PARITY;

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

