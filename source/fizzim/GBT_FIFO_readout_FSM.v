
// Created by fizzim_tmr.pl version $Revision: 4.44 on 2018:11:13 at 12:11:26 (www.fizzim.com)

module GBT_FIFO_readout_FSM (
  output reg RD_EN,
  input CLK,
  input MT,
  input READY,
  input RST 
);

  // state bits
  parameter 
  Idle      = 2'b00, 
  End       = 2'b01, 
  Read_FIFO = 2'b10, 
  Wait      = 2'b11; 

  reg [1:0] state;


  reg [1:0] nextstate;


  reg [3:0] hold;

  // comb always block
  always @* begin
    nextstate = 2'bxx; // default to x because default_state_is_x is set
    case (state)
      Idle     : if (READY)         nextstate = Wait;
                 else               nextstate = Idle;
      End      : if (!READY)        nextstate = Idle;
                 else               nextstate = End;
      Read_FIFO: if (MT)            nextstate = End;
                 else               nextstate = Read_FIFO;
      Wait     : if (hold == 4'd5)  nextstate = Read_FIFO;
                 else               nextstate = Wait;
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
      RD_EN <= 0;
      hold <= 4'h0;
    end
    else begin
      RD_EN <= 0; // default
      hold <= 4'h0; // default
      case (nextstate)
        Read_FIFO: RD_EN <= 1;
        Wait     : hold <= hold + 1;
      endcase
    end
  end

  // This code allows you to see state names in simulation
  `ifndef SYNTHESIS
  reg [71:0] statename;
  always @* begin
    case (state)
      Idle     : statename = "Idle";
      End      : statename = "End";
      Read_FIFO: statename = "Read_FIFO";
      Wait     : statename = "Wait";
      default  : statename = "XXXXXXXXX";
    endcase
  end
  `endif

endmodule

