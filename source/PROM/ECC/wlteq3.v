`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////
//                                                           //
// Weight <= 3                                               //
//                                                           //
///////////////////////////////////////////////////////////////

module wlteq3(
    input CLK,
    input [11:0] V,
    output reg WLTEQ3
);

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
