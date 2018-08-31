`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////
//                                                           //
// Weight <= 2                                               //
//                                                           //
///////////////////////////////////////////////////////////////

module wlteq2(
    input CLK,
    input [11:0] V,
    output reg WLTEQ2
);

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

