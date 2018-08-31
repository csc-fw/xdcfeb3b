`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:34:13 04/27/2018 
// Design Name: 
// Module Name:    PROM_Xfer 
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
module PROM_Xfer #(
	parameter Simulation = 0,
	parameter USE_CHIPSCOPE = 0
)(
	// ChipScope Pro signlas
	inout [35:0] VIO_CNTRL,
	inout [35:0] VIORD_CNTRL,
	inout [35:0] LA_CNTRL,
	//
	input CLK20,
	input CLK40,
	input RST,
	input [7:0] PARAM_DAT,
	input PROM2FF,
	input ECC,
	input CRC,
	input PF_RD,
	input DECODE,
	input MAN_AL,
	input SLOW_FIFO_RST_DONE,
	input AL_START,           // Start Auto load process (from Reset Manager)
	input AL_DONE,            // Auto load process complete
	input AL_ABORT,           // Auto load aborted due to bad first word
	//
	output AUTO_LOAD,         // Auto load pulse for clock enabling registers;
	output AUTO_LOAD_ENA,     // High during Auto load process
	output [5:0] AL_CNT,      // Auto load counter
	output CLR_AL_DONE,       // Clear Auto Load Done flag
	output AL_RESTART,        // Auto Load Restart after abort signal
	output LOAD_DFLT,         // Load defaults if no good parameters are found
	output [2:0] AL_STATUS,   // Auto Load Status bits {al_abrtd, al_cmplt, AL_START}
	output PARAM_CLK,
	output PARAM_CE_B,
	output PARAM_OE,
	output [15:0] RBK_DATA,
	output PF_FULL,
	output PF_MT
);

// Data
wire [7:0] data_in;

// flags and control signals
wire rst_i, csp_rst;
wire prom2ff_i, csp_prom2ff, al_prom2ff;
wire ecc_i, csp_ecc;
wire crc_i, csp_crc;
wire pf_rd_i, csp_pf_rd, al_pf_rd;
wire decode_i, csp_decode;
wire csp_control;
wire al_dcd_valid;
wire load_valid, gen_load_valid;
wire clr_crc, dly_clr_crc, gen_clr_crc;
wire crc_dv, dly_crc_dv, gen_crc_dv;
wire crc_good;
reg  crc_rdy;
wire load_high_crc;
reg [15:0] high_crc;
//
reg [5:0] al_dcd_srl;
reg [5:0] load_srl;
reg [5:0] clr_crc_srl;
reg [5:0] crc_dv_srl;
reg [5:0] al_cnt_srl [5:0];
wire [5:0] al_cnt_prompt;
wire [5:0] dly_al_cnt;
wire prom_xfer_done;
wire man_al_i, csp_man_al;
wire abort_al;
wire al_abrtd;
wire al_cmplt;
wire param_xfer_cmplt;

// PROM control signals
wire ce;
wire oe;

// PROM_Xfer State machine signals
wire inc;
wire ldb0;
wire ldb1;
wire ldb2;
wire ldb3;
wire ldb4;
wire ldb5;
wire rst_cnt;
wire [3:0] pxfer_state;

// Auto_Load_Param State machine signals
wire [4:0] al_state;


// counter
reg [8:0] prm_cnt;

// FIFO signals
wire rd_en;
reg wr_en;
reg [47:0] in_reg;
wire [47:0] out_reg;

//Golay decoder signals
wire [11:0] dcd_data1;
wire [11:0] dcd_data2;
wire [11:0] dcd_parity1;
wire [11:0] dcd_parity2;
wire good_word1;
wire good_word2;
wire bad_tx1;
wire bad_tx2;

// CRC signals
wire [15:0] crc_reg;

   IBUF IBUF_PARAM_DAT[7:0] (.O(data_in),.I(PARAM_DAT));
	OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_PARAM_CLK  (.O(PARAM_CLK),.I(CLK20));  // 20 MHz clock to PROM
	OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_PARAM_CE_B (.O(PARAM_CE_B),.I(~ce)); // Chip Enable for PROM
	OBUF  #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_PARAM_OE   (.O(PARAM_OE),.I(oe));    // Output Enable for PROM
	
assign AL_STATUS = {al_abrtd, al_cmplt, AL_START};
	
generate
if(USE_CHIPSCOPE==1) 
begin : chipscope_param_xfer
// Logic analyzer and i/o for parameter transfer from PROM to FIFO
//
wire [19:0] pxfer_vio_async_in;
wire [7:0]  pxfer_vio_sync_out;
wire [19:0] pfrd_vio_sync_in;
wire [3:0]  pfrd_vio_sync_out;
wire [206:0] pxfer_la_data;
wire [7:0] pxfer_la_trig;

wire [4:0] dummy_ssigs;

	param_xfer_vio param_xfer_vio_i (
		 .CONTROL(VIO_CNTRL), // INOUT BUS [35:0]
		 .CLK(CLK20),
		 .ASYNC_IN(pxfer_vio_async_in), // IN BUS [19:0]
		 .SYNC_OUT(pxfer_vio_sync_out) // OUT BUS [7:0]
	);

//		 SYNC_IN [19:0]
	assign pxfer_vio_async_in[7:0]  = data_in[7:0];
	assign pxfer_vio_async_in[11:8] = pxfer_state[3:0];
	assign pxfer_vio_async_in[12]   = rst_i;
	assign pxfer_vio_async_in[13]   = ce;
	assign pxfer_vio_async_in[14]   = oe;
	assign pxfer_vio_async_in[15]   = prom2ff_i;
	assign pxfer_vio_async_in[16]   = ecc_i;
	assign pxfer_vio_async_in[17]   = crc_i;
	assign pxfer_vio_async_in[18]   = csp_control;
	assign pxfer_vio_async_in[19]   = 1'b0;
	
//		 SYNC_OUT [7:0]
	assign csp_control      = pxfer_vio_sync_out[0];
	assign csp_rst          = pxfer_vio_sync_out[1];
	assign csp_prom2ff      = pxfer_vio_sync_out[2];
	assign csp_ecc          = pxfer_vio_sync_out[3];
	assign csp_crc          = pxfer_vio_sync_out[4];
	assign csp_man_al       = pxfer_vio_sync_out[5];
	assign dummy_ssigs[1:0] = pxfer_vio_sync_out[7:6];


	param_xfer_viord param_xfer_viord_i (
		 .CONTROL(VIORD_CNTRL), // INOUT BUS [35:0]
		 .CLK(CLK40),
		 .SYNC_IN(pfrd_vio_sync_in), // IN BUS [19:0]
		 .SYNC_OUT(pfrd_vio_sync_out) // OUT BUS [3:0]
	);

//		 SYNC_IN [19:0]
	assign pfrd_vio_sync_in[15:0]  = RBK_DATA;
	assign pfrd_vio_sync_in[16]    = PF_FULL;
	assign pfrd_vio_sync_in[17]    = PF_MT;
	assign pfrd_vio_sync_in[19:18] = 2'b00;

//		 SYNC_OUT [3:0]
	assign csp_pf_rd        = pfrd_vio_sync_out[0];
	assign csp_decode       = pfrd_vio_sync_out[1];
	assign dummy_ssigs[3]   = pfrd_vio_sync_out[2];
	assign dummy_ssigs[4]   = pfrd_vio_sync_out[3];

	param_xfer_la param_xfer_la_i (
		 .CONTROL(LA_CNTRL),
		 .CLK(CLK40),
		 .DATA(pxfer_la_data),  // IN BUS [206:0]
		 .TRIG0(pxfer_la_trig)  // IN BUS [7:0]
	);

// LA Data [205:0]
	assign pxfer_la_data[7:0]     = data_in[7:0];
	assign pxfer_la_data[55:8]    = in_reg[47:0];
	assign pxfer_la_data[103:56]  = out_reg[47:0];
	assign pxfer_la_data[151:104] = {dcd_parity2,dcd_data2,dcd_parity1,dcd_data1};
	assign pxfer_la_data[160:152] = prm_cnt[8:0];
	assign pxfer_la_data[164:161] = pxfer_state[3:0];
	assign pxfer_la_data[165]     = rst_i;
	assign pxfer_la_data[166]     = ce;
	assign pxfer_la_data[167]     = oe;
	assign pxfer_la_data[168]     = prom2ff_i;
	assign pxfer_la_data[169]     = ecc_i;
	assign pxfer_la_data[170]     = crc_i;
	assign pxfer_la_data[171]     = csp_control;
	assign pxfer_la_data[172]     = inc;
	assign pxfer_la_data[173]     = ldb0;
	assign pxfer_la_data[174]     = ldb1;
	assign pxfer_la_data[175]     = ldb2;
	assign pxfer_la_data[176]     = ldb3;
	assign pxfer_la_data[177]     = ldb4;
	assign pxfer_la_data[178]     = ldb5;
	assign pxfer_la_data[179]     = rst_cnt;
	assign pxfer_la_data[180]     = wr_en;
	assign pxfer_la_data[181]     = pf_rd_i;
	assign pxfer_la_data[182]     = decode_i;
	assign pxfer_la_data[183]     = rd_en;
	assign pxfer_la_data[184]     = good_word1;
	assign pxfer_la_data[185]     = good_word2;
	assign pxfer_la_data[186]     = bad_tx1;
	assign pxfer_la_data[187]     = bad_tx2;
	assign pxfer_la_data[203:188] = RBK_DATA[15:0];
	assign pxfer_la_data[204]     = PF_FULL;
	assign pxfer_la_data[205]     = PF_MT;
	assign pxfer_la_data[206]     = load_valid;

// LA Trigger [7:0]
	assign pxfer_la_trig[0]       = rst_i;
	assign pxfer_la_trig[1]       = rst_cnt;
	assign pxfer_la_trig[2]       = prom2ff_i;
	assign pxfer_la_trig[3]       = oe;
	assign pxfer_la_trig[4]       = wr_en;
	assign pxfer_la_trig[5]       = pf_rd_i;
	assign pxfer_la_trig[6]       = rd_en;
	assign pxfer_la_trig[7]       = 1'b0;
	
end
else
begin
	assign csp_rst = 0;
	assign csp_prom2ff = 0;
	assign csp_pf_rd = 0;
	assign csp_control = 0;
	assign csp_ecc = 0;
	assign csp_crc = 0;
	assign csp_decode = 0;
	assign csp_man_al = 0;
end
endgenerate


	assign rst_i     = csp_rst     | RST;
	assign prom2ff_i = csp_prom2ff | PROM2FF | al_prom2ff;
	assign pf_rd_i   = csp_pf_rd   | PF_RD | al_pf_rd;
	assign ecc_i     = csp_control ? csp_ecc : ECC;
	assign crc_i     = csp_control ? csp_crc : CRC;
	assign decode_i  = csp_control ? csp_decode : DECODE;
	assign man_al_i  = csp_control ? csp_man_al : MAN_AL;

	assign abort_al  = AL_ABORT || (decode_i && load_valid && !(good_word1 && good_word2));

	always @(posedge CLK20 or posedge rst_cnt) begin
		if(rst_cnt) begin
			prm_cnt <= 9'h000;
		end
		else begin
			if(inc) begin
				prm_cnt <= prm_cnt + 1;
			end
		end
	end

	always @(posedge CLK20) begin
		if(ldb0) in_reg[ 7: 0] <= data_in;
		if(ldb1) in_reg[15: 8] <= data_in;
		if(ldb2) in_reg[23:16] <= data_in;
		if(ldb3) in_reg[31:24] <= data_in;
		if(ldb4) in_reg[39:32] <= data_in;
		if(ldb5) in_reg[47:40] <= data_in;
		wr_en <= inc;
	end

Prom_Xfer_FSM 
  #(
	.MAX_WRDS(9'd34),
	.NMAX(4'd2)
  )
Prom_Xfer_FSM1(
  .CE(ce),
  .INC(inc),
  .LDB0(ldb0),
  .LDB1(ldb1),
  .LDB2(ldb2),
  .LDB3(ldb3),
  .LDB4(ldb4),
  .LDB5(ldb5),
  .OE(oe),
  .RST_CNT(rst_cnt),
  .XFER_DONE(prom_xfer_done),
  .PXFER_STATE(pxfer_state),
  .CLK(CLK20),
  .CNT(prm_cnt),
  .CRC(crc_i),
  .ECC(ecc_i),
  .PROM2FF(prom2ff_i),
  .RST(rst_i)
);

Read_PF_FSM 
Read_PF_FSM1(
  .OUT_DATA(RBK_DATA),
  .RD_EN(rd_en),
  .CLK(CLK40),
  .DCDWRD({dcd_data2[7:0],dcd_data1[7:0]}),
  .DECODE(decode_i),
  .ECC(ecc_i),
  .FFWRD(out_reg),
  .PF_RD(pf_rd_i),
  .RST(rst_cnt)
);


Auto_Load_Param_FSM #(
	.MAX_ATMPT(9'd2),
	.MAX_WRDS(9'd34)
)
Auto_Load_Param_1 (
	//outputs
  .AL_ABRTD(al_abrtd),
  .AL_CMPLT(al_cmplt),
  .AL_CNT(al_cnt_prompt),
  .AL_PF_RD(al_pf_rd),
  .AL_PROM2FF(al_prom2ff),
  .AL_RESTART(AL_RESTART),
  .AUTO_LOAD_ENA(AUTO_LOAD_ENA),
  .CLR_AL_DONE(CLR_AL_DONE),
  .CLR_CRC(clr_crc),
  .CRC_DV(crc_dv),
  .LOAD_DFLT(LOAD_DFLT),
  .XFER_CMPLT(param_xfer_cmplt),
  .AL_STATE(al_state),
  //inputs
  .AL_ABORT(abort_al),
  .AL_DONE(AL_DONE),
  .AL_START(AL_START),
  .CLK(CLK40),
  .CRC(crc_i),
  .CRC_GOOD(crc_good),
  .CRC_RDY(crc_rdy),
  .MAN_AL(man_al_i),
  .RST(rst_i),
  .SLOW_FIFO_RST_DONE(SLOW_FIFO_RST_DONE),
  .XFER_DONE(prom_xfer_done)
);

// pipeline for when decoded data is valid for loading
(* syn_srlstyle = "select_srl" *)
always @(posedge CLK40) begin
	load_srl <= {load_srl[4:0],rd_en};
	clr_crc_srl <= {clr_crc_srl[4:0],clr_crc};
	crc_dv_srl <= {crc_dv_srl[4:0],crc_dv};
end
(* syn_srlstyle = "select_srl" *)
always @(posedge CLK40 or posedge AL_RESTART) begin
	if(AL_RESTART) begin
		al_dcd_srl <= 6'b000000;
	end
	else begin
		al_dcd_srl <= {al_dcd_srl[4:0],al_pf_rd};
	end
end

assign al_dcd_valid   = al_dcd_srl[5];
assign load_valid     = load_srl[5];
assign dly_clr_crc    = clr_crc_srl[5];
assign dly_crc_dv     = crc_dv_srl[5];

assign AUTO_LOAD      = decode_i ? al_dcd_valid : al_pf_rd;
assign gen_load_valid = decode_i ? load_valid   : al_pf_rd;
assign gen_clr_crc    = decode_i ? dly_clr_crc  : clr_crc;
assign gen_crc_dv     = decode_i ? dly_crc_dv   : crc_dv;
assign AL_CNT         = decode_i ? dly_al_cnt   : al_cnt_prompt;

//Pipeline for AL_CNT
genvar i;
generate
	for (i=0;i<6;i=i+1)
	begin: bus_srl
(* syn_srlstyle = "select_srl" *)
		always @(posedge CLK40) begin
			al_cnt_srl[i] <= {al_cnt_srl[i][4:0],al_cnt_prompt[i]};
		end
		assign dly_al_cnt[i] = al_cnt_srl[i][5];
	end
endgenerate

generate
if(Simulation==1)
begin : Sim_FIFO
	reg [8:0] waddr;
	reg [8:0] raddr;
	reg [47:0] prmfifo [511:0];
	
	always @(posedge CLK20 or posedge rst_cnt) begin
		if(rst_cnt) begin
			waddr <= 9'h000;
		end
		else
			if(wr_en) begin
				waddr <= waddr + 1;
			end
	end
	always @(posedge CLK20) begin
		if(wr_en) prmfifo[waddr] <= in_reg;
	end
	
	always @(posedge CLK40 or posedge rst_cnt) begin
		if(rst_cnt) begin
			raddr <= 9'h000;
		end
		else
			if (rd_en) begin
				raddr <= raddr + 1;
			end
	end
	assign out_reg = prmfifo[raddr];
	assign PF_FULL = (waddr-raddr)==9'h1FF;
	assign PF_MT   = waddr==raddr;
	
end
else
begin : builtin_FIFO

	param_fifo param_fifo1 (
		.rst(rst_cnt), // input rst
		.wr_clk(CLK20), // input wr_clk
		.rd_clk(CLK40), // input rd_clk
		.din(in_reg), // input [47 : 0] din
		.wr_en(wr_en), // input wr_en
		.rd_en(rd_en), // input rd_en
		.dout(out_reg), // output [47 : 0] dout
		.full(PF_FULL), // output full
		.empty(PF_MT) // output empty
	);
	
end
endgenerate


///////////////////////////////////////////////////////////////
//                                                           //
// DECODER for Golay(24,12) ECC code                         //
//                                                           //
///////////////////////////////////////////////////////////////

ecc_decode
ecc_decode_FF1(
	.CLK(CLK40),
	.RCV_DATA(out_reg[11:0]),
	.RCV_PARITY(out_reg[23:12]),
	.GOOD_WORD(good_word1),
	.DCD_DATA(dcd_data1),
	.DCD_PARITY(dcd_parity1),
	.BAD_TX(bad_tx1)
);

ecc_decode
ecc_decode_FF2(
	.CLK(CLK40),
	.RCV_DATA(out_reg[35:24]),
	.RCV_PARITY(out_reg[47:36]),
	.GOOD_WORD(good_word2),
	.DCD_DATA(dcd_data2),
	.DCD_PARITY(dcd_parity2),
	.BAD_TX(bad_tx2)
);



//	crc_gen_tmr crc_gen_tmr_i(
//		.CRC1(crc_1),
//		.CRC2(crc_2),
//		.CRC3(crc_3),
//		.D(TXD),
//		.CALC(crc_calc),
//		.INIT(clr_crc),
//		.D_VALID(crc_dv),
//		.CLK(usr_clk_wordwise),
//		.RESET(reset)
//	);

//
//Note: the CRC magic number (CRC32 residue) is 0xC704DD7B
//When complemented and bit flipped the magic number is 0xDF1C2144
//	
	crc_gen crc_gen_i(
		.crc(crc_reg),
		.d(RBK_DATA),
		.calc(gen_load_valid),
		.init(gen_clr_crc),
		.d_valid(gen_crc_dv),
		.clk(CLK40),
		.reset(rst_i)
	);

assign load_high_crc = gen_crc_dv && !gen_load_valid;

always @(posedge CLK40) begin
	if(load_high_crc)	high_crc <= crc_reg;
	crc_rdy <= load_high_crc;
end
assign crc_good = ({high_crc,crc_reg} == 32'hDF1C2144); // Magic number complemented and bit flipped.

endmodule
