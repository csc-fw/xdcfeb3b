`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:24:23 04/30/2018
// Design Name:   PROM_Xfer
// Module Name:   F:/DCFEB/firmware/ISE_14.7/xdcfeb1a/PROM_Xfer_sim_tf.v
// Project Name:  xdcfeb1a
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PROM_Xfer
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PROM_Xfer_sim_tf;

	// Inputs
	reg CLK20;
	reg CLK40;
	reg CLK1MHZ;
	reg RST;
	reg [7:0] PARAM_DAT;
	reg PROM2FF;
	reg ECC;
	reg CRC;
	reg PF_RD;
	reg DECODE;
	reg MAN_AL;
	reg AL_START;
	reg AL_DONE;
	reg AL_ABORT;


	// Outputs
	wire AUTO_LOAD;
	wire AUTO_LOAD_ENA;
	wire [5:0] AL_CNT;
	wire CLR_AL_DONE;
	wire AL_RESTART;
	wire LOAD_DFLT;
	wire [2:0] AL_STATUS;
	wire PARAM_CLK;
	wire PARAM_CE_B;
	wire PARAM_OE;
	wire [15:0] RBK_DATA;
	wire PF_FULL;
	wire PF_MT;

	// Bidirs
	wire [35:0] VIO_CNTRL;
	wire [35:0] VIORD_CNTRL;
	wire [35:0] LA_CNTRL;

	
	wire slow_fifo_rst;
	wire slow_fifo_rst_done;

	wire al_abort_chk;
	wire al_cthresh;
	wire al_cmode;
	wire al_ctime;
	wire al_cmp_clk_phase;
	wire al_samp_clk_phase;
	wire al_nsamp;
	wire al_pdepth;
	wire al_bky_shift;
	
	wire al_rst_restart;

	wire al_cth_shck_ena;
	wire al_cth_sdata;
	wire al_dac_enb;
	wire al_cthresh_done;
	
	wire al_bky_ena;
	wire al_bky_shck_ena;
	wire al_bky_sdata;
	wire al_bshift_done;

	// Instantiate the Unit Under Test (UUT)

   PROM_Xfer #(
		.Simulation(1),
		.USE_CHIPSCOPE(0)
	) 
	PROM_Xfer1 (
		// ChipScope Pro signlas
		.VIO_CNTRL(VIO_CNTRL), 
		.VIORD_CNTRL(VIORD_CNTRL),
		.LA_CNTRL(LA_CNTRL), 
		//inputs
		.CLK20(CLK20), 
		.CLK40(CLK40), 
		.RST(RST), 
		.PARAM_DAT(PARAM_DAT), 
		.PROM2FF(PROM2FF), 
		.ECC(ECC), 
		.CRC(CRC), 
		.PF_RD(PF_RD), 
		.DECODE(DECODE), 
		.MAN_AL(MAN_AL), 
		//
		.SLOW_FIFO_RST_DONE(slow_fifo_rst_done),
		.AL_START(AL_START),             // Start Auto load process (from Reset Manager)
		.AL_DONE(AL_DONE),               // Auto load process complete
		.AL_ABORT(AL_ABORT),             // Auto load aborted due to bad first word

		//outputs
	   .AUTO_LOAD(AUTO_LOAD),           // Auto load pulse for clock enabling registers;
	   .AUTO_LOAD_ENA(AUTO_LOAD_ENA),   // High during Auto load process
	   .AL_CNT(AL_CNT),                 // Auto load counter
	   .CLR_AL_DONE(CLR_AL_DONE),       // Clear Auto Load Done flag
	   .AL_RESTART(AL_RESTART),         // Auto Load Restart aftter abort signal
	   .LOAD_DFLT(LOAD_DFLT),           // Load defaults if no good parameters are found
		.AL_STATUS(AL_STATUS),
		//
		.PARAM_CLK(PARAM_CLK), 
		.PARAM_CE_B(PARAM_CE_B), 
		.PARAM_OE(PARAM_OE), 
		.RBK_DATA(RBK_DATA), 
		.PF_FULL(PF_FULL), 
		.PF_MT(PF_MT)	
	);

   integer i;

assign VIO_CNTRL = 36'h000000000;
assign VIORD_CNTRL = 36'h000000000;
assign LA_CNTRL = 36'h000000000;

   parameter CMS_PERIOD = 24;

	initial begin
      CLK40 = 1'b1;
      forever
         #(CMS_PERIOD/2) CLK40 = ~CLK40;
	end
	
	initial begin
		// Initialize Inputs
      CLK20 = 1'b1;
      forever
         #(CMS_PERIOD) CLK20 = ~CLK20;
	end

	initial begin
      CLK1MHZ = 1'b1;
      forever
         #(2*CMS_PERIOD) CLK1MHZ = ~CLK1MHZ;
	end

// XCF08 PROM
   reg  [7:0] xcf08_prom [9'h1FF:9'h000];
	reg  [8:0] addr;
   wire [7:0] stored_data;
	wire prm_rst;
	
	initial begin
//	   $readmemh ("XCF08_sim_data", xcf08_prom, 9'd0, 9'd135); //two sequences of parameters
//	   $readmemh ("XCF08_sim_data_crc", xcf08_prom, 9'd0, 9'd143); //two sequences of parameters
//	   $readmemh ("XCF08_sim_data_encoded", xcf08_prom, 9'd0, 9'd407);
//	   $readmemh ("XCF08_sim_data_encoded_crc", xcf08_prom, 9'd0, 9'd433);
//	   $readmemh ("XCF08_sim_data_encoded_crc_errors", xcf08_prom, 9'd0, 9'd433);
//	   $readmemh ("XCF08_inc_data_encoded_crc", xcf08_prom, 9'd0, 9'd433);
//	   $readmemh ("XCF08_sim_data_bad_head_encoded", xcf08_prom, 9'd0, 9'd407);
	   $readmemh ("XCF08_sim_data_encoded_b904", xcf08_prom, 9'd0, 9'd407);
	end

assign stored_data = xcf08_prom[addr];
assign prm_rst = PARAM_CE_B | ~PARAM_OE;
 

always @(*)
begin
	if(PARAM_OE) begin
		PARAM_DAT = #10 stored_data;
	end
	else begin
		PARAM_DAT = #10 8'hZZ;
	end
end

always @(posedge PARAM_CLK or posedge prm_rst)
begin
	if(prm_rst) begin
		addr <= 9'h000;
	end
	else begin
		addr <= addr + 1;
	end
end
	assign al_abort_chk      = AUTO_LOAD & (AL_CNT == 6'h00);
	assign al_cthresh        = AUTO_LOAD & (AL_CNT == 6'h01);
	assign al_cmode          = AUTO_LOAD & (AL_CNT == 6'h02);
	assign al_ctime          = AUTO_LOAD & (AL_CNT == 6'h03);
	assign al_cmp_clk_phase  = AUTO_LOAD & (AL_CNT == 6'h04);
	assign al_samp_clk_phase = AUTO_LOAD & (AL_CNT == 6'h05);
	assign al_nsamp          = AUTO_LOAD & (AL_CNT == 6'h06);
	assign al_pdepth         = AUTO_LOAD & (AL_CNT == 6'h07);
	assign al_bky_shift      = AUTO_LOAD & ((AL_CNT >= 6'h10) && (AL_CNT <= 6'h21));


	assign al_rst_restart    = RST || AL_RESTART;

always @(posedge CLK40 or posedge RST) begin
	if(RST)
		AL_ABORT <= 0;
	else
		if(CLR_AL_DONE)
			AL_ABORT <= 0;
		else if(al_abort_chk)
			AL_ABORT <= (RBK_DATA != 16'h4321);
		else
			AL_ABORT <= AL_ABORT;
end

always @(posedge CLK40 or posedge RST) begin
	if(RST)
		AL_DONE <= 0;
	else
		if(CLR_AL_DONE)
			AL_DONE <= 0;
		else if(al_cthresh_done && al_bshift_done)
			AL_DONE <= 1;
		else
			AL_DONE <= AL_DONE;
end

	al_cdac #(
		.TMR(0)
	)
	al_cdac_i (
		//inputs
		.CLK40(CLK40),
		.CLK1MHZ(CLK1MHZ),
		.RST(al_rst_restart),
		.CLR_AL_DONE(CLR_AL_DONE),
		.CAPTURE(al_cthresh),
		.LOAD_DFLT(LOAD_DFLT),
		.BPI_AL_REG(RBK_DATA[11:0]),
		//
		.SHCK_ENA(al_cth_shck_ena),
		.SDATA(al_cth_sdata),
		.DAC_ENB(al_dac_enb),
		.CDAC_DONE(al_cthresh_done)
	);


	al_buckeye_load #(
		.TMR(0)
	)
	al_buckeye_load_i(
		//inputs
		.CLK40(CLK40),
		.CLK1MHZ(CLK1MHZ),
		.RST(al_rst_restart),
		.SLOW_FIFO_RST(slow_fifo_rst),
		.CLR_AL_DONE(CLR_AL_DONE),
		.CAPTURE(al_bky_shift),
		.LOAD_DFLT(LOAD_DFLT),
		.BPI_AL_REG(RBK_DATA),
		//outputs
		.AL_BKY_ENA(al_bky_ena),
		.SHCK_ENA(al_bky_shck_ena),
		.SDATA(al_bky_sdata),
		.AL_DONE(al_bshift_done)
	);

	FIFO_Rst_FSM
	SLOW_FIFO_Rst_i ( // reset AUTO_LOAD FIFO
		.DONE(slow_fifo_rst_done),
		.FIFO_RST(slow_fifo_rst),
		.AL_RESTART(AL_RESTART),
		.CLK(~CLK1MHZ),
		.RST(RST) 
	);

	initial begin
		// Initialize Inputs
		RST = 1;
		PROM2FF = 0;
		ECC = 1;
		CRC = 0;
		PF_RD = 0;
		DECODE = 0;
		MAN_AL =0;
      AL_START =0;

		// Add stimulus here
		// Wait 100 ns for global reset to finish
		#120;
		#1 // offset transitions
		#(40*5*CMS_PERIOD);
		RST = 0;
		#(40*5*CMS_PERIOD);
		DECODE = 1;
		#(6250*CMS_PERIOD);
//		for(i=0;i<34*1;i=i+1) begin
//			PF_RD = 1;
//			# CMS_PERIOD;
//			PF_RD = 0;
//			#(40*5*CMS_PERIOD);
//		end
//			PF_RD = 1;
//			# (34*CMS_PERIOD);
//			PF_RD = 0;
//			#(40*5*CMS_PERIOD);
		AL_START = 1;
	end
      
endmodule

