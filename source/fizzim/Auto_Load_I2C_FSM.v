
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2019:04:13 at 14:27:54 (www.fizzim.com)

module Auto_Load_I2C_FSM (
  output reg CLR_ADDR,
  output reg START_AL,
  output reg SYNC,
  output reg USE_AL_DATA,
  input AL_DATA_RDY,
  input CLK,
  input RST,
  input SEQ_DONE 
);

  // state bits
  parameter 
  Idle       = 2'b00, 
  Clr_Addr   = 2'b01, 
  Start_Test = 2'b10, 
  Sync       = 2'b11; 

  reg [1:0] state;


  reg [1:0] nextstate;


  reg [15:0] gcnt;

  // comb always block
  always @* begin
    nextstate = 2'bxx; // default to x because default_state_is_x is set
    case (state)
      Idle      : if (AL_DATA_RDY)  nextstate = Sync;
                  else              nextstate = Idle;
      Clr_Addr  :                   nextstate = Clr_Addr;
      Start_Test: if (SEQ_DONE)     nextstate = Clr_Addr;
                  else              nextstate = Start_Test;
      Sync      :                   nextstate = Start_Test;
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
      CLR_ADDR <= 0;
      START_AL <= 0;
      SYNC <= 0;
      USE_AL_DATA <= 0;
      gcnt <= 16'h0000;
    end
    else begin
      CLR_ADDR <= 0; // default
      START_AL <= 0; // default
      SYNC <= 0; // default
      USE_AL_DATA <= 0; // default
      gcnt <= 16'h0000; // default
      case (nextstate)
        Idle      :        CLR_ADDR <= 1;
        Clr_Addr  :        CLR_ADDR <= 1;
        Start_Test: begin
                           START_AL <= 1;
                           USE_AL_DATA <= 1;
        end
        Sync      : begin
                           SYNC <= 1;
                           USE_AL_DATA <= 1;
        end
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [79:0] statename;
  always @* begin
    case (state)
      Idle      : statename = "Idle";
      Clr_Addr  : statename = "Clr_Addr";
      Start_Test: statename = "Start_Test";
      Sync      : statename = "Sync";
      default   : statename = "XXXXXXXXXX";
    endcase
  end
  `endif

endmodule

