
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2018:05:21 at 14:42:21 (www.fizzim.com)

module Auto_Load_Param_FSM 
  #(
    parameter MAX_ATMPT = 9'd5,
    parameter MAX_WRDS = 9'd34
  )(
  output reg AL_PF_RD,
  output reg AL_PROM2FF,
  output reg CLR_CRC,
  output reg CRC_DV,
  output wire [2:0] AL_STATE,
  input CLK,
  input CRC,
  input CRC_GOOD,
  input CRC_RDY,
  input MAN_AL,
  input RST,
  input XFER_DONE 
);

  // state bits
  parameter 
  Idle       = 3'b000, 
  CHK_CRC    = 3'b001, 
  CRC_Calc   = 3'b010, 
  Next_Atmpt = 3'b011, 
  Read_FIFO  = 3'b100, 
  Start_Xfer = 3'b101, 
  Sync       = 3'b110, 
  Wait4Xfer  = 3'b111; 

  reg [2:0] state;

  assign AL_STATE = state;

  reg [2:0] nextstate;


  reg [5:0] al_cnt;
  reg [3:0] atmpt_cnt;

  // comb always block
  always @* begin
    nextstate = 3'bxxx; // default to x because default_state_is_x is set
    case (state)
      Idle      : if      (XFER_DONE)                                     nextstate = Read_FIFO;
                  else                                                    nextstate = Idle;
      CHK_CRC   : if      (CRC_RDY && !CRC_GOOD && atmpt_cnt==MAX_ATMPT)  nextstate = Wait4Xfer;
                  else if (CRC_RDY && !CRC_GOOD)                          nextstate = Next_Atmpt;
                  else if (CRC_RDY && CRC_GOOD)                           nextstate = Wait4Xfer;
                  else                                                    nextstate = CHK_CRC;
      CRC_Calc  :                                                         nextstate = CHK_CRC;
      Next_Atmpt:                                                         nextstate = Read_FIFO;
      Read_FIFO : if      (CRC && al_cnt==(MAX_WRDS+2))                   nextstate = CRC_Calc;
                  else if (!CRC && al_cnt==MAX_WRDS)                      nextstate = Wait4Xfer;
                  else                                                    nextstate = Read_FIFO;
      Start_Xfer:                                                         nextstate = Sync;
      Sync      : if      (!XFER_DONE)                                    nextstate = Idle;
                  else                                                    nextstate = Sync;
      Wait4Xfer : if      (MAN_AL)                                        nextstate = Start_Xfer;
                  else                                                    nextstate = Wait4Xfer;
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
      AL_PF_RD <= 0;
      AL_PROM2FF <= 0;
      CLR_CRC <= 0;
      CRC_DV <= 0;
      al_cnt <= 6'h00;
      atmpt_cnt <= 4'h0;
    end
    else begin
      AL_PF_RD <= 0; // default
      AL_PROM2FF <= 0; // default
      CLR_CRC <= 0; // default
      CRC_DV <= 0; // default
      al_cnt <= 6'h00; // default
      atmpt_cnt <= 4'h0; // default
      case (nextstate)
        Idle      :        CLR_CRC <= 1;
        CHK_CRC   : begin
                           al_cnt <= al_cnt;
                           atmpt_cnt <= atmpt_cnt;
        end
        CRC_Calc  : begin
                           CRC_DV <= 1;
                           al_cnt <= al_cnt;
                           atmpt_cnt <= atmpt_cnt;
        end
        Next_Atmpt: begin
                           CLR_CRC <= 1;
                           atmpt_cnt <= atmpt_cnt+1;
        end
        Read_FIFO : begin
                           AL_PF_RD <= 1;
                           CRC_DV <= 1;
                           al_cnt <= al_cnt+1;
                           atmpt_cnt <= atmpt_cnt;
        end
        Start_Xfer:        AL_PROM2FF <= 1;
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [79:0] statename;
  always @* begin
    case (state)
      Idle      : statename = "Idle";
      CHK_CRC   : statename = "CHK_CRC";
      CRC_Calc  : statename = "CRC_Calc";
      Next_Atmpt: statename = "Next_Atmpt";
      Read_FIFO : statename = "Read_FIFO";
      Start_Xfer: statename = "Start_Xfer";
      Sync      : statename = "Sync";
      Wait4Xfer : statename = "Wait4Xfer";
      default   : statename = "XXXXXXXXXX";
    endcase
  end
  `endif

endmodule

