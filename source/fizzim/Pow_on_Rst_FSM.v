
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2014:12:12 at 10:56:46 (www.fizzim.com)

module Pow_on_Rst_FSM 
  #(
    parameter POR_tmo = 120,
    parameter Strt_dly = 20'h7FFFF
  )(
  output reg ADC_INIT_RST,
  output reg AL_START,
  output reg MMCM_RST,
  output reg POR,
  output reg RUN,
  output wire [3:0] POR_STATE,
  input ADC_RDY,
  input AL_DONE,
  input CLK,
  input EOS,
  input MMCM_LOCK,
  input QPLL_LOCK,
  input RESTART_ALL,
  input SLOW_FRST_DONE 
);

  // state bits
  parameter 
  Idle            = 4'b0000, 
  ADC_INIT        = 4'b0001, 
  Auto_Load       = 4'b0010, 
  Clr_AL_FIFO     = 4'b0011, 
  Pow_on_Rst      = 4'b0100, 
  Run_State       = 4'b0101, 
  Start_Auto_Load = 4'b0110, 
  W4Qpll          = 4'b0111, 
  W4SysClk        = 4'b1000; 

  reg [3:0] state;

  assign POR_STATE = state;

  reg [3:0] nextstate;


  reg [6:0] por_cnt;
  reg [19:0] strtup_cnt;

  // comb always block
  always @* begin
    nextstate = 4'bxxxx; // default to x because default_state_is_x is set
    case (state)
      Idle           : if      (strtup_cnt == Strt_dly)          nextstate = W4Qpll;
                       else                                      nextstate = Idle;
      ADC_INIT       : if      (RESTART_ALL)                     nextstate = Pow_on_Rst;
                       else if (ADC_RDY)                         nextstate = Run_State;
                       else                                      nextstate = ADC_INIT;
      Auto_Load      : if      (RESTART_ALL)                     nextstate = Pow_on_Rst;
                       else if (AL_DONE)                         nextstate = ADC_INIT;
                       else                                      nextstate = Auto_Load;
      Clr_AL_FIFO    : if      (RESTART_ALL)                     nextstate = Pow_on_Rst;
                       else if (SLOW_FRST_DONE)                  nextstate = Start_Auto_Load;
                       else                                      nextstate = Clr_AL_FIFO;
      Pow_on_Rst     : if      (!MMCM_LOCK)                      nextstate = W4Qpll;
                       else if (por_cnt == POR_tmo)              nextstate = Clr_AL_FIFO;
                       else                                      nextstate = Pow_on_Rst;
      Run_State      : if      (RESTART_ALL)                     nextstate = Pow_on_Rst;
                       else                                      nextstate = Run_State;
      Start_Auto_Load: if      (RESTART_ALL)                     nextstate = Pow_on_Rst;
                       else if (!AL_DONE)                        nextstate = Auto_Load;
                       else                                      nextstate = Start_Auto_Load;
      W4Qpll         : if      (QPLL_LOCK)                       nextstate = W4SysClk;
                       else                                      nextstate = W4Qpll;
// to temporarily ignore the QPLL_LOCK uncomment the following line and comment out the previous two
//      W4Qpll         :                                           nextstate = W4SysClk;
      W4SysClk       : if      (MMCM_LOCK)                       nextstate = Pow_on_Rst;
                       else                                      nextstate = W4SysClk;
    endcase
  end

  // Assign reg'd outputs to state bits

  // sequential always block
  always @(posedge CLK or negedge EOS) begin
    if (!EOS)
      state <= Idle;
    else
      state <= nextstate;
  end

  // datapath sequential always block
  always @(posedge CLK or negedge EOS) begin
    if (!EOS) begin
      ADC_INIT_RST <= 1;
      AL_START <= 0;
      MMCM_RST <= 1;
      POR <= 1;
      RUN <= 0;
      por_cnt <= 7'h00;
      strtup_cnt <= 20'h00000;
    end
    else begin
      ADC_INIT_RST <= 0; // default
      AL_START <= 0; // default
      MMCM_RST <= 0; // default
      POR <= 0; // default
      RUN <= 0; // default
      por_cnt <= 7'h00; // default
      strtup_cnt <= 20'h00000; // default
      case (nextstate)
        Idle           : begin
                                ADC_INIT_RST <= 1;
                                MMCM_RST <= 1;
                                POR <= 1;
                                strtup_cnt <= strtup_cnt + 1;
        end
        Auto_Load      : begin
                                ADC_INIT_RST <= 1;
                                AL_START <= 1;
        end
        Clr_AL_FIFO    :        ADC_INIT_RST <= 1;
        Pow_on_Rst     : begin
                                ADC_INIT_RST <= 1;
                                POR <= 1;
                                por_cnt <= por_cnt + 1;
        end
        Run_State      :        RUN <= 1;
        Start_Auto_Load: begin
                                ADC_INIT_RST <= 1;
                                AL_START <= 1;
        end
        W4Qpll         : begin
                                ADC_INIT_RST <= 1;
                                MMCM_RST <= 1;
                                POR <= 1;
        end
        W4SysClk       : begin
                                ADC_INIT_RST <= 1;
                                POR <= 1;
        end
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [119:0] statename;
  always @* begin
    case (state)
      Idle           : statename = "Idle";
      ADC_INIT       : statename = "ADC_INIT";
      Auto_Load      : statename = "Auto_Load";
      Clr_AL_FIFO    : statename = "Clr_AL_FIFO";
      Pow_on_Rst     : statename = "Pow_on_Rst";
      Run_State      : statename = "Run_State";
      Start_Auto_Load: statename = "Start_Auto_Load";
      W4Qpll         : statename = "W4Qpll";
      W4SysClk       : statename = "W4SysClk";
      default        : statename = "XXXXXXXXXXXXXXX";
    endcase
  end
  `endif

endmodule

