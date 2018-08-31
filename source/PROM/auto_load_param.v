`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:31:59 10/30/2017 
// Design Name: 
// Module Name:    auto_load_param 
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
module auto_load_param #(
	parameter USE_CHIPSCOPE = 0,
	parameter TMR = 0,
	parameter TMR_Err_Det = 0
)(
	inout [35:0] VIO_CNTRL,
	inout [35:0] LA_CNTRL,
	input CLK,
	input RST,
	input [7:0] PARAM_DAT,
	output PARAM_CLK,
	output PARAM_CE_B,
	output PARAM_OE
);

wire CSP_AL_START;

generate
if(USE_CHIPSCOPE==1) 
begin : chipscope_auto_load
//
// Logic analyzer and i/o for auto loading constants
//wire [127:0] al_vio_async_in;
//wire [59:0]  al_vio_async_out;
wire [31:0] al_vio_sync_in;
wire [3:0]  al_vio_sync_out;
wire [64:0] al_la_data;
wire [7:0] al_la_trig;

//wire [3:0] dummy_asigs;
wire [3:0] dummy_ssigs;

	auto_load_vio auto_load_vio_i (
		 .CONTROL(VIO_CNTRL), // INOUT BUS [35:0]
		 .CLK(CLK),
//		 .ASYNC_IN(al_vio_async_in), // IN BUS [127:0]
//		 .ASYNC_OUT(al_vio_async_out), // OUT BUS [59:0]
		 .SYNC_IN(al_vio_sync_in), // IN BUS [31:0]
		 .SYNC_OUT(al_vio_sync_out) // OUT BUS [3:0]
	);


//		 ASYNC_IN [127:0]
//	assign al_vio_async_in[127:0]     = {rbkbuf0,rbkbuf1,rbkbuf2,rbkbuf3,rbkbuf4,rbkbuf5,rbkbuf6,rbkbuf7};
		 
//		 ASYNC_OUT [59:0]
//	assign csp_start_offset    = al_vio_async_out[15:0];
//	assign dummy_asigs[2:0]    = al_vio_async_out[59:57];

//		 SYNC_IN [31:0]
	assign al_vio_sync_in[3:0]     = al_state; // seq_state
	assign al_vio_sync_in[6:4]     = AL_STATUS;
	assign al_vio_sync_in[29:7]    = AL_ADDR;
	assign al_vio_sync_in[31:30]   = 2'b00;

//		 SYNC_OUT [3:0]
	assign CSP_AL_START        = al_vio_sync_out[0];
	assign dummy_ssigs[3:1] 	= al_vio_sync_out[3:1];

auto_load_la auto_load_la_i (
    .CONTROL(LA_CNTRL),
    .CLK(CLK),
    .DATA(al_la_data),  // IN BUS [64:0]
    .TRIG0(al_la_trig)  // IN BUS [7:0]
);

// LA Data [64:0]
	assign al_la_data[3:0]     = al_state[3:0];
	assign al_la_data[26:4]    = AL_ADDR[22:0];
	assign al_la_data[29:27]   = AL_CNT[2:0];
	assign al_la_data[32:30]   = al_blk[2:0];
	assign al_la_data[34:33]   = al_pblk[1:0];
	assign al_la_data[50:35]   = BPI_AL_REG[15:0];
	assign al_la_data[53:51]   = AL_STATUS[2:0];
	assign al_la_data[54]      = BUSY;
	assign al_la_data[55]      = AL_START;
	assign al_la_data[56]      = AL_DONE;
	assign al_la_data[57]      = CSP_AL_START;
	assign al_la_data[58]      = AL_EXECUTE;
	assign al_la_data[59]      = AUTO_LOAD_ENA;
	assign al_la_data[60]      = CLR_AL_DONE;
	assign al_la_data[61]      = al_aborted;
	assign al_la_data[62]      = al_completed;
	assign al_la_data[63]      = BPI_LOAD_DATA;
	assign al_la_data[64]      = AUTO_LOAD;
	

// LA Trigger [7:0]
	assign al_la_trig[0]       = AL_START;
	assign al_la_trig[1]       = CSP_AL_START;
	assign al_la_trig[2]       = AL_DONE;
	assign al_la_trig[3]       = BUSY;
	assign al_la_trig[4]       = AL_EXECUTE;
	assign al_la_trig[5]       = AUTO_LOAD_ENA;
	assign al_la_trig[6]       = CLR_AL_DONE;
	assign al_la_trig[7]       = 1'b0;
	
end
else
begin
	assign CSP_AL_START = 0;
end
endgenerate

wire [7:0] param_dat_in;
wire pclk;
wire pce;
wire poe;

assign pclk = 1'b0;
assign pce  = 1'b0;
assign poe  = 1'b0;

  IBUF IBUF_PARAM_DAT[7:0] (.O(param_dat_in),.I(PARAM_DAT));
  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_PARAM_CLK (.O(PARAM_CLK),.I(pclk));
  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_PARAM_CE_B (.O(PARAM_CE_B),.I(~pce));
  OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_PARAM_OE (.O(PARAM_OE),.I(poe));


endmodule
