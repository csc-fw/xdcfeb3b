
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2018:12:04 at 16:28:40 (www.fizzim.com)

module Auto_Load_Param_FSM 
  #(
    parameter MAX_ATMPT = 9'd5,
    parameter MAX_WRDS = 9'd34
  )(
  output reg AL_ABRTD,
  output reg AL_CMPLT,
  output reg [5:0] AL_CNT,
  output reg AL_PF_RD,
  output reg AL_PROM2FF,
  output reg AL_RESTART,
  output reg AUTO_LOAD_ENA,
  output reg CLR_AL_DONE,
  output reg CLR_CRC,
  output reg CRC_DV,
  output reg LOAD_DFLT,
  output reg XFER_CMPLT,
  output wire [4:0] AL_STATE,
  input AL_ABORT,
  input AL_DONE,
  input AL_START,
  input CLK,
  input CRC,
  input CRC_GOOD,
  input CRC_RDY,
  input MAN_AL,
  input RST,
  input SLOW_FIFO_RST_DONE,
  input XFER_DONE 
);

  // state bits
  parameter 
  Idle        = 5'b00000, 
  AL_Restart1 = 5'b00001, 
  AL_Restart2 = 5'b00010, 
  Abort       = 5'b00011, 
  CHK_CRC     = 5'b00100, 
  CRC_Calc    = 5'b00101, 
  Load_Dflts  = 5'b00110, 
  Next_Atmpt  = 5'b00111, 
  RUN         = 5'b01000, 
  RUN_ABORT   = 5'b01001, 
  Read_FIFO   = 5'b01010, 
  Rst_Shifts  = 5'b01011, 
  Start_Xfer  = 5'b01100, 
  Sync        = 5'b01101, 
  Wait4Done   = 5'b01110, 
  Wait4RstDn  = 5'b01111, 
  Wait4Xfer   = 5'b10000, 
  Xfer_Cmplt  = 5'b10001; 

  reg [4:0] state;

  assign AL_STATE = state;

  reg [4:0] nextstate;


  reg [3:0] atmpt_cnt;

  // comb always block
  always @* begin
    nextstate = 5'bxxxxx; // default to x because default_state_is_x is set
    case (state)
      Idle       : if      (AL_START && XFER_DONE)                         nextstate = Read_FIFO;
                   else                                                    nextstate = Idle;
      AL_Restart1: if      (!SLOW_FIFO_RST_DONE)                           nextstate = Wait4RstDn;
                   else                                                    nextstate = AL_Restart1;
      AL_Restart2: if      (!SLOW_FIFO_RST_DONE)                           nextstate = Rst_Shifts;
                   else                                                    nextstate = AL_Restart2;
      Abort      : if      (atmpt_cnt ==MAX_ATMPT)                         nextstate = AL_Restart2;
                   else if (CRC && AL_CNT==(MAX_WRDS+1))                   nextstate = Next_Atmpt;
                   else if (!CRC && AL_CNT==(MAX_WRDS-1))                  nextstate = Next_Atmpt;
                   else                                                    nextstate = Abort;
      CHK_CRC    : if      (CRC_RDY && !CRC_GOOD && atmpt_cnt==MAX_ATMPT)  nextstate = Rst_Shifts;
                   else if (CRC_RDY && !CRC_GOOD)                          nextstate = Next_Atmpt;
                   else if (CRC_RDY && CRC_GOOD)                           nextstate = Xfer_Cmplt;
                   else                                                    nextstate = CHK_CRC;
      CRC_Calc   :                                                         nextstate = CHK_CRC;
      Load_Dflts :                                                         nextstate = Wait4Done;
      Next_Atmpt :                                                         nextstate = AL_Restart1;
      RUN        : if      (MAN_AL)                                        nextstate = Start_Xfer;
                   else                                                    nextstate = RUN;
      RUN_ABORT  : if      (MAN_AL)                                        nextstate = Start_Xfer;
                   else                                                    nextstate = RUN_ABORT;
      Read_FIFO  : if      (AL_ABORT)                                      nextstate = Abort;
                   else if (CRC && AL_CNT==(MAX_WRDS+1))                   nextstate = CRC_Calc;
                   else if (!CRC && AL_CNT==(MAX_WRDS-1))                  nextstate = Xfer_Cmplt;
                   else                                                    nextstate = Read_FIFO;
      Rst_Shifts : if      (SLOW_FIFO_RST_DONE)                            nextstate = Load_Dflts;
                   else                                                    nextstate = Rst_Shifts;
      Start_Xfer :                                                         nextstate = Sync;
      Sync       : if      (!XFER_DONE)                                    nextstate = Wait4Xfer;
                   else                                                    nextstate = Sync;
      Wait4Done  : if      (AL_DONE)                                       nextstate = RUN_ABORT;
                   else                                                    nextstate = Wait4Done;
      Wait4RstDn : if      (SLOW_FIFO_RST_DONE)                            nextstate = Read_FIFO;
                   else                                                    nextstate = Wait4RstDn;
      Wait4Xfer  : if      (XFER_DONE)                                     nextstate = Read_FIFO;
                   else                                                    nextstate = Wait4Xfer;
      Xfer_Cmplt : if      (AL_DONE)                                       nextstate = RUN;
                   else                                                    nextstate = Xfer_Cmplt;
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
      AL_ABRTD <= 0;
      AL_CMPLT <= 0;
      AL_CNT <= 6'h3F;
      AL_PF_RD <= 0;
      AL_PROM2FF <= 0;
      AL_RESTART <= 0;
      AUTO_LOAD_ENA <= 1;
      CLR_AL_DONE <= 0;
      CLR_CRC <= 0;
      CRC_DV <= 0;
      LOAD_DFLT <= 0;
      XFER_CMPLT <= 0;
      atmpt_cnt <= 4'h1;
    end
    else begin
      AL_ABRTD <= 0; // default
      AL_CMPLT <= 0; // default
      AL_CNT <= 6'h3F; // default
      AL_PF_RD <= 0; // default
      AL_PROM2FF <= 0; // default
      AL_RESTART <= 0; // default
      AUTO_LOAD_ENA <= 1; // default
      CLR_AL_DONE <= 0; // default
      CLR_CRC <= 0; // default
      CRC_DV <= 0; // default
      LOAD_DFLT <= 0; // default
      XFER_CMPLT <= 0; // default
      atmpt_cnt <= atmpt_cnt; // default
      case (nextstate)
        Idle       : begin
                            CLR_CRC <= 1;
                            atmpt_cnt <= 4'h1;
        end
        AL_Restart1:        AL_RESTART <= 1;
        AL_Restart2:        AL_RESTART <= 1;
        Abort      : begin
                            AL_CNT <= AL_CNT+1;
                            AL_PF_RD <= 1;
        end
        CHK_CRC    :        AL_CNT <= AL_CNT;
        CRC_Calc   : begin
                            AL_CNT <= AL_CNT;
                            CRC_DV <= 1;
        end
        Load_Dflts :        LOAD_DFLT <= 1;
        Next_Atmpt : begin
                            CLR_AL_DONE <= 1;
                            CLR_CRC <= 1;
                            atmpt_cnt <= atmpt_cnt+1;
        end
        RUN        : begin
                            AL_CMPLT <= 1;
                            AUTO_LOAD_ENA <= 0;
        end
        RUN_ABORT  : begin
                            AL_ABRTD <= 1;
                            AL_CMPLT <= 1;
                            AUTO_LOAD_ENA <= 0;
        end
        Read_FIFO  : begin
                            AL_CNT <= AL_CNT +1;
                            AL_PF_RD <= 1;
                            CRC_DV <= 1;
        end
        Start_Xfer : begin
                            AL_PROM2FF <= 1;
                            CLR_AL_DONE <= 1;
        end
        Sync       :        CLR_AL_DONE <= 1;
        Xfer_Cmplt :        XFER_CMPLT <= 1;
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [87:0] statename;
  always @* begin
    case (state)
      Idle       : statename = "Idle";
      AL_Restart1: statename = "AL_Restart1";
      AL_Restart2: statename = "AL_Restart2";
      Abort      : statename = "Abort";
      CHK_CRC    : statename = "CHK_CRC";
      CRC_Calc   : statename = "CRC_Calc";
      Load_Dflts : statename = "Load_Dflts";
      Next_Atmpt : statename = "Next_Atmpt";
      RUN        : statename = "RUN";
      RUN_ABORT  : statename = "RUN_ABORT";
      Read_FIFO  : statename = "Read_FIFO";
      Rst_Shifts : statename = "Rst_Shifts";
      Start_Xfer : statename = "Start_Xfer";
      Sync       : statename = "Sync";
      Wait4Done  : statename = "Wait4Done";
      Wait4RstDn : statename = "Wait4RstDn";
      Wait4Xfer  : statename = "Wait4Xfer";
      Xfer_Cmplt : statename = "Xfer_Cmplt";
      default    : statename = "XXXXXXXXXXX";
    endcase
  end
  `endif

endmodule

