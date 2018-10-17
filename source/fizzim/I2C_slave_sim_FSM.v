
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2018:09:27 at 16:12:47 (www.fizzim.com)

module I2C_slave_sim_FSM (
  output reg ACK,
  output reg CAP_RW,
  output reg CHK_DEV,
  output reg CLR_START,
  output reg CLR_STOP,
  output reg LOAD_ADR,
  output reg LOAD_RBK_DATA,
  output reg SHIFT_ADR_REG,
  output reg SHIFT_DATA,
  output reg SHIFT_DEV,
  output reg STORE,
  output reg [3:0] bit_cnt,
  input ABORT,
  input CLK,
  input M_ACK,
  input M_NACK,
  input READ,
  input RST,
  input START,
  input STEP,
  input STOP,
  input WRITE 
);

  // state bits
  parameter 
  Idle        = 5'b00000, 
  Clr_Start   = 5'b00001, 
  Clr_Start_2 = 5'b00010, 
  Clr_Stop    = 5'b00011, 
  Data_Ack    = 5'b00100, 
  Dev_Ack     = 5'b00101, 
  Dev_Ack_2   = 5'b00110, 
  Device      = 5'b00111, 
  Device_2    = 5'b01000, 
  Rd_Wrt_B    = 5'b01001, 
  Rd_Wrt_B_2  = 5'b01010, 
  Reg_Ack     = 5'b01011, 
  Reg_Adr     = 5'b01100, 
  Rst_Cnt_1   = 5'b01101, 
  Rst_Cnt_2   = 5'b01110, 
  Rst_Cnt_3   = 5'b01111, 
  Shift_Data  = 5'b10000, 
  Wait_4_Stop = 5'b10001; 

  reg [4:0] state;


  reg [4:0] nextstate;



  // comb always block
  always @* begin
    nextstate = 5'bxxxxx; // default to x because default_state_is_x is set
    case (state)
      Idle       : if      (START)                    nextstate = Clr_Start;
                   else                               nextstate = Idle;
      Clr_Start  :                                    nextstate = Device;
      Clr_Start_2:                                    nextstate = Device_2;
      Clr_Stop   :                                    nextstate = Idle;
      Data_Ack   : if      (READ && M_NACK)           nextstate = Wait_4_Stop;
                   else if (STEP && bit_cnt == 4'h9)  nextstate = Rst_Cnt_3;
                   else                               nextstate = Data_Ack;
      Dev_Ack    : if      (STEP && bit_cnt == 4'h9)  nextstate = Rst_Cnt_1;
                   else                               nextstate = Dev_Ack;
      Dev_Ack_2  : if      (STEP && bit_cnt ==4'h9)   nextstate = Rst_Cnt_2;
                   else                               nextstate = Dev_Ack_2;
      Device     : if      (STEP && bit_cnt == 4'h7)  nextstate = Rd_Wrt_B;
                   else                               nextstate = Device;
      Device_2   : if      (STEP && bit_cnt == 4'h7)  nextstate = Rd_Wrt_B_2;
                   else                               nextstate = Device_2;
      Rd_Wrt_B   : if      (ABORT)                    nextstate = Idle;
                   else if (STEP && bit_cnt == 4'h8)  nextstate = Dev_Ack;
                   else                               nextstate = Rd_Wrt_B;
      Rd_Wrt_B_2 : if      (STEP && bit_cnt == 4'h8)  nextstate = Dev_Ack_2;
                   else                               nextstate = Rd_Wrt_B_2;
      Reg_Ack    : if      (STEP && bit_cnt == 4'h9)  nextstate = Rst_Cnt_2;
                   else                               nextstate = Reg_Ack;
      Reg_Adr    : if      (STEP && bit_cnt == 4'h8)  nextstate = Reg_Ack;
                   else                               nextstate = Reg_Adr;
      Rst_Cnt_1  :                                    nextstate = Reg_Adr;
      Rst_Cnt_2  : if      (START)                    nextstate = Clr_Start_2;
                   else                               nextstate = Shift_Data;
      Rst_Cnt_3  :                                    nextstate = Shift_Data;
      Shift_Data : if      (START)                    nextstate = Clr_Start_2;
                   else if (STOP)                     nextstate = Clr_Stop;
                   else if (STEP && bit_cnt == 4'h8)  nextstate = Data_Ack;
                   else                               nextstate = Shift_Data;
      Wait_4_Stop: if      (STOP)                     nextstate = Clr_Stop;
                   else                               nextstate = Wait_4_Stop;
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
      ACK <= 0;
      CAP_RW <= 0;
      CHK_DEV <= 0;
      CLR_START <= 0;
      CLR_STOP <= 0;
      LOAD_ADR <= 0;
      LOAD_RBK_DATA <= 0;
      SHIFT_ADR_REG <= 0;
      SHIFT_DATA <= 0;
      SHIFT_DEV <= 0;
      STORE <= 0;
      bit_cnt <= 4'h0;
    end
    else begin
      ACK <= 0; // default
      CAP_RW <= 0; // default
      CHK_DEV <= 0; // default
      CLR_START <= 0; // default
      CLR_STOP <= 0; // default
      LOAD_ADR <= 0; // default
      LOAD_RBK_DATA <= 0; // default
      SHIFT_ADR_REG <= 0; // default
      SHIFT_DATA <= 0; // default
      SHIFT_DEV <= 0; // default
      STORE <= 0; // default
      bit_cnt <= 4'h0; // default
      case (nextstate)
        Clr_Start  :        CLR_START <= 1;
        Clr_Start_2:        CLR_START <= 1;
        Clr_Stop   :        CLR_STOP <= 1;
        Data_Ack   : begin
                            ACK <= 1;
                            LOAD_RBK_DATA <= READ;
                            STORE <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
        Dev_Ack    : begin
                            ACK <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
        Dev_Ack_2  : begin
                            ACK <= 1;
                            LOAD_RBK_DATA <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
        Device     : begin
                            SHIFT_DEV <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
        Device_2   : begin
                            SHIFT_DEV <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
        Rd_Wrt_B   : begin
                            CAP_RW <= 1;
                            CHK_DEV <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
        Rd_Wrt_B_2 : begin
                            CAP_RW <= 1;
                            CHK_DEV <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
        Reg_Ack    : begin
                            ACK <= 1;
                            LOAD_ADR <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
        Reg_Adr    : begin
                            SHIFT_ADR_REG <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
        Rst_Cnt_1  : begin
                            SHIFT_ADR_REG <= 1;
                            bit_cnt <= 4'h1;
        end
        Rst_Cnt_2  : begin
                            SHIFT_DATA <= 1;
                            bit_cnt <= 4'h1;
        end
        Rst_Cnt_3  : begin
                            SHIFT_DATA <= 1;
                            bit_cnt <= 4'h1;
        end
        Shift_Data : begin
                            SHIFT_DATA <= 1;
                            bit_cnt <= STEP ? bit_cnt +1 : bit_cnt;
        end
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [87:0] statename;
  always @* begin
    case (state)
      Idle       : statename = "Idle";
      Clr_Start  : statename = "Clr_Start";
      Clr_Start_2: statename = "Clr_Start_2";
      Clr_Stop   : statename = "Clr_Stop";
      Data_Ack   : statename = "Data_Ack";
      Dev_Ack    : statename = "Dev_Ack";
      Dev_Ack_2  : statename = "Dev_Ack_2";
      Device     : statename = "Device";
      Device_2   : statename = "Device_2";
      Rd_Wrt_B   : statename = "Rd_Wrt_B";
      Rd_Wrt_B_2 : statename = "Rd_Wrt_B_2";
      Reg_Ack    : statename = "Reg_Ack";
      Reg_Adr    : statename = "Reg_Adr";
      Rst_Cnt_1  : statename = "Rst_Cnt_1";
      Rst_Cnt_2  : statename = "Rst_Cnt_2";
      Rst_Cnt_3  : statename = "Rst_Cnt_3";
      Shift_Data : statename = "Shift_Data";
      Wait_4_Stop: statename = "Wait_4_Stop";
      default    : statename = "XXXXXXXXXXX";
    endcase
  end
  `endif

endmodule

