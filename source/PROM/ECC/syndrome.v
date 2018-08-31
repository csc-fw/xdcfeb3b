`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////
//                                                           //
// Syndrome                                                  //
//                                                           //
///////////////////////////////////////////////////////////////

module syndrome(
    input CLK,
    input [11:0] RD,
    input [11:0] RP,
    output reg [11:0] S
);

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
