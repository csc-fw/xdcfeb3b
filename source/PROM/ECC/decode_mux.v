`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////
//                                                           //
// Decode MUX                                                //
//                                                           //
///////////////////////////////////////////////////////////////

module decode_mux(
    input CLK,
    input S_USE,
    input SI_USE,
    input BTS_USE,
    input BTSR_USE,
    input [11:0] RD,
    input [11:0] RP,
    input [11:0] S,
    input [23:0] SI_E,
    input [11:0] BTS,
    input [23:0] BTSR_E,
    output reg [11:0] DOUT,
    output reg [11:0] POUT,
    output reg VALID,
    output reg CORUPT
);

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

