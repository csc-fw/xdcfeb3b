`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:10:16 03/09/2011 
// Design Name: 
// Module Name:    bpi_interface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module startup_display #(
	parameter TMR = 0
)
(
    input CLK,
	 input CLK1MHZ,
	 input RST,
	// signals for LED'S after programing
	 input RUN,
	 input [15:0] DCFEB_STATUS,
	 input GBT_ENA_TEST,
	 // internal outputs
	 output [15:0] DATA_IN,
	 // external connections
    inout [15:0] CFG_DAT
    );

wire [15:0] data_dir;
wire [15:0] data_out_i;
wire [15:0] leds_out;
wire clk100k;
wire q15;
 
reg [63:0] ram0 [31:0];
wire [63:0] duty_cycle;
wire [3:0] dc [15:0];
reg [7:0] cycle_pat [15:0];
reg [7:0] cycle [15:0];
reg [4:0] raddr;
reg [15:0] timer;
reg [3:0] passes;
wire rst_timer;
wire display;
wire load_pat;
wire nxt_adr;
wire stop;
wire clear;


initial begin
	$readmemh ("LED_ram_contents", ram0, 0, 31);
end
  

  IOBUF #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) IOBUF_CFG_DAT[15:0] (.O(DATA_IN),.IO(CFG_DAT),.I(data_out_i),.T(data_dir));
//  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_CFG_DAT[15:0] (.O(CFG_DAT),.I(data_out_i));

assign data_dir = GBT_ENA_TEST ? 16'hFFFF : 16'h0000; // default is output.
assign leds_out   = display ? {cycle[15][0],cycle[14][0],cycle[13][0],cycle[12][0],cycle[11][0],cycle[10][0],cycle[9][0],cycle[8][0],cycle[7][0],cycle[6][0],cycle[5][0],cycle[4][0],cycle[3][0],cycle[2][0],cycle[1][0],cycle[0][0]} : DCFEB_STATUS;  // can be assigned to user defined signals after programming
assign duty_cycle = ram0[raddr];
assign {dc[15],dc[14],dc[13],dc[12],dc[11],dc[10],dc[9],dc[8],dc[7],dc[6],dc[5],dc[4],dc[3],dc[2],dc[1],dc[0]} = duty_cycle;
assign stop       = (passes == 4'h3);
  
generate
if(TMR==1) 
begin : Startup_FSM_TMR


	Startup_Display_FSM_TMR 
	Startup_Display_FSM_i(
	  .CLEAR(clear),
	  .DISP(display),
	  .LOAD_PAT(load_pat),
	  .NXT_ADR(nxt_adr),
	  .RST_TIMER(rst_timer),
	  .CLK(CLK),
	  .DONE(stop),
	  .RST(RST),
	  .RUN(RUN),
	  .TIMER(timer)
	);
	
	assign data_out_i   =  leds_out;
	
end
else 
begin : Startup_FSM


	Startup_Display_FSM 
	Startup_Display_FSM_i(
	  .CLEAR(clear),
	  .DISP(display),
	  .LOAD_PAT(load_pat),
	  .NXT_ADR(nxt_adr),
	  .RST_TIMER(rst_timer),
	  .CLK(CLK),
	  .DONE(stop),
	  .RST(RST),
	  .RUN(RUN),
	  .TIMER(timer)
	);
	
	assign data_out_i   =  leds_out;
	
end
endgenerate

genvar ch;
generate
	for(ch=0;ch<16;ch=ch+1) begin : decode_duty_cycle
		always @* begin
			case(dc[ch])
				4'h0: cycle_pat[ch] <= 8'b00000000;
				4'h1: cycle_pat[ch] <= 8'b00000001;
				4'h2: cycle_pat[ch] <= 8'b00000011;
				4'h3: cycle_pat[ch] <= 8'b00000111;
				4'h4: cycle_pat[ch] <= 8'b00001111;
				4'h5: cycle_pat[ch] <= 8'b00011111;
				4'h6: cycle_pat[ch] <= 8'b00111111;
				4'h7: cycle_pat[ch] <= 8'b01111111;
				default: cycle_pat[ch] <= 8'b11111111;
			endcase
		end
		always @(posedge CLK) begin
			if(load_pat)
				cycle[ch] <= cycle_pat[ch];
			else
				cycle[ch] <= {cycle[ch][6:0],cycle[ch][7]};
		end
	end
endgenerate

   SRLC16E #(.INIT(16'hFFFF)) // 1MHz clock divided by 10, 100KHz clock 10. uSec period.
	SRLC16E_clk100k_inst (
      .Q(clk100k),     // SRL data output
      .Q15(q15), // SRL cascade output pin
      .A0(1'b0),     // Select[0] input (output at 5 clocks)
      .A1(1'b0),     // Select[1] input
      .A2(1'b1),     // Select[2] input
      .A3(1'b0),     // Select[3] input
      .CE(1'b1),   // Clock enable input
      .CLK(CLK1MHZ), // Clock input
      .D(~clk100k)      // SRL data input
   );


always @(posedge clk100k or posedge rst_timer) begin
	if(rst_timer)
		timer <= 16'h0000;
	else
		timer <= timer + 1;
end
always @(posedge CLK or posedge RST) begin
	if(RST)
		raddr <= 5'h00;
	else
		if(clear)
			raddr <= 5'h00;
		else if(nxt_adr)
			raddr <= raddr + 1;
		else
			raddr <= raddr;
end
always @(posedge CLK or posedge RST) begin
	if(RST)
		passes <= 4'h0;
	else
		if(load_pat && (raddr == 5'h1F))
			passes <= passes + 1;
		else
			passes <= passes;
end

endmodule
