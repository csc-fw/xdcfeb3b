
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2018:09:27 at 16:48:32 (www.fizzim.com)

module I2C_intrf_FSM (
  output reg INCR,
  output reg LOAD_ADDR,
  output reg LOAD_BYTE,
  output reg M_ACK,
  output reg M_NACK,
  output reg PUSH,
  output reg READY,
  output reg RESTART,
  output reg SHADR,
  output reg SHDATA,
  output reg SHDEVRD,
  output reg SHDEVWRT,
  output reg START,
  output reg STOP,
  output reg S_ACK,
  output wire [4:0] I2C_STATE,
  input CLK,
  input EXECUTE,
  input LAST_BYTE,
  input READ,
  input RST,
  input STEP3,
  input STEP4,
  input WRITE 
);

  // state bits
  parameter 
  Idle          = 5'b00000, 
  I2C_ReStart   = 5'b00001, 
  I2C_Start     = 5'b00010, 
  I2C_Stop      = 5'b00011, 
  M_Ack_1       = 5'b00100, 
  M_NAck_1      = 5'b00101, 
  S_Ack_1       = 5'b00110, 
  S_Ack_2       = 5'b00111, 
  S_Ack_3       = 5'b01000, 
  S_Ack_4       = 5'b01001, 
  S_Ack_5       = 5'b01010, 
  Shift_Addr    = 5'b01011, 
  Shift_Data_Rd = 5'b01100, 
  Shift_Data_Wr = 5'b01101, 
  Shift_Dev_Rd  = 5'b01110, 
  Shift_Dev_Wr  = 5'b01111, 
  Wait          = 5'b10000; 

  reg [4:0] state;

  assign I2C_STATE = state;

  reg [4:0] nextstate;


  reg [3:0] shift_cnt;

  // comb always block
  always @* begin
    nextstate = 5'bxxxxx; // default to x because default_state_is_x is set
    INCR = 0; // default
    case (state)
      Idle         : if      (EXECUTE)                                    nextstate = I2C_Start;
                     else                                                 nextstate = Idle;
      I2C_ReStart  : if      (STEP4)                                      nextstate = Shift_Dev_Rd;
                     else                                                 nextstate = I2C_ReStart;
      I2C_Start    : if      (STEP3)                                      nextstate = Shift_Dev_Wr;
                     else                                                 nextstate = I2C_Start;
      I2C_Stop     : if      (STEP3)                                      nextstate = Wait;
                     else                                                 nextstate = I2C_Stop;
      M_Ack_1      : if      (STEP3)                                      nextstate = Shift_Data_Rd;
                     else                                                 nextstate = M_Ack_1;
      M_NAck_1     : if      (STEP3)                                      nextstate = I2C_Stop;
                     else                                                 nextstate = M_NAck_1;
      S_Ack_1      : if      (STEP3)                                      nextstate = Shift_Addr;
                     else                                                 nextstate = S_Ack_1;
      S_Ack_2      : if      (READ && STEP3)                              nextstate = I2C_ReStart;
                     else if (WRITE && STEP3)                             nextstate = Shift_Data_Wr;
                     else                                                 nextstate = S_Ack_2;
      S_Ack_3      : if      (STEP3)                                      nextstate = Shift_Data_Rd;
                     else                                                 nextstate = S_Ack_3;
      S_Ack_4      : if      (STEP3)                                      nextstate = Shift_Data_Wr;
                     else                                                 nextstate = S_Ack_4;
      S_Ack_5      : if      (STEP3)                                      nextstate = I2C_Stop;
                     else                                                 nextstate = S_Ack_5;
      Shift_Addr   : if      ((shift_cnt == 4'd8) && STEP3)               nextstate = S_Ack_2;
                     else                                                 nextstate = Shift_Addr;
      Shift_Data_Rd: begin
        if                   (LAST_BYTE && (shift_cnt == 4'd8) && STEP3)  nextstate = M_NAck_1;
        else if              ((shift_cnt == 4'd8) && STEP3) begin
                                                                          nextstate = M_Ack_1;
                                                                          INCR = 1;
        end
        else                                                              nextstate = Shift_Data_Rd;
      end
      Shift_Data_Wr: begin
        if                   (LAST_BYTE && (shift_cnt == 4'd8) && STEP3)  nextstate = S_Ack_5;
        else if              ((shift_cnt == 4'd8) && STEP3) begin
                                                                          nextstate = S_Ack_4;
                                                                          INCR = 1;
        end
        else                                                              nextstate = Shift_Data_Wr;
      end
      Shift_Dev_Rd : if      ((shift_cnt == 4'd8) && STEP3)               nextstate = S_Ack_3;
                     else                                                 nextstate = Shift_Dev_Rd;
      Shift_Dev_Wr : if      ((shift_cnt == 4'd8) && STEP3)               nextstate = S_Ack_1;
                     else                                                 nextstate = Shift_Dev_Wr;
      Wait         : if      (!EXECUTE)                                   nextstate = Idle;
                     else                                                 nextstate = Wait;
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
      LOAD_ADDR <= 0;
      LOAD_BYTE <= 0;
      M_ACK <= 0;
      M_NACK <= 0;
      PUSH <= 0;
      READY <= 0;
      RESTART <= 0;
      SHADR <= 0;
      SHDATA <= 0;
      SHDEVRD <= 0;
      SHDEVWRT <= 0;
      START <= 0;
      STOP <= 0;
      S_ACK <= 0;
      shift_cnt <= 4'd0;
    end
    else begin
      LOAD_ADDR <= 0; // default
      LOAD_BYTE <= 0; // default
      M_ACK <= 0; // default
      M_NACK <= 0; // default
      PUSH <= 0; // default
      READY <= 0; // default
      RESTART <= 0; // default
      SHADR <= 0; // default
      SHDATA <= 0; // default
      SHDEVRD <= 0; // default
      SHDEVWRT <= 0; // default
      START <= 0; // default
      STOP <= 0; // default
      S_ACK <= 0; // default
      shift_cnt <= 4'd0; // default
      case (nextstate)
        Idle         :        READY <= 1;
        I2C_ReStart  :        RESTART <= 1;
        I2C_Start    :        START <= 1;
        I2C_Stop     :        STOP <= 1;
        M_Ack_1      : begin
                              LOAD_BYTE <= 1;
                              M_ACK <= 1;
                              PUSH <= 1;
        end
        M_NAck_1     : begin
                              M_NACK <= 1;
                              PUSH <= 1;
        end
        S_Ack_1      : begin
                              LOAD_ADDR <= 1;
                              S_ACK <= 1;
        end
        S_Ack_2      : begin
                              LOAD_BYTE <= 1;
                              S_ACK <= 1;
        end
        S_Ack_3      :        S_ACK <= 1;
        S_Ack_4      : begin
                              LOAD_BYTE <= 1;
                              S_ACK <= 1;
        end
        S_Ack_5      :        S_ACK <= 1;
        Shift_Addr   : begin
                              SHADR <= 1;
                              shift_cnt <= STEP3 ? shift_cnt + 1 : shift_cnt;
        end
        Shift_Data_Rd: begin
                              SHDATA <= 1;
                              shift_cnt <= STEP3 ? shift_cnt + 1 : shift_cnt;
        end
        Shift_Data_Wr: begin
                              SHDATA <= 1;
                              shift_cnt <= STEP3 ? shift_cnt + 1 : shift_cnt;
        end
        Shift_Dev_Rd : begin
                              SHDEVRD <= 1;
                              shift_cnt <= (STEP3 || STEP4) ? shift_cnt + 1 : shift_cnt;
        end
        Shift_Dev_Wr : begin
                              SHDEVWRT <= 1;
                              shift_cnt <= STEP3 ? shift_cnt + 1 : shift_cnt;
        end
        Wait         :        READY <= 1;
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [103:0] statename;
  always @* begin
    case (state)
      Idle         : statename = "Idle";
      I2C_ReStart  : statename = "I2C_ReStart";
      I2C_Start    : statename = "I2C_Start";
      I2C_Stop     : statename = "I2C_Stop";
      M_Ack_1      : statename = "M_Ack_1";
      M_NAck_1     : statename = "M_NAck_1";
      S_Ack_1      : statename = "S_Ack_1";
      S_Ack_2      : statename = "S_Ack_2";
      S_Ack_3      : statename = "S_Ack_3";
      S_Ack_4      : statename = "S_Ack_4";
      S_Ack_5      : statename = "S_Ack_5";
      Shift_Addr   : statename = "Shift_Addr";
      Shift_Data_Rd: statename = "Shift_Data_Rd";
      Shift_Data_Wr: statename = "Shift_Data_Wr";
      Shift_Dev_Rd : statename = "Shift_Dev_Rd";
      Shift_Dev_Wr : statename = "Shift_Dev_Wr";
      Wait         : statename = "Wait";
      default      : statename = "XXXXXXXXXXXXX";
    endcase
  end
  `endif

endmodule

