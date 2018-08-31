
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2014:12:12 at 10:57:14 (www.fizzim.com)

module Pow_on_Rst_FSM_TMR 
  #(
    parameter POR_tmo = 120,
    parameter Strt_dly = 20'h7FFFF
  )(
  output ADC_INIT_RST,
  output AL_START,
  output MMCM_RST,
  output POR,
  output RUN,
  output wire [3:0] POR_STATE,
  input ADC_RDY,
  input AL_DONE,
  input BPI_SEQ_IDLE,
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
  PROM_Cnfg       = 4'b0011, 
  Pow_on_Rst      = 4'b0100, 
  Run_State       = 4'b0101, 
  Start_Auto_Load = 4'b0110, 
  W4Qpll          = 4'b0111, 
  W4SysClk        = 4'b1000; 

  (* syn_preserve = "true" *) reg [3:0] state_1;
  (* syn_preserve = "true" *) reg [3:0] state_2;
  (* syn_preserve = "true" *) reg [3:0] state_3;

  (* syn_keep = "true" *) wire [3:0] voted_state_1;
  (* syn_keep = "true" *) wire [3:0] voted_state_2;
  (* syn_keep = "true" *) wire [3:0] voted_state_3;

  assign voted_state_1        = (state_1        & state_2       ) | (state_2        & state_3       ) | (state_1        & state_3       ); // Majority logic
  assign voted_state_2        = (state_1        & state_2       ) | (state_2        & state_3       ) | (state_1        & state_3       ); // Majority logic
  assign voted_state_3        = (state_1        & state_2       ) | (state_2        & state_3       ) | (state_1        & state_3       ); // Majority logic

  assign POR_STATE = voted_state_1;

  (* syn_keep = "true" *) reg [3:0] nextstate_1;
  (* syn_keep = "true" *) reg [3:0] nextstate_2;
  (* syn_keep = "true" *) reg [3:0] nextstate_3;


  (* syn_preserve = "true" *)  reg ADC_INIT_RST_1;
  (* syn_preserve = "true" *)  reg ADC_INIT_RST_2;
  (* syn_preserve = "true" *)  reg ADC_INIT_RST_3;
  (* syn_preserve = "true" *)  reg AL_START_1;
  (* syn_preserve = "true" *)  reg AL_START_2;
  (* syn_preserve = "true" *)  reg AL_START_3;
  (* syn_preserve = "true" *)  reg MMCM_RST_1;
  (* syn_preserve = "true" *)  reg MMCM_RST_2;
  (* syn_preserve = "true" *)  reg MMCM_RST_3;
  (* syn_preserve = "true" *)  reg POR_1;
  (* syn_preserve = "true" *)  reg POR_2;
  (* syn_preserve = "true" *)  reg POR_3;
  (* syn_preserve = "true" *)  reg RUN_1;
  (* syn_preserve = "true" *)  reg RUN_2;
  (* syn_preserve = "true" *)  reg RUN_3;
  (* syn_preserve = "true" *)  reg [6:0] por_cnt_1;
  (* syn_preserve = "true" *)  reg [6:0] por_cnt_2;
  (* syn_preserve = "true" *)  reg [6:0] por_cnt_3;
  (* syn_keep = "true" *)      wire [6:0] voted_por_cnt_1;
  (* syn_keep = "true" *)      wire [6:0] voted_por_cnt_2;
  (* syn_keep = "true" *)      wire [6:0] voted_por_cnt_3;
  (* syn_preserve = "true" *)  reg [19:0] strtup_cnt_1;
  (* syn_preserve = "true" *)  reg [19:0] strtup_cnt_2;
  (* syn_preserve = "true" *)  reg [19:0] strtup_cnt_3;
  (* syn_keep = "true" *)      wire [19:0] voted_strtup_cnt_1;
  (* syn_keep = "true" *)      wire [19:0] voted_strtup_cnt_2;
  (* syn_keep = "true" *)      wire [19:0] voted_strtup_cnt_3;

  // Assignment of outputs and flags to voted majority logic of replicated registers
  assign ADC_INIT_RST = (ADC_INIT_RST_1 & ADC_INIT_RST_2) | (ADC_INIT_RST_2 & ADC_INIT_RST_3) | (ADC_INIT_RST_1 & ADC_INIT_RST_3); // Majority logic
  assign AL_START     = (AL_START_1     & AL_START_2    ) | (AL_START_2     & AL_START_3    ) | (AL_START_1     & AL_START_3    ); // Majority logic
  assign MMCM_RST     = (MMCM_RST_1     & MMCM_RST_2    ) | (MMCM_RST_2     & MMCM_RST_3    ) | (MMCM_RST_1     & MMCM_RST_3    ); // Majority logic
  assign POR          = (POR_1          & POR_2         ) | (POR_2          & POR_3         ) | (POR_1          & POR_3         ); // Majority logic
  assign RUN          = (RUN_1          & RUN_2         ) | (RUN_2          & RUN_3         ) | (RUN_1          & RUN_3         ); // Majority logic
  assign voted_por_cnt_1      = (por_cnt_1      & por_cnt_2     ) | (por_cnt_2      & por_cnt_3     ) | (por_cnt_1      & por_cnt_3     ); // Majority logic
  assign voted_por_cnt_2      = (por_cnt_1      & por_cnt_2     ) | (por_cnt_2      & por_cnt_3     ) | (por_cnt_1      & por_cnt_3     ); // Majority logic
  assign voted_por_cnt_3      = (por_cnt_1      & por_cnt_2     ) | (por_cnt_2      & por_cnt_3     ) | (por_cnt_1      & por_cnt_3     ); // Majority logic
  assign voted_strtup_cnt_1   = (strtup_cnt_1   & strtup_cnt_2  ) | (strtup_cnt_2   & strtup_cnt_3  ) | (strtup_cnt_1   & strtup_cnt_3  ); // Majority logic
  assign voted_strtup_cnt_2   = (strtup_cnt_1   & strtup_cnt_2  ) | (strtup_cnt_2   & strtup_cnt_3  ) | (strtup_cnt_1   & strtup_cnt_3  ); // Majority logic
  assign voted_strtup_cnt_3   = (strtup_cnt_1   & strtup_cnt_2  ) | (strtup_cnt_2   & strtup_cnt_3  ) | (strtup_cnt_1   & strtup_cnt_3  ); // Majority logic

  // Assignment of error detection logic to replicated signals

  // comb always block
  always @* begin
    nextstate_1 = 4'bxxxx; // default to x because default_state_is_x is set
    nextstate_2 = 4'bxxxx; // default to x because default_state_is_x is set
    nextstate_3 = 4'bxxxx; // default to x because default_state_is_x is set
    case (voted_state_1)
      Idle           : if      (voted_strtup_cnt_1 == Strt_dly)  nextstate_1 = W4Qpll;
                       else                                      nextstate_1 = Idle;
      ADC_INIT       : if      (RESTART_ALL)                     nextstate_1 = Pow_on_Rst;
                       else if (ADC_RDY)                         nextstate_1 = Run_State;
                       else                                      nextstate_1 = ADC_INIT;
      Auto_Load      : if      (RESTART_ALL)                     nextstate_1 = Pow_on_Rst;
                       else if (AL_DONE)                         nextstate_1 = ADC_INIT;
                       else                                      nextstate_1 = Auto_Load;
      PROM_Cnfg      : if      (RESTART_ALL)                     nextstate_1 = Pow_on_Rst;
                       else if (BPI_SEQ_IDLE && SLOW_FRST_DONE)  nextstate_1 = Start_Auto_Load;
                       else                                      nextstate_1 = PROM_Cnfg;
      Pow_on_Rst     : if      (!MMCM_LOCK)                      nextstate_1 = W4Qpll;
                       else if (voted_por_cnt_1 == POR_tmo)      nextstate_1 = PROM_Cnfg;
                       else                                      nextstate_1 = Pow_on_Rst;
      Run_State      : if      (RESTART_ALL)                     nextstate_1 = Pow_on_Rst;
                       else                                      nextstate_1 = Run_State;
      Start_Auto_Load: if      (RESTART_ALL)                     nextstate_1 = Pow_on_Rst;
                       else if (!AL_DONE)                        nextstate_1 = Auto_Load;
                       else                                      nextstate_1 = Start_Auto_Load;
      W4Qpll         : if      (QPLL_LOCK)                       nextstate_1 = W4SysClk;
                       else                                      nextstate_1 = W4Qpll;
// to temporarily ignore the QPLL_LOCK uncomment the following line and comment out the previous two
//      W4Qpll         :                                           nextstate_1 = W4SysClk;
      W4SysClk       : if      (MMCM_LOCK)                       nextstate_1 = Pow_on_Rst;
                       else                                      nextstate_1 = W4SysClk;
    endcase
    case (voted_state_2)
      Idle           : if      (voted_strtup_cnt_2 == Strt_dly)  nextstate_2 = W4Qpll;
                       else                                      nextstate_2 = Idle;
      ADC_INIT       : if      (RESTART_ALL)                     nextstate_2 = Pow_on_Rst;
                       else if (ADC_RDY)                         nextstate_2 = Run_State;
                       else                                      nextstate_2 = ADC_INIT;
      Auto_Load      : if      (RESTART_ALL)                     nextstate_2 = Pow_on_Rst;
                       else if (AL_DONE)                         nextstate_2 = ADC_INIT;
                       else                                      nextstate_2 = Auto_Load;
      PROM_Cnfg      : if      (RESTART_ALL)                     nextstate_2 = Pow_on_Rst;
                       else if (BPI_SEQ_IDLE && SLOW_FRST_DONE)  nextstate_2 = Start_Auto_Load;
                       else                                      nextstate_2 = PROM_Cnfg;
      Pow_on_Rst     : if      (!MMCM_LOCK)                      nextstate_2 = W4Qpll;
                       else if (voted_por_cnt_2 == POR_tmo)      nextstate_2 = PROM_Cnfg;
                       else                                      nextstate_2 = Pow_on_Rst;
      Run_State      : if      (RESTART_ALL)                     nextstate_2 = Pow_on_Rst;
                       else                                      nextstate_2 = Run_State;
      Start_Auto_Load: if      (RESTART_ALL)                     nextstate_2 = Pow_on_Rst;
                       else if (!AL_DONE)                        nextstate_2 = Auto_Load;
                       else                                      nextstate_2 = Start_Auto_Load;
      W4Qpll         : if      (QPLL_LOCK)                       nextstate_2 = W4SysClk;
                       else                                      nextstate_2 = W4Qpll;
// to temporarily ignore the QPLL_LOCK uncomment the following line and comment out the previous two
//      W4Qpll         :                                           nextstate_2 = W4SysClk;
      W4SysClk       : if      (MMCM_LOCK)                       nextstate_2 = Pow_on_Rst;
                       else                                      nextstate_2 = W4SysClk;
    endcase
    case (voted_state_3)
      Idle           : if      (voted_strtup_cnt_3 == Strt_dly)  nextstate_3 = W4Qpll;
                       else                                      nextstate_3 = Idle;
      ADC_INIT       : if      (RESTART_ALL)                     nextstate_3 = Pow_on_Rst;
                       else if (ADC_RDY)                         nextstate_3 = Run_State;
                       else                                      nextstate_3 = ADC_INIT;
      Auto_Load      : if      (RESTART_ALL)                     nextstate_3 = Pow_on_Rst;
                       else if (AL_DONE)                         nextstate_3 = ADC_INIT;
                       else                                      nextstate_3 = Auto_Load;
      PROM_Cnfg      : if      (RESTART_ALL)                     nextstate_3 = Pow_on_Rst;
                       else if (BPI_SEQ_IDLE && SLOW_FRST_DONE)  nextstate_3 = Start_Auto_Load;
                       else                                      nextstate_3 = PROM_Cnfg;
      Pow_on_Rst     : if      (!MMCM_LOCK)                      nextstate_3 = W4Qpll;
                       else if (voted_por_cnt_3 == POR_tmo)      nextstate_3 = PROM_Cnfg;
                       else                                      nextstate_3 = Pow_on_Rst;
      Run_State      : if      (RESTART_ALL)                     nextstate_3 = Pow_on_Rst;
                       else                                      nextstate_3 = Run_State;
      Start_Auto_Load: if      (RESTART_ALL)                     nextstate_3 = Pow_on_Rst;
                       else if (!AL_DONE)                        nextstate_3 = Auto_Load;
                       else                                      nextstate_3 = Start_Auto_Load;
      W4Qpll         : if      (QPLL_LOCK)                       nextstate_3 = W4SysClk;
                       else                                      nextstate_3 = W4Qpll;
// to temporarily ignore the QPLL_LOCK uncomment the following line and comment out the previous two
//      W4Qpll         :                                           nextstate_3 = W4SysClk;
      W4SysClk       : if      (MMCM_LOCK)                       nextstate_3 = Pow_on_Rst;
                       else                                      nextstate_3 = W4SysClk;
    endcase
  end

  // Assign reg'd outputs to state bits

  // sequential always block
  always @(posedge CLK or negedge EOS) begin
    if (!EOS) begin
      state_1 <= Idle;
      state_2 <= Idle;
      state_3 <= Idle;
    end
    else begin
      state_1 <= nextstate_1;
      state_2 <= nextstate_2;
      state_3 <= nextstate_3;
    end
  end

  // datapath sequential always block
  always @(posedge CLK or negedge EOS) begin
    if (!EOS) begin
      ADC_INIT_RST_1 <= 1;
      ADC_INIT_RST_2 <= 1;
      ADC_INIT_RST_3 <= 1;
      AL_START_1 <= 0;
      AL_START_2 <= 0;
      AL_START_3 <= 0;
      MMCM_RST_1 <= 1;
      MMCM_RST_2 <= 1;
      MMCM_RST_3 <= 1;
      POR_1 <= 1;
      POR_2 <= 1;
      POR_3 <= 1;
      RUN_1 <= 0;
      RUN_2 <= 0;
      RUN_3 <= 0;
      por_cnt_1 <= 7'h00;
      por_cnt_2 <= 7'h00;
      por_cnt_3 <= 7'h00;
      strtup_cnt_1 <= 20'h00000;
      strtup_cnt_2 <= 20'h00000;
      strtup_cnt_3 <= 20'h00000;
    end
    else begin
      ADC_INIT_RST_1 <= 0; // default
      ADC_INIT_RST_2 <= 0; // default
      ADC_INIT_RST_3 <= 0; // default
      AL_START_1 <= 0; // default
      AL_START_2 <= 0; // default
      AL_START_3 <= 0; // default
      MMCM_RST_1 <= 0; // default
      MMCM_RST_2 <= 0; // default
      MMCM_RST_3 <= 0; // default
      POR_1 <= 0; // default
      POR_2 <= 0; // default
      POR_3 <= 0; // default
      RUN_1 <= 0; // default
      RUN_2 <= 0; // default
      RUN_3 <= 0; // default
      por_cnt_1 <= 7'h00; // default
      por_cnt_2 <= 7'h00; // default
      por_cnt_3 <= 7'h00; // default
      strtup_cnt_1 <= 20'h00000; // default
      strtup_cnt_2 <= 20'h00000; // default
      strtup_cnt_3 <= 20'h00000; // default
      case (nextstate_1)
        Idle           : begin
                                ADC_INIT_RST_1 <= 1;
                                MMCM_RST_1 <= 1;
                                POR_1 <= 1;
                                strtup_cnt_1 <= voted_strtup_cnt_1 + 1;
        end
        Auto_Load      : begin
                                ADC_INIT_RST_1 <= 1;
                                AL_START_1 <= 1;
        end
        PROM_Cnfg      :        ADC_INIT_RST_1 <= 1;
        Pow_on_Rst     : begin
                                ADC_INIT_RST_1 <= 1;
                                POR_1 <= 1;
                                por_cnt_1 <= voted_por_cnt_1 + 1;
        end
        Run_State      :        RUN_1 <= 1;
        Start_Auto_Load: begin
                                ADC_INIT_RST_1 <= 1;
                                AL_START_1 <= 1;
        end
        W4Qpll         : begin
                                ADC_INIT_RST_1 <= 1;
                                MMCM_RST_1 <= 1;
                                POR_1 <= 1;
        end
        W4SysClk       : begin
                                ADC_INIT_RST_1 <= 1;
                                POR_1 <= 1;
        end
      endcase
      case (nextstate_2)
        Idle           : begin
                                ADC_INIT_RST_2 <= 1;
                                MMCM_RST_2 <= 1;
                                POR_2 <= 1;
                                strtup_cnt_2 <= voted_strtup_cnt_2 + 1;
        end
        Auto_Load      : begin
                                ADC_INIT_RST_2 <= 1;
                                AL_START_2 <= 1;
        end
        PROM_Cnfg      :        ADC_INIT_RST_2 <= 1;
        Pow_on_Rst     : begin
                                ADC_INIT_RST_2 <= 1;
                                POR_2 <= 1;
                                por_cnt_2 <= voted_por_cnt_2 + 1;
        end
        Run_State      :        RUN_2 <= 1;
        Start_Auto_Load: begin
                                ADC_INIT_RST_2 <= 1;
                                AL_START_2 <= 1;
        end
        W4Qpll         : begin
                                ADC_INIT_RST_2 <= 1;
                                MMCM_RST_2 <= 1;
                                POR_2 <= 1;
        end
        W4SysClk       : begin
                                ADC_INIT_RST_2 <= 1;
                                POR_2 <= 1;
        end
      endcase
      case (nextstate_3)
        Idle           : begin
                                ADC_INIT_RST_3 <= 1;
                                MMCM_RST_3 <= 1;
                                POR_3 <= 1;
                                strtup_cnt_3 <= voted_strtup_cnt_3 + 1;
        end
        Auto_Load      : begin
                                ADC_INIT_RST_3 <= 1;
                                AL_START_3 <= 1;
        end
        PROM_Cnfg      :        ADC_INIT_RST_3 <= 1;
        Pow_on_Rst     : begin
                                ADC_INIT_RST_3 <= 1;
                                POR_3 <= 1;
                                por_cnt_3 <= voted_por_cnt_3 + 1;
        end
        Run_State      :        RUN_3 <= 1;
        Start_Auto_Load: begin
                                ADC_INIT_RST_3 <= 1;
                                AL_START_3 <= 1;
        end
        W4Qpll         : begin
                                ADC_INIT_RST_3 <= 1;
                                MMCM_RST_3 <= 1;
                                POR_3 <= 1;
        end
        W4SysClk       : begin
                                ADC_INIT_RST_3 <= 1;
                                POR_3 <= 1;
        end
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [119:0] statename;
  always @* begin
    case (state_1)
      Idle           : statename = "Idle";
      ADC_INIT       : statename = "ADC_INIT";
      Auto_Load      : statename = "Auto_Load";
      PROM_Cnfg      : statename = "PROM_Cnfg";
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

