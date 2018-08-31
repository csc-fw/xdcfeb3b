
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2018:08:30 at 15:36:36 (www.fizzim.com)

module Prom_Xfer_FSM 
  #(
    parameter MAX_WRDS = 9'd34,
    parameter NMAX = 9'd10
  )(
  output reg CE,
  output reg INC,
  output reg LDB0,
  output reg LDB1,
  output reg LDB2,
  output reg LDB3,
  output reg LDB4,
  output reg LDB5,
  output reg OE,
  output reg RST_CNT,
  output reg XFER_DONE,
  output wire [3:0] PXFER_STATE,
  input CLK,
  input wire [8:0] CNT,
  input CRC,
  input ECC,
  input PROM2FF,
  input RST 
);

  // state bits
  parameter 
  Idle      = 4'b0000, 
  Byte0     = 4'b0001, 
  Byte1     = 4'b0010, 
  Byte2     = 4'b0011, 
  Byte3     = 4'b0100, 
  Byte4     = 4'b0101, 
  Byte5     = 4'b0110, 
  Chip_Ena  = 4'b0111, 
  Disable   = 4'b1000, 
  Wait4Xfer = 4'b1001; 

  reg [3:0] state;

  assign PXFER_STATE = state;

  reg [3:0] nextstate;


  reg [3:0] tmr;

  // comb always block
  always @* begin
    nextstate = 4'bxxxx; // default to x because default_state_is_x is set
    case (state)
      Idle     :                                              nextstate = Chip_Ena;
      Byte0    :                                              nextstate = Byte1;
      Byte1    : if      (ECC)                                nextstate = Byte2;
                 else if (CRC && CNT==(NMAX*(MAX_WRDS+2))-1)  nextstate = Disable;
                 else if (!CRC && CNT==(NMAX*MAX_WRDS)-1)     nextstate = Disable;
                 else                                         nextstate = Byte0;
      Byte2    :                                              nextstate = Byte3;
      Byte3    :                                              nextstate = Byte4;
      Byte4    :                                              nextstate = Byte5;
      Byte5    : if      (CRC && CNT==(NMAX*(MAX_WRDS+2))-1)  nextstate = Disable;
                 else if (!CRC && CNT==(NMAX*MAX_WRDS)-1)     nextstate = Disable;
                 else                                         nextstate = Byte0;
      Chip_Ena : if      (tmr == 4'd10)                       nextstate = Byte0;
                 else                                         nextstate = Chip_Ena;
      Disable  : if      (!PROM2FF)                           nextstate = Wait4Xfer;
                 else                                         nextstate = Disable;
      Wait4Xfer: if      (PROM2FF)                            nextstate = Chip_Ena;
                 else                                         nextstate = Wait4Xfer;
    endcase
  end

  // Assign reg'd outputs to state bits

  // sequential always block
  always @(posedge CLK or posedge RST) begin
    if (RST)
      state <= Idle;
    else
      state <= nextstate;
  end

  // datapath sequential always block
  always @(posedge CLK or posedge RST) begin
    if (RST) begin
      CE <= 0;
      INC <= 0;
      LDB0 <= 0;
      LDB1 <= 0;
      LDB2 <= 0;
      LDB3 <= 0;
      LDB4 <= 0;
      LDB5 <= 0;
      OE <= 0;
      RST_CNT <= 1;
      XFER_DONE <= 0;
      tmr <= 0;
    end
    else begin
      CE <= 1; // default
      INC <= 0; // default
      LDB0 <= 0; // default
      LDB1 <= 0; // default
      LDB2 <= 0; // default
      LDB3 <= 0; // default
      LDB4 <= 0; // default
      LDB5 <= 0; // default
      OE <= 1; // default
      RST_CNT <= 0; // default
      XFER_DONE <= 0; // default
      tmr <= 0; // default
      case (nextstate)
        Idle     : begin
                          CE <= 0;
                          OE <= 0;
                          RST_CNT <= 1;
        end
        Byte0    :        LDB0 <= 1;
        Byte1    : begin
                          INC <= !ECC;
                          LDB1 <= 1;
        end
        Byte2    :        LDB2 <= 1;
        Byte3    :        LDB3 <= 1;
        Byte4    :        LDB4 <= 1;
        Byte5    : begin
                          INC <= 1;
                          LDB5 <= 1;
        end
        Chip_Ena : begin
                          OE <= 0;
                          RST_CNT <= 1;
                          tmr <= tmr+1;
        end
        Disable  :        OE <= 0;
        Wait4Xfer: begin
                          CE <= 0;
                          OE <= 0;
                          XFER_DONE <= 1;
        end
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [71:0] statename;
  always @* begin
    case (state)
      Idle     : statename = "Idle";
      Byte0    : statename = "Byte0";
      Byte1    : statename = "Byte1";
      Byte2    : statename = "Byte2";
      Byte3    : statename = "Byte3";
      Byte4    : statename = "Byte4";
      Byte5    : statename = "Byte5";
      Chip_Ena : statename = "Chip_Ena";
      Disable  : statename = "Disable";
      Wait4Xfer: statename = "Wait4Xfer";
      default  : statename = "XXXXXXXXX";
    endcase
  end
  `endif

endmodule

