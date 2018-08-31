
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2018:07:23 at 16:43:32 (www.fizzim.com)

module Read_PF_FSM (
  output reg [15:0] OUT_DATA,
  output reg RD_EN,
  input CLK,
  input wire [15:0] DCDWRD,
  input DECODE,
  input ECC,
  input wire [47:0] FFWRD,
  input PF_RD,
  input RST 
);

  // state bits
  parameter 
  Wrd_Dcd = 3'b000, 
  No_ECC  = 3'b001, 
  Wrd_0   = 3'b010, 
  Wrd_1   = 3'b011, 
  Wrd_2   = 3'b100; 

  reg [2:0] state;


  reg [2:0] nextstate;



  // comb always block
  always @* begin
    nextstate = 3'bxxx; // default to x because default_state_is_x is set
    OUT_DATA = 16'H0000; // default
    RD_EN = 0; // default
    case (state)
      Wrd_Dcd: begin
        // Warning C7: Combinational output OUT_DATA[15:0] is assigned on transitions, but has a non-default value "DCDWRD" in state Wrd_Dcd 
                                  OUT_DATA = DCDWRD;
        // Warning C7: Combinational output RD_EN is assigned on transitions, but has a non-default value "PF_RD" in state Wrd_Dcd 
                                  RD_EN = PF_RD;
        if      (!ECC)            nextstate = No_ECC;
        else if (!DECODE && ECC)  nextstate = Wrd_0;
        else                      nextstate = Wrd_Dcd;
      end
      No_ECC : begin
        // Warning C7: Combinational output OUT_DATA[15:0] is assigned on transitions, but has a non-default value "FFWRD[15:0]" in state No_ECC 
                                  OUT_DATA = FFWRD[15:0];
        // Warning C7: Combinational output RD_EN is assigned on transitions, but has a non-default value "PF_RD" in state No_ECC 
                                  RD_EN = PF_RD;
        if      (DECODE && ECC)   nextstate = Wrd_Dcd;
        else if (!DECODE && ECC)  nextstate = Wrd_0;
        else                      nextstate = No_ECC;
      end
      Wrd_0  : begin
        // Warning C7: Combinational output OUT_DATA[15:0] is assigned on transitions, but has a non-default value "FFWRD[15:0]" in state Wrd_0 
                                  OUT_DATA = FFWRD[15:0];
        if      (!ECC)            nextstate = No_ECC;
        else if (DECODE && ECC)   nextstate = Wrd_Dcd;
        else if (PF_RD)           nextstate = Wrd_1;
        else                      nextstate = Wrd_0;
      end
      Wrd_1  : begin
        // Warning C7: Combinational output OUT_DATA[15:0] is assigned on transitions, but has a non-default value "FFWRD[31:16]" in state Wrd_1 
                                  OUT_DATA = FFWRD[31:16];
        if      (PF_RD)           nextstate = Wrd_2;
        else                      nextstate = Wrd_1;
      end
      Wrd_2  : begin
        // Warning C7: Combinational output OUT_DATA[15:0] is assigned on transitions, but has a non-default value "FFWRD[47:32]" in state Wrd_2 
                                  OUT_DATA = FFWRD[47:32];
        if      (PF_RD) begin
                                  nextstate = Wrd_0;
                                  RD_EN = 1;
        end
        else                      nextstate = Wrd_2;
      end
    endcase
  end

  // Assign reg'd outputs to state bits

  // sequential always block
  always @(posedge CLK or posedge RST) begin
    if (RST)
      state <= Wrd_Dcd;
    else
      state <= nextstate;
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [55:0] statename;
  always @* begin
    case (state)
      Wrd_Dcd: statename = "Wrd_Dcd";
      No_ECC : statename = "No_ECC";
      Wrd_0  : statename = "Wrd_0";
      Wrd_1  : statename = "Wrd_1";
      Wrd_2  : statename = "Wrd_2";
      default: statename = "XXXXXXX";
    endcase
  end
  `endif

endmodule

