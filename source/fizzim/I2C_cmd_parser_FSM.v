
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2018:09:21 at 14:37:02 (www.fizzim.com)

module I2C_cmd_parser_FSM (
  output reg CLR_START,
  output reg EXECUTE,
  output reg LD_ADDR,
  output reg LD_DEV,
  output reg LD_N_BYTE,
  output reg NVIO_ENA,
  output reg READ_FF,
  output reg WRT_ENA,
  output wire [3:0] I2C_PARSER_STATE,
  input CLK,
  input I2C_START,
  input MT,
  input wire [3:0] N_BYTES,
  input READ,
  input READY,
  input RST 
);

  // state bits
  parameter 
  Idle         = 4'b0000, 
  Clr_Start    = 4'b0001, 
  Execute_I2C  = 4'b0010, 
  Load_Addr    = 4'b0011, 
  Load_Dev     = 4'b0100, 
  Load_N_Byte  = 4'b0101, 
  Wait_4_Cmplt = 4'b0110, 
  Wait_4_Ready = 4'b0111, 
  Wrt_2_Mem    = 4'b1000; 

  reg [3:0] state;

  assign I2C_PARSER_STATE = state;

  reg [3:0] nextstate;


  reg [3:0] bcnt;

  // comb always block
  always @* begin
    nextstate = 4'bxxxx; // default to x because default_state_is_x is set
    case (state)
      Idle        : if      (I2C_START && !MT)  nextstate = Load_Dev;
                    else                        nextstate = Idle;
      Clr_Start   : if      (!I2C_START)        nextstate = Idle;
                    else                        nextstate = Clr_Start;
      Execute_I2C : if      (!READY)            nextstate = Wait_4_Cmplt;
                    else                        nextstate = Execute_I2C;
      Load_Addr   : if      (N_BYTES == 4'h0)   nextstate = Clr_Start;
                    else if (READ)              nextstate = Wait_4_Ready;
                    else                        nextstate = Wrt_2_Mem;
      Load_Dev    :                             nextstate = Load_N_Byte;
      Load_N_Byte :                             nextstate = Load_Addr;
      Wait_4_Cmplt: if      (READY)             nextstate = Clr_Start;
                    else                        nextstate = Wait_4_Cmplt;
      Wait_4_Ready: if      (READY)             nextstate = Execute_I2C;
                    else                        nextstate = Wait_4_Ready;
      Wrt_2_Mem   : if      (bcnt == N_BYTES)   nextstate = Wait_4_Ready;
                    else                        nextstate = Wrt_2_Mem;
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
      CLR_START <= 0;
      EXECUTE <= 0;
      LD_ADDR <= 0;
      LD_DEV <= 0;
      LD_N_BYTE <= 0;
      NVIO_ENA <= 0;
      READ_FF <= 0;
      WRT_ENA <= 0;
      bcnt <= 4'h0;
    end
    else begin
      CLR_START <= 0; // default
      EXECUTE <= 0; // default
      LD_ADDR <= 0; // default
      LD_DEV <= 0; // default
      LD_N_BYTE <= 0; // default
      NVIO_ENA <= 0; // default
      READ_FF <= 0; // default
      WRT_ENA <= 0; // default
      bcnt <= 4'h0; // default
      case (nextstate)
        Clr_Start   :        CLR_START <= 1;
        Execute_I2C : begin
                             EXECUTE <= 1;
                             NVIO_ENA <= 1;
        end
        Load_Addr   : begin
                             LD_ADDR <= 1;
                             READ_FF <= 1;
        end
        Load_Dev    :        LD_DEV <= 1;
        Load_N_Byte : begin
                             LD_N_BYTE <= 1;
                             READ_FF <= 1;
        end
        Wait_4_Cmplt:        NVIO_ENA <= 1;
        Wait_4_Ready:        NVIO_ENA <= 1;
        Wrt_2_Mem   : begin
                             READ_FF <= 1;
                             WRT_ENA <= 1;
                             bcnt <= bcnt + 1;
        end
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [95:0] statename;
  always @* begin
    case (state)
      Idle        : statename = "Idle";
      Clr_Start   : statename = "Clr_Start";
      Execute_I2C : statename = "Execute_I2C";
      Load_Addr   : statename = "Load_Addr";
      Load_Dev    : statename = "Load_Dev";
      Load_N_Byte : statename = "Load_N_Byte";
      Wait_4_Cmplt: statename = "Wait_4_Cmplt";
      Wait_4_Ready: statename = "Wait_4_Ready";
      Wrt_2_Mem   : statename = "Wrt_2_Mem";
      default     : statename = "XXXXXXXXXXXX";
    endcase
  end
  `endif

endmodule

