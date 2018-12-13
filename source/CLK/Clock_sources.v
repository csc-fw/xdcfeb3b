`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:07:31 03/10/2011 
// Design Name: 
// Module Name:    Clock_sources 
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
module Clock_sources #(
	parameter Simulation = 0,
	parameter TMR = 0,
	parameter TMR_Err_Det = 0
)(
    input CMS_CLK_N,
    input CMS_CLK_P,
    input CMS80_N,
    input CMS80_P,
    input QPLL_CLK_AC_N,
    input QPLL_CLK_AC_P,
    input XO_CLK_AC_N,
    input XO_CLK_AC_P,
    input GC0N,
    input GC0P,
    input GC1N,
    input GC1P,
	 input CMP_PHS_JTAG_RST,
	 input  [4:0] CMP_CLK_PHASE,  
	 input  [2:0] SAMP_CLK_PHASE,
	 input SAMP_CLK_PHS_CHNG,
    input GBT_DSKW_CLK0N,
    input GBT_DSKW_CLK0P,
	   // Internal inputs
	 input RST,
	 input RESYNC,
    input  ICAP_CLK_ENA,
    input DAQ_MMCM_RST,
	   // Internal outputs
    output CMS80,
    output DAQ_TX_125_REFCLK,
    output DAQ_TX_125_REFCLK_DV2,
    output TRG_TX_160_REFCLK,
    output COMP_CLK,
    output COMP_CLK80,
    output COMP_CLK160,
	 output CMP_PHS_CHANGE,
    output TRG_MMCM_LOCK,
    output CLK160,
    output CLK120,
    output CLK40,
    output CLK20,
    output CLK1MHZ,
    output CLK100KHZ,
    output ICAP_CLK,
    output ADC_CLK,
    output DSR_RESYNC,
    output DAQ_MMCM_LOCK,
    output STRTUP_CLK,
	 output GBT_DSKW_CLK,
    output EOS,
	 output [15:0] CMP_PHS_ERRCNT,
	output RESYNC_D1,
	output LEAD_EDG_RESYNC,
	output LEAD_EDG_RESYNC_D1,
	output CAP_PHASE,
	output [7:0] RST_MMCM_PIPE,
	output [10:0] CMP_PHASE,
	output CMP_PHS_PSEN,
	output CMP_PHS_PSDONE,
	output CMP_PHS_BUSY,
	output CMP_PHS_RST,
	output [2:0] CMP_PHS_STATE

    );

     //---------------------Dedicated GTX Reference Clock Inputs ---------------
    // Each dedicated refclk you are using in your design will need its own IBUFDS_GTXE1 instance
    
  wire trg_tx_160_refclk_dv2;
  
  wire cms_clk;
  wire clk100k;
  wire q15;
  
  wire gc0,gc1;
  wire tp_b35_0;
  wire dmy_cclk, dmy_din, dmy_tck, preq;
  
wire samp_ma, samp_mb;
wire samp_m0,samp_m45,samp_m90,samp_m135;
wire sampfbout_med;
wire pre_clk40;
wire pre_clk20, pre_clk20_b;
wire clk20_nophase;
wire clk20_nophase_b;
wire rst_samp_mmcm;
wire samp_in_sel;
wire cmp_phs_inc_i;
wire c20_phase_sel_i;
wire gbt_deskew_clk_0;
  

	assign CLK100KHZ = clk100k;

	assign CMP_PHS_RST = RST || CMP_PHS_JTAG_RST;
  
  assign tp_b35_0 = 1'b0;
  
	IBUFGDS #(.DIFF_TERM("TRUE"),.IOSTANDARD("DEFAULT")) IBUFGDS_CMS_CLK (.O(cms_clk),.I(CMS_CLK_P),.IB(CMS_CLK_N));
	IBUFGDS #(.DIFF_TERM("TRUE"),.IOSTANDARD("DEFAULT")) IBUFGDS_CMS80 (.O(CMS80),.I(CMS80_P),.IB(CMS80_N));
	IBUFDS_GTXE1 q3_clk0_refclk_ibufds_i (.O(DAQ_TX_125_REFCLK),.ODIV2(DAQ_TX_125_REFCLK_DV2),.CEB(1'b0),.I(XO_CLK_AC_P),.IB(XO_CLK_AC_N));
	IBUFDS_GTXE1 q3_clk1_refclk_ibufds_i (.O(TRG_TX_160_REFCLK),.ODIV2(trg_tx_160_refclk_dv2),.CEB(1'b0),.I(QPLL_CLK_AC_P),.IB(QPLL_CLK_AC_N));
	IBUFGDS #(.DIFF_TERM("TRUE"),.IOSTANDARD("DEFAULT")) IBUFGDS_GC0 (.O(gc0),.I(GC0P),.IB(GC0N));
	IBUFGDS #(.DIFF_TERM("TRUE"),.IOSTANDARD("DEFAULT")) IBUFGDS_GC1 (.O(gc1),.I(GC1P),.IB(GC1N));
//	OBUFDS #(.IOSTANDARD("DEFAULT")) OBUFDS_TP_B35_0 (.O(TP_B35_0P),.OB(TP_B35_0N),.I(tp_b35_0));
	IBUFGDS #(.DIFF_TERM("TRUE"),.IOSTANDARD("DEFAULT")) IBUFDS_DSKW_CLK (.O(gbt_deskew_clk_0),.I(GBT_DSKW_CLK0P),.IB(GBT_DSKW_CLK0N));


generate
if(TMR==1) 
begin : Samp_Clk_TMR


	(* syn_preserve = "true" *) reg rst_d1_1;
	(* syn_preserve = "true" *) reg rst_d1_2;
	(* syn_preserve = "true" *) reg rst_d1_3;
	(* syn_preserve = "true" *) reg rst_d2_1;
	(* syn_preserve = "true" *) reg rst_d2_2;
	(* syn_preserve = "true" *) reg rst_d2_3;
	(* syn_preserve = "true" *) reg resync_d1_1;
	(* syn_preserve = "true" *) reg resync_d1_2;
	(* syn_preserve = "true" *) reg resync_d1_3;
	(* syn_preserve = "true" *) reg lead_edg_resync_d1_1;
	(* syn_preserve = "true" *) reg lead_edg_resync_d1_2;
	(* syn_preserve = "true" *) reg lead_edg_resync_d1_3;
	(* syn_preserve = "true" *) reg samp_in_sel_d1_1;
	(* syn_preserve = "true" *) reg samp_in_sel_d1_2;
	(* syn_preserve = "true" *) reg samp_in_sel_d1_3;
	(* syn_preserve = "true" *) reg cap_phase_1;
	(* syn_preserve = "true" *) reg cap_phase_2;
	(* syn_preserve = "true" *) reg cap_phase_3;
	(* syn_preserve = "true" *) reg cap_phase_d1_1;
	(* syn_preserve = "true" *) reg cap_phase_d1_2;
	(* syn_preserve = "true" *) reg cap_phase_d1_3;
	(* syn_preserve = "true" *) reg cap_phase_d2_1;
	(* syn_preserve = "true" *) reg cap_phase_d2_2;
	(* syn_preserve = "true" *) reg cap_phase_d2_3;
	(* syn_preserve = "true" *) reg cap_phase_ena_1;
	(* syn_preserve = "true" *) reg cap_phase_ena_2;
	(* syn_preserve = "true" *) reg cap_phase_ena_3;
	(* syn_preserve = "true" *) reg clk20_phase_1;
	(* syn_preserve = "true" *) reg clk20_phase_2;
	(* syn_preserve = "true" *) reg clk20_phase_3;
	(* syn_preserve = "true" *) reg c20_phase_sel_1;
	(* syn_preserve = "true" *) reg c20_phase_sel_2;
	(* syn_preserve = "true" *) reg c20_phase_sel_3;
	(* syn_preserve = "true" *) reg dsr_ho_1;
	(* syn_preserve = "true" *) reg dsr_ho_2;
	(* syn_preserve = "true" *) reg dsr_ho_3;
	(* syn_preserve = "true" *) reg [7:0] dsr_ho_tmr_1;
	(* syn_preserve = "true" *) reg [7:0] dsr_ho_tmr_2;
	(* syn_preserve = "true" *) reg [7:0] dsr_ho_tmr_3;
	(* syn_preserve = "true" *) reg [7:0] rst_mmcm_pipe_1;
	(* syn_preserve = "true" *) reg [7:0] rst_mmcm_pipe_2;
	(* syn_preserve = "true" *) reg [7:0] rst_mmcm_pipe_3;

	(* syn_keep = "true" *) wire vt_rst_d1_1;
	(* syn_keep = "true" *) wire vt_rst_d1_2;
	(* syn_keep = "true" *) wire vt_rst_d1_3;
	(* syn_keep = "true" *) wire vt_rst_d2_1;
	(* syn_keep = "true" *) wire vt_rst_d2_2;
	(* syn_keep = "true" *) wire vt_rst_d2_3;
	(* syn_keep = "true" *) wire vt_resync_d1_1;
	(* syn_keep = "true" *) wire vt_resync_d1_2;
	(* syn_keep = "true" *) wire vt_resync_d1_3;
	(* syn_keep = "true" *) wire vt_lead_edg_resync_d1_1;
	(* syn_keep = "true" *) wire vt_lead_edg_resync_d1_2;
	(* syn_keep = "true" *) wire vt_lead_edg_resync_d1_3;
	(* syn_keep = "true" *) wire vt_samp_in_sel_d1_1;
	(* syn_keep = "true" *) wire vt_samp_in_sel_d1_2;
	(* syn_keep = "true" *) wire vt_samp_in_sel_d1_3;
	(* syn_keep = "true" *) wire vt_cap_phase_1;
	(* syn_keep = "true" *) wire vt_cap_phase_2;
	(* syn_keep = "true" *) wire vt_cap_phase_3;
	(* syn_keep = "true" *) wire vt_cap_phase_d1_1;
	(* syn_keep = "true" *) wire vt_cap_phase_d1_2;
	(* syn_keep = "true" *) wire vt_cap_phase_d1_3;
	(* syn_keep = "true" *) wire vt_cap_phase_d2_1;
	(* syn_keep = "true" *) wire vt_cap_phase_d2_2;
	(* syn_keep = "true" *) wire vt_cap_phase_d2_3;
	(* syn_keep = "true" *) wire vt_cap_phase_ena_1;
	(* syn_keep = "true" *) wire vt_cap_phase_ena_2;
	(* syn_keep = "true" *) wire vt_cap_phase_ena_3;
	(* syn_keep = "true" *) wire vt_clk20_phase_1;
	(* syn_keep = "true" *) wire vt_clk20_phase_2;
	(* syn_keep = "true" *) wire vt_clk20_phase_3;
	(* syn_keep = "true" *) wire vt_c20_phase_sel_1;
	(* syn_keep = "true" *) wire vt_c20_phase_sel_2;
	(* syn_keep = "true" *) wire vt_c20_phase_sel_3;
	(* syn_keep = "true" *) wire vt_dsr_ho_1;
	(* syn_keep = "true" *) wire vt_dsr_ho_2;
	(* syn_keep = "true" *) wire vt_dsr_ho_3;
	(* syn_keep = "true" *) wire [7:0] vt_dsr_ho_tmr_1;
	(* syn_keep = "true" *) wire [7:0] vt_dsr_ho_tmr_2;
	(* syn_keep = "true" *) wire [7:0] vt_dsr_ho_tmr_3;
	(* syn_keep = "true" *) wire [7:0] vt_rst_mmcm_pipe_1;
	(* syn_keep = "true" *) wire [7:0] vt_rst_mmcm_pipe_2;
	(* syn_keep = "true" *) wire [7:0] vt_rst_mmcm_pipe_3;

	(* syn_keep = "true" *) wire samp_in_sel_chng_1;
	(* syn_keep = "true" *) wire samp_in_sel_chng_2;
	(* syn_keep = "true" *) wire samp_in_sel_chng_3;
	(* syn_keep = "true" *) wire rqst_dsr_rst_1;
	(* syn_keep = "true" *) wire rqst_dsr_rst_2;
	(* syn_keep = "true" *) wire rqst_dsr_rst_3;
	(* syn_keep = "true" *) wire trl_edg_rst_1;
	(* syn_keep = "true" *) wire trl_edg_rst_2;
	(* syn_keep = "true" *) wire trl_edg_rst_3;
	(* syn_keep = "true" *) wire lead_edg_resync_1;
	(* syn_keep = "true" *) wire lead_edg_resync_2;
	(* syn_keep = "true" *) wire lead_edg_resync_3;
	(* syn_keep = "true" *) wire rst_mmcm_pipe_in_1;
	(* syn_keep = "true" *) wire rst_mmcm_pipe_in_2;
	(* syn_keep = "true" *) wire rst_mmcm_pipe_in_3;
	(* syn_keep = "true" *) wire rst_samp_mmcm_1;
	(* syn_keep = "true" *) wire rst_samp_mmcm_2;
	(* syn_keep = "true" *) wire rst_samp_mmcm_3;
	(* syn_keep = "true" *) wire clr_dsr_ho_1;
	(* syn_keep = "true" *) wire clr_dsr_ho_2;
	(* syn_keep = "true" *) wire clr_dsr_ho_3;
	(* syn_keep = "true" *) wire samp_in_sel_1;
	(* syn_keep = "true" *) wire samp_in_sel_2;
	(* syn_keep = "true" *) wire samp_in_sel_3;

	assign vt_rst_d1_1        = (rst_d1_1        & rst_d1_2       ) | (rst_d1_2        & rst_d1_3       ) | (rst_d1_1        & rst_d1_3       ); // Majority logic
	assign vt_rst_d1_2        = (rst_d1_1        & rst_d1_2       ) | (rst_d1_2        & rst_d1_3       ) | (rst_d1_1        & rst_d1_3       ); // Majority logic
	assign vt_rst_d1_3        = (rst_d1_1        & rst_d1_2       ) | (rst_d1_2        & rst_d1_3       ) | (rst_d1_1        & rst_d1_3       ); // Majority logic
	assign vt_rst_d2_1        = (rst_d2_1        & rst_d2_2       ) | (rst_d2_2        & rst_d2_3       ) | (rst_d2_1        & rst_d2_3       ); // Majority logic
	assign vt_rst_d2_2        = (rst_d2_1        & rst_d2_2       ) | (rst_d2_2        & rst_d2_3       ) | (rst_d2_1        & rst_d2_3       ); // Majority logic
	assign vt_rst_d2_3        = (rst_d2_1        & rst_d2_2       ) | (rst_d2_2        & rst_d2_3       ) | (rst_d2_1        & rst_d2_3       ); // Majority logic
	assign vt_resync_d1_1     = (resync_d1_1     & resync_d1_2    ) | (resync_d1_2     & resync_d1_3    ) | (resync_d1_1     & resync_d1_3    ); // Majority logic
	assign vt_resync_d1_2     = (resync_d1_1     & resync_d1_2    ) | (resync_d1_2     & resync_d1_3    ) | (resync_d1_1     & resync_d1_3    ); // Majority logic
	assign vt_resync_d1_3     = (resync_d1_1     & resync_d1_2    ) | (resync_d1_2     & resync_d1_3    ) | (resync_d1_1     & resync_d1_3    ); // Majority logic
	assign vt_lead_edg_resync_d1_1 = (lead_edg_resync_d1_1 & lead_edg_resync_d1_2) | (lead_edg_resync_d1_2 & lead_edg_resync_d1_3) | (lead_edg_resync_d1_1 & lead_edg_resync_d1_3); // Majority logic
	assign vt_lead_edg_resync_d1_2 = (lead_edg_resync_d1_1 & lead_edg_resync_d1_2) | (lead_edg_resync_d1_2 & lead_edg_resync_d1_3) | (lead_edg_resync_d1_1 & lead_edg_resync_d1_3); // Majority logic
	assign vt_lead_edg_resync_d1_3 = (lead_edg_resync_d1_1 & lead_edg_resync_d1_2) | (lead_edg_resync_d1_2 & lead_edg_resync_d1_3) | (lead_edg_resync_d1_1 & lead_edg_resync_d1_3); // Majority logic
	assign vt_samp_in_sel_d1_1     = (samp_in_sel_d1_1     & samp_in_sel_d1_2)     | (samp_in_sel_d1_2     & samp_in_sel_d1_3)     | (samp_in_sel_d1_1     & samp_in_sel_d1_3);     // Majority logic
	assign vt_samp_in_sel_d1_2     = (samp_in_sel_d1_1     & samp_in_sel_d1_2)     | (samp_in_sel_d1_2     & samp_in_sel_d1_3)     | (samp_in_sel_d1_1     & samp_in_sel_d1_3);     // Majority logic
	assign vt_samp_in_sel_d1_3     = (samp_in_sel_d1_1     & samp_in_sel_d1_2)     | (samp_in_sel_d1_2     & samp_in_sel_d1_3)     | (samp_in_sel_d1_1     & samp_in_sel_d1_3);     // Majority logic
	assign vt_cap_phase_1     = (cap_phase_1     & cap_phase_2    ) | (cap_phase_2     & cap_phase_3    ) | (cap_phase_1     & cap_phase_3    ); // Majority logic
	assign vt_cap_phase_2     = (cap_phase_1     & cap_phase_2    ) | (cap_phase_2     & cap_phase_3    ) | (cap_phase_1     & cap_phase_3    ); // Majority logic
	assign vt_cap_phase_3     = (cap_phase_1     & cap_phase_2    ) | (cap_phase_2     & cap_phase_3    ) | (cap_phase_1     & cap_phase_3    ); // Majority logic
	assign vt_cap_phase_d1_1  = (cap_phase_d1_1  & cap_phase_d1_2 ) | (cap_phase_d1_2  & cap_phase_d1_3 ) | (cap_phase_d1_1  & cap_phase_d1_3 ); // Majority logic
	assign vt_cap_phase_d1_2  = (cap_phase_d1_1  & cap_phase_d1_2 ) | (cap_phase_d1_2  & cap_phase_d1_3 ) | (cap_phase_d1_1  & cap_phase_d1_3 ); // Majority logic
	assign vt_cap_phase_d1_3  = (cap_phase_d1_1  & cap_phase_d1_2 ) | (cap_phase_d1_2  & cap_phase_d1_3 ) | (cap_phase_d1_1  & cap_phase_d1_3 ); // Majority logic
	assign vt_cap_phase_d2_1  = (cap_phase_d2_1  & cap_phase_d2_2 ) | (cap_phase_d2_2  & cap_phase_d2_3 ) | (cap_phase_d2_1  & cap_phase_d2_3 ); // Majority logic
	assign vt_cap_phase_d2_2  = (cap_phase_d2_1  & cap_phase_d2_2 ) | (cap_phase_d2_2  & cap_phase_d2_3 ) | (cap_phase_d2_1  & cap_phase_d2_3 ); // Majority logic
	assign vt_cap_phase_d2_3  = (cap_phase_d2_1  & cap_phase_d2_2 ) | (cap_phase_d2_2  & cap_phase_d2_3 ) | (cap_phase_d2_1  & cap_phase_d2_3 ); // Majority logic
	assign vt_cap_phase_ena_1 = (cap_phase_ena_1 & cap_phase_ena_2) | (cap_phase_ena_2 & cap_phase_ena_3) | (cap_phase_ena_1 & cap_phase_ena_3); // Majority logic
	assign vt_cap_phase_ena_2 = (cap_phase_ena_1 & cap_phase_ena_2) | (cap_phase_ena_2 & cap_phase_ena_3) | (cap_phase_ena_1 & cap_phase_ena_3); // Majority logic
	assign vt_cap_phase_ena_3 = (cap_phase_ena_1 & cap_phase_ena_2) | (cap_phase_ena_2 & cap_phase_ena_3) | (cap_phase_ena_1 & cap_phase_ena_3); // Majority logic
	assign vt_clk20_phase_1   = (clk20_phase_1   & clk20_phase_2  ) | (clk20_phase_2   & clk20_phase_3  ) | (clk20_phase_1   & clk20_phase_3  ); // Majority logic
	assign vt_clk20_phase_2   = (clk20_phase_1   & clk20_phase_2  ) | (clk20_phase_2   & clk20_phase_3  ) | (clk20_phase_1   & clk20_phase_3  ); // Majority logic
	assign vt_clk20_phase_3   = (clk20_phase_1   & clk20_phase_2  ) | (clk20_phase_2   & clk20_phase_3  ) | (clk20_phase_1   & clk20_phase_3  ); // Majority logic
	assign vt_c20_phase_sel_1 = (c20_phase_sel_1 & c20_phase_sel_2) | (c20_phase_sel_2 & c20_phase_sel_3) | (c20_phase_sel_1 & c20_phase_sel_3); // Majority logic
	assign vt_c20_phase_sel_2 = (c20_phase_sel_1 & c20_phase_sel_2) | (c20_phase_sel_2 & c20_phase_sel_3) | (c20_phase_sel_1 & c20_phase_sel_3); // Majority logic
	assign vt_c20_phase_sel_3 = (c20_phase_sel_1 & c20_phase_sel_2) | (c20_phase_sel_2 & c20_phase_sel_3) | (c20_phase_sel_1 & c20_phase_sel_3); // Majority logic
	assign vt_dsr_ho_1        = (dsr_ho_1        & dsr_ho_2       ) | (dsr_ho_2        & dsr_ho_3       ) | (dsr_ho_1        & dsr_ho_3       ); // Majority logic
	assign vt_dsr_ho_2        = (dsr_ho_1        & dsr_ho_2       ) | (dsr_ho_2        & dsr_ho_3       ) | (dsr_ho_1        & dsr_ho_3       ); // Majority logic
	assign vt_dsr_ho_3        = (dsr_ho_1        & dsr_ho_2       ) | (dsr_ho_2        & dsr_ho_3       ) | (dsr_ho_1        & dsr_ho_3       ); // Majority logic
	assign vt_dsr_ho_tmr_1    = (dsr_ho_tmr_1    & dsr_ho_tmr_2   ) | (dsr_ho_tmr_2    & dsr_ho_tmr_3   ) | (dsr_ho_tmr_1    & dsr_ho_tmr_3   ); // Majority logic
	assign vt_dsr_ho_tmr_2    = (dsr_ho_tmr_1    & dsr_ho_tmr_2   ) | (dsr_ho_tmr_2    & dsr_ho_tmr_3   ) | (dsr_ho_tmr_1    & dsr_ho_tmr_3   ); // Majority logic
	assign vt_dsr_ho_tmr_3    = (dsr_ho_tmr_1    & dsr_ho_tmr_2   ) | (dsr_ho_tmr_2    & dsr_ho_tmr_3   ) | (dsr_ho_tmr_1    & dsr_ho_tmr_3   ); // Majority logic
	assign vt_rst_mmcm_pipe_1 = (rst_mmcm_pipe_1 & rst_mmcm_pipe_2) | (rst_mmcm_pipe_2 & rst_mmcm_pipe_3) | (rst_mmcm_pipe_1 & rst_mmcm_pipe_3); // Majority logic
	assign vt_rst_mmcm_pipe_2 = (rst_mmcm_pipe_1 & rst_mmcm_pipe_2) | (rst_mmcm_pipe_2 & rst_mmcm_pipe_3) | (rst_mmcm_pipe_1 & rst_mmcm_pipe_3); // Majority logic
	assign vt_rst_mmcm_pipe_3 = (rst_mmcm_pipe_1 & rst_mmcm_pipe_2) | (rst_mmcm_pipe_2 & rst_mmcm_pipe_3) | (rst_mmcm_pipe_1 & rst_mmcm_pipe_3); // Majority logic

	always @(posedge CLK40)
	begin
		rst_d1_1 <= RST;
		rst_d1_2 <= RST;
		rst_d1_3 <= RST;
		rst_d2_1 <= vt_rst_d1_1;
		rst_d2_2 <= vt_rst_d1_2;
		rst_d2_3 <= vt_rst_d1_3;
		resync_d1_1 <= RESYNC;
		resync_d1_2 <= RESYNC;
		resync_d1_3 <= RESYNC;
		lead_edg_resync_d1_1 <= lead_edg_resync_1;
		lead_edg_resync_d1_2 <= lead_edg_resync_2;
		lead_edg_resync_d1_3 <= lead_edg_resync_3;
		samp_in_sel_d1_1 <= samp_in_sel_1;
		samp_in_sel_d1_2 <= samp_in_sel_2;
		samp_in_sel_d1_3 <= samp_in_sel_3;
		cap_phase_1 <= (lead_edg_resync_1 | vt_lead_edg_resync_d1_1) & vt_cap_phase_ena_1;
		cap_phase_2 <= (lead_edg_resync_2 | vt_lead_edg_resync_d1_2) & vt_cap_phase_ena_2;
		cap_phase_3 <= (lead_edg_resync_3 | vt_lead_edg_resync_d1_3) & vt_cap_phase_ena_3;
		cap_phase_d1_1 <= vt_cap_phase_1;
		cap_phase_d1_2 <= vt_cap_phase_2;
		cap_phase_d1_3 <= vt_cap_phase_3;
		cap_phase_d2_1 <= vt_cap_phase_d1_1;
		cap_phase_d2_2 <= vt_cap_phase_d1_2;
		cap_phase_d2_3 <= vt_cap_phase_d1_3;
		rst_mmcm_pipe_1 <= {vt_rst_mmcm_pipe_1[6:0],rst_mmcm_pipe_in_1};
		rst_mmcm_pipe_2 <= {vt_rst_mmcm_pipe_2[6:0],rst_mmcm_pipe_in_2};
		rst_mmcm_pipe_3 <= {vt_rst_mmcm_pipe_3[6:0],rst_mmcm_pipe_in_3};
	end

	always @(posedge CLK40 or posedge RST)
	begin
		if(RST) begin
			cap_phase_ena_1 <= 1'b0;
			cap_phase_ena_2 <= 1'b0;
			cap_phase_ena_3 <= 1'b0;
		end
		else begin
			cap_phase_ena_1 <= vt_cap_phase_d2_1 ? 1'b0 : vt_cap_phase_ena_1;
			cap_phase_ena_2 <= vt_cap_phase_d2_2 ? 1'b0 : vt_cap_phase_ena_2;
			cap_phase_ena_3 <= vt_cap_phase_d2_3 ? 1'b0 : vt_cap_phase_ena_3;
		end
	end

	always @(posedge CLK40 or posedge RST)
	begin
		if(RST) begin
			clk20_phase_1 <= 1'b0;
			clk20_phase_2 <= 1'b0;
			clk20_phase_3 <= 1'b0;
		end
		else begin
			clk20_phase_1 <= lead_edg_resync_1 ? 1'b0 : ~vt_clk20_phase_1;
			clk20_phase_2 <= lead_edg_resync_2 ? 1'b0 : ~vt_clk20_phase_2;
			clk20_phase_3 <= lead_edg_resync_3 ? 1'b0 : ~vt_clk20_phase_3;
		end
	end

	always @(posedge clk20_nophase or posedge RST)
	begin
		if(RST) begin
			c20_phase_sel_1 <= 1'b0;
			c20_phase_sel_2 <= 1'b0;
			c20_phase_sel_3 <= 1'b0;
		end
		else begin
			c20_phase_sel_1 <= vt_cap_phase_1 ? vt_clk20_phase_1 : vt_c20_phase_sel_1;
			c20_phase_sel_2 <= vt_cap_phase_2 ? vt_clk20_phase_2 : vt_c20_phase_sel_2;
			c20_phase_sel_3 <= vt_cap_phase_3 ? vt_clk20_phase_3 : vt_c20_phase_sel_3;
		end
	end
			
	always @(posedge CLK40 or posedge RST)
	begin
		if(RST) begin
			dsr_ho_1 <= 1'b0;
			dsr_ho_2 <= 1'b0;
			dsr_ho_3 <= 1'b0;
		end
		else begin
			dsr_ho_1 <= rqst_dsr_rst_1 ? 1'b1 :(clr_dsr_ho_1 ? 1'b0 : vt_dsr_ho_1);
			dsr_ho_2 <= rqst_dsr_rst_2 ? 1'b1 :(clr_dsr_ho_2 ? 1'b0 : vt_dsr_ho_2);
			dsr_ho_3 <= rqst_dsr_rst_3 ? 1'b1 :(clr_dsr_ho_3 ? 1'b0 : vt_dsr_ho_3);
		end
	end
	always @(posedge CLK1MHZ or posedge RST)
	begin
		if(RST) begin
			dsr_ho_tmr_1 <= 8'h00;
			dsr_ho_tmr_2 <= 8'h00;
			dsr_ho_tmr_3 <= 8'h00;
		end
		else begin
			dsr_ho_tmr_1 <= vt_dsr_ho_1 ? vt_dsr_ho_tmr_1 + 1 : 8'h00;
			dsr_ho_tmr_2 <= vt_dsr_ho_2 ? vt_dsr_ho_tmr_2 + 1 : 8'h00;
			dsr_ho_tmr_3 <= vt_dsr_ho_3 ? vt_dsr_ho_tmr_3 + 1 : 8'h00;
		end
	end
	
	assign trl_edg_rst_1 = (~RST & vt_rst_d2_1); //two clocks wide
	assign trl_edg_rst_2 = (~RST & vt_rst_d2_2); //two clocks wide
	assign trl_edg_rst_3 = (~RST & vt_rst_d2_3); //two clocks wide
	assign lead_edg_resync_1 = RESYNC & ~vt_resync_d1_1 ; //one clocks wide
	assign lead_edg_resync_2 = RESYNC & ~vt_resync_d1_2 ; //one clocks wide
	assign lead_edg_resync_3 = RESYNC & ~vt_resync_d1_3 ; //one clocks wide
	assign rst_mmcm_pipe_in_1 = samp_in_sel_chng_1 | trl_edg_rst_1;
	assign rst_mmcm_pipe_in_2 = samp_in_sel_chng_2 | trl_edg_rst_2;
	assign rst_mmcm_pipe_in_3 = samp_in_sel_chng_3 | trl_edg_rst_3;
	assign rst_samp_mmcm_1 = |vt_rst_mmcm_pipe_1;
	assign rst_samp_mmcm_2 = |vt_rst_mmcm_pipe_2;
	assign rst_samp_mmcm_3 = |vt_rst_mmcm_pipe_3;
	assign clr_dsr_ho_1 = (vt_dsr_ho_tmr_1 == 8'd100); //100uS
	assign clr_dsr_ho_2 = (vt_dsr_ho_tmr_2 == 8'd100); //100uS
	assign clr_dsr_ho_3 = (vt_dsr_ho_tmr_3 == 8'd100); //100uS
	assign samp_in_sel_1 = SAMP_CLK_PHASE[2] ^ vt_c20_phase_sel_1;
	assign samp_in_sel_2 = SAMP_CLK_PHASE[2] ^ vt_c20_phase_sel_2;
	assign samp_in_sel_3 = SAMP_CLK_PHASE[2] ^ vt_c20_phase_sel_3;
	assign samp_in_sel_chng_1 = (samp_in_sel_1 & !vt_samp_in_sel_d1_1) | (!samp_in_sel_1 & vt_samp_in_sel_d1_1); // signals a change in samp_in_sel one clock long 
	assign samp_in_sel_chng_2 = (samp_in_sel_2 & !vt_samp_in_sel_d1_2) | (!samp_in_sel_2 & vt_samp_in_sel_d1_2); // signals a change in samp_in_sel one clock long 
	assign samp_in_sel_chng_3 = (samp_in_sel_3 & !vt_samp_in_sel_d1_3) | (!samp_in_sel_3 & vt_samp_in_sel_d1_3); // signals a change in samp_in_sel one clock long 
	assign rqst_dsr_rst_1 = rst_mmcm_pipe_in_1 | SAMP_CLK_PHS_CHNG;
	assign rqst_dsr_rst_2 = rst_mmcm_pipe_in_2 | SAMP_CLK_PHS_CHNG;
	assign rqst_dsr_rst_3 = rst_mmcm_pipe_in_3 | SAMP_CLK_PHS_CHNG;

	assign RESYNC_D1          = vt_resync_d1_1;
	assign LEAD_EDG_RESYNC_D1 = vt_lead_edg_resync_d1_1;
	assign CAP_PHASE          = vt_cap_phase_1;
	assign RST_MMCM_PIPE      = vt_rst_mmcm_pipe_1;
	assign DSR_RESYNC         = vt_dsr_ho_1;

	assign c20_phase_sel_i = vt_c20_phase_sel_1;
	
	assign LEAD_EDG_RESYNC  = (lead_edg_resync_1  & lead_edg_resync_2 ) | (lead_edg_resync_2  & lead_edg_resync_3 ) | (lead_edg_resync_1  & lead_edg_resync_3 ); // Majority logic
	assign rst_samp_mmcm    = (rst_samp_mmcm_1    & rst_samp_mmcm_2   ) | (rst_samp_mmcm_2    & rst_samp_mmcm_3   ) | (rst_samp_mmcm_1    & rst_samp_mmcm_3   ); // Majority logic
	assign samp_in_sel      = (samp_in_sel_1      & samp_in_sel_2     ) | (samp_in_sel_2      & samp_in_sel_3     ) | (samp_in_sel_1      & samp_in_sel_3     ); // Majority logic

end
else 
begin : Samp_Clk_No_TMR

	reg rst_d1;
	reg rst_d2;
	reg resync_d1;
	reg lead_edg_resync_d1;
	reg samp_in_sel_d1;
	reg cap_phase;
	reg cap_phase_d1;
	reg cap_phase_d2;
	reg cap_phase_ena;
	reg clk20_phase;
	reg c20_phase_sel;
	reg dsr_ho;
	reg [7:0] dsr_ho_tmr;
	reg [7:0] rst_mmcm_pipe;
	
	wire samp_in_sel_chng;
	wire rqst_dsr_rst;
	wire trl_edg_rst;
	wire rst_mmcm_pipe_in;
	wire clr_dsr_ho;

	always @(posedge CLK40)
	begin
		rst_d1 <= RST;
		rst_d2 <= rst_d1;
		resync_d1 <= RESYNC;
		lead_edg_resync_d1 <= LEAD_EDG_RESYNC;
		samp_in_sel_d1 <= samp_in_sel;
//		cap_phase <= LEAD_EDG_RESYNC | lead_edg_resync_d1  | trl_edg_rst | SAMP_CLK_PHS_CHNG;
		cap_phase <= (LEAD_EDG_RESYNC | lead_edg_resync_d1) & cap_phase_ena;
		cap_phase_d1 <= cap_phase;
		cap_phase_d2 <= cap_phase_d1;
		rst_mmcm_pipe <= {rst_mmcm_pipe[6:0],rst_mmcm_pipe_in};
	end

	always @(posedge CLK40 or posedge RST)
	begin
		if(RST)
			cap_phase_ena <= 1'b1;
		else
			if(cap_phase_d2)
				cap_phase_ena <= 1'b0;
	end

	always @(posedge CLK40 or posedge RST)
	begin
		if(RST)
			clk20_phase <= 1'b0;
		else
			if(LEAD_EDG_RESYNC)
				clk20_phase <= 1'b0;
			else
				clk20_phase <= ~clk20_phase;	
	end

	always @(posedge clk20_nophase or posedge RST)
	begin
		if(RST)
			c20_phase_sel <= 1'b0;
		else
			if(cap_phase)
				c20_phase_sel <= clk20_phase;
			else
				c20_phase_sel <= c20_phase_sel;
	end
			
	always @(posedge CLK40 or posedge RST)
	begin
		if(RST)
			dsr_ho <= 1'b0;
		else
			if(rqst_dsr_rst)
				dsr_ho <= 1'b1;
			else if(clr_dsr_ho)
				dsr_ho <= 1'b0;
			else
				dsr_ho <= dsr_ho;	
	end
	always @(posedge CLK1MHZ or posedge RST)
	begin
		if(RST)
			dsr_ho_tmr <= 8'h00;
		else
			if(dsr_ho)
				dsr_ho_tmr <= dsr_ho_tmr+1;
			else
				dsr_ho_tmr <= 8'h00;	
	end
	assign RESYNC_D1          = resync_d1;
	assign LEAD_EDG_RESYNC_D1 = lead_edg_resync_d1;
	assign CAP_PHASE          = cap_phase;
	assign RST_MMCM_PIPE      = rst_mmcm_pipe;
	assign DSR_RESYNC = dsr_ho;
	assign trl_edg_rst = (~RST & rst_d2); //two clocks wide
	assign LEAD_EDG_RESYNC = RESYNC & ~resync_d1 ; //one clocks wide
//	assign rst_mmcm_pipe_in = LEAD_EDG_RESYNC | trl_edg_rst | cap_phase | SAMP_CLK_PHS_CHNG;
	assign rst_mmcm_pipe_in = samp_in_sel_chng | trl_edg_rst;
	assign rst_samp_mmcm = |rst_mmcm_pipe;
	assign clr_dsr_ho = (dsr_ho_tmr == 8'd100); //100uS
	assign samp_in_sel = SAMP_CLK_PHASE[2] ^ c20_phase_sel;
	assign samp_in_sel_chng = (samp_in_sel & !samp_in_sel_d1) | (!samp_in_sel & samp_in_sel_d1); // signals a change in samp_in_sel one clock long 
	assign rqst_dsr_rst = rst_mmcm_pipe_in | SAMP_CLK_PHS_CHNG;
	assign c20_phase_sel_i = c20_phase_sel;

end
endgenerate

// daq_mmcm_custom
//----------------------------------------------------------------------------
// Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
// Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// CLK_OUT1    40.000      0.000      50.0      247.096    196.976
// CLK_OUT2   160.000      0.000      50.0      169.112    196.976
// CLK_OUT3   120.000      0.000      50.0      180.794    196.976
// CLK_OUT4    20.000      0.000      50.0      298.160    196.976
// CLK_OUT5     1.000      0.000      50.0      357.000    196.976
//
//----------------------------------------------------------------------------
// Input Clock   Input Freq (MHz)   Input Jitter (UI)
//----------------------------------------------------------------------------
// primary          40.000            0.010

daq_mmcm_custom daq_mmc1(.CLK_IN1(cms_clk),
	.CLK_OUT1_RAW(pre_clk40),
	.CLK_OUT2(CLK160),
	.CLK_OUT3(CLK120),
	.CLK_OUT4_RAW(pre_clk20),.CLK_OUT4_B_RAW(pre_clk20_b),
	.CLK_OUT5(CLK1MHZ),
	.RESET(DAQ_MMCM_RST),
	.LOCKED(DAQ_MMCM_LOCK));

  BUFG clk40_buf (
	.O   (CLK40),
	.I   (pre_clk40)
	);
	 
  BUFGCE icap_clk_bufg (
    .I(pre_clk40),
	 .CE(ICAP_CLK_ENA),
    .O(ICAP_CLK)
    );

   BUFH	clk20_nophase_i (.O(clk20_nophase),  .I(pre_clk20));
   BUFH	clk20_nophase_b_i (.O(clk20_nophase_b),  .I(pre_clk20_b));

   BUFGMUX 
   BUFGMUX_clk20_phase (
      .O(CLK20),
      .I0(pre_clk20),
      .I1(pre_clk20_b),
      .S(c20_phase_sel_i)
   );


//clkadj_med
// 6.25ns shifts in phase with a -2ns offset
// also with output jitter minimized
//
//----------------------------------------------------------------------------
// Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
// Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// CLK_OUT1    20.000    345.000      50.0      263.808    309.209
// CLK_OUT2    20.000     30.000      50.0      263.808    309.209
// CLK_OUT3    20.000     75.000      50.0      263.808    309.209
// CLK_OUT4    20.000    120.000      50.0      263.808    309.209
//
//----------------------------------------------------------------------------
// Input Clock   Input Freq (MHz)   Input Jitter (UI)
//----------------------------------------------------------------------------
// primary          20.000            0.010
// secondary        20.000            0.010


 clkadj_med samp_clk_med_i(
	.CLK_IN1(clk20_nophase), .CLK_IN2(clk20_nophase_b), .CLK_IN_SEL(~samp_in_sel), .CLKFB_IN(sampfbout_med),
	.CLK_OUT1(samp_m0), .CLK_OUT2(samp_m45), .CLK_OUT3(samp_m90), .CLK_OUT4(samp_m135),
	.CLKFB_OUT(sampfbout_med),
	.RESET(rst_samp_mmcm));
	
	
   BUFGMUX 
   BUFGMUX_samp_ma (
      .O(samp_ma),
      .I0(samp_m0),
      .I1(samp_m45),
      .S(SAMP_CLK_PHASE[0])
   );
   BUFGMUX 
   BUFGMUX_samp_mb (
      .O(samp_mb),
      .I0(samp_m90),
      .I1(samp_m135),
      .S(SAMP_CLK_PHASE[0])
   );
   BUFGMUX 
   BUFGMUX_samp_mc (
      .O(ADC_CLK),
      .I0(samp_ma),
      .I1(samp_mb),
      .S(SAMP_CLK_PHASE[1])
   );
  

//
// configuration clock for Power On state machines
//  
generate
if(Simulation == 1)
begin : SimStartupCode
	reg sim_eos;
	assign STRTUP_CLK = cms_clk;
	assign EOS = sim_eos;
	initial begin
		sim_eos = 1'b0;
		#100
		sim_eos = 1'b1;
	end
end
else
begin : StartupCode

  wire raw_startup_clk;

   STARTUP_VIRTEX6 #(
      .PROG_USR("FALSE")  // Activate program event security feature
   )
   strt_up_v6 (
      .CFGCLK(dmy_cclk),       // 1-bit output Configuration main clock output
      .CFGMCLK(raw_startup_clk),     // 1-bit output Configuration internal oscillator clock output
      .DINSPI(dmy_din),       // 1-bit output DIN SPI PROM access output
      .EOS(EOS),             // 1-bit output Active high output signal indicating the End Of Configuration.
      .PREQ(preq),           // 1-bit output PROGRAM request to fabric output
      .TCKSPI(dmy_tck),       // 1-bit output TCK configuration pin access output
      .CLK(1'b0),             // 1-bit input User start-up clock input
      .GSR(1'b0),             // 1-bit input Global Set/Reset input (GSR cannot be used for the port name)
      .GTS(1'b0),             // 1-bit input Global 3-state input (GTS cannot be used for the port name)
      .KEYCLEARB(1'b0), // 1-bit input Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
      .PACK(1'b0),           // 1-bit input PROGRAM acknowledge input
      .USRCCLKO(CLK40),   // 1-bit input User CCLK input
      .USRCCLKTS(1'b1), // 1-bit input User CCLK 3-state enable input
      .USRDONEO(1'b1),   // 1-bit input User DONE pin output control
      .USRDONETS(1'b0)  // 1-bit input User DONE 3-state enable output
   );

  BUFG startup_clk_buf (
	.O   (STRTUP_CLK),
	.I   (raw_startup_clk)
	);
end
endgenerate
	 

//----------------------------------------------------------------------------
// "Output    Output      Phase     Duty      Pk-to-Pk        Phase"
// "Clock    Freq (MHz) (degrees) Cycle (%) Jitter (ps)  Error (ps)"
//----------------------------------------------------------------------------
// CLK_OUT1____40.000______0.000______50.0______247.096____196.976
// CLK_OUT2____80.000______0.000______50.0______200.412____196.976
// CLK_OUT3___160.000______0.000______50.0______169.112____196.976
//
//----------------------------------------------------------------------------
// "Input Clock   Freq (MHz)    Input Jitter (UI)"
//----------------------------------------------------------------------------
// __primary__________40.000____________0.010


  cmp_dyn_phs_mmcm cmp_dyn_phs_mmcm_i
   (// Clock in ports
    .CLK_IN1(cms_clk),      // IN
    // Clock out ports
    .CLK_OUT1(COMP_CLK),.CLK_OUT2(COMP_CLK80),.CLK_OUT3(COMP_CLK160),
    // Dynamic phase shift ports
    .PSCLK(CLK40),// IN
    .PSEN(CMP_PHS_PSEN), // IN
    .PSINCDEC(cmp_phs_inc_i),     // IN
    .PSDONE(CMP_PHS_PSDONE),       // OUT
    // Status and control signals
    .RESET(CMP_PHS_RST),// IN
    .LOCKED(TRG_MMCM_LOCK));      // OUT
	
	
//------------------------------------------------------------------------------------------------------------------
// Create look lookup table for phase steps for comparator clock phase
// Translate 32 steps per cycle into 1344 steps per cycle  (resolution is 1/56th of VCO period which is 1/(24X40MHz)
// Steps in 25ns = 25ns X 56X24X40MHz = 1344
//------------------------------------------------------------------------------------------------------------------
	
//	integer iadr;
//
//	always @* begin	
//		for (iadr=0; iadr<32; iadr=iadr+1) begin
//			cmp_rom[iadr] = $rtoi((iadr*1344.0/31.0)+0.5);
//			$display ("adr=%d  data=%d",iadr,cmp_rom[iadr]);
//		end
//	end

generate
if(TMR==1) 
begin : Comp_Phase_FSM_TMR
// signals for comparator clock managment
  (* syn_preserve = "true" *) reg [10:0] cmp_rom_1 [31:0];	
  (* syn_preserve = "true" *) reg [10:0] cmp_rom_2 [31:0];	
  (* syn_preserve = "true" *) reg [10:0] cmp_rom_3 [31:0];	
  (* syn_preserve = "true" *) reg [10:0] cur_cmp_phase_1;
  (* syn_preserve = "true" *) reg [10:0] cur_cmp_phase_2;
  (* syn_preserve = "true" *) reg [10:0] cur_cmp_phase_3;
  (* syn_preserve = "true" *) reg [10:0] cmp_phase_1;
  (* syn_preserve = "true" *) reg [10:0] cmp_phase_2;
  (* syn_preserve = "true" *) reg [10:0] cmp_phase_3;
  (* syn_preserve = "true" *) reg cmp_phs_chg_m1_1;
  (* syn_preserve = "true" *) reg cmp_phs_chg_m1_2;
  (* syn_preserve = "true" *) reg cmp_phs_chg_m1_3;
  (* syn_preserve = "true" *) reg cmp_phs_change_1;
  (* syn_preserve = "true" *) reg cmp_phs_change_2;
  (* syn_preserve = "true" *) reg cmp_phs_change_3;
  (* syn_preserve = "true" *) reg cmp_phs_inc_1;
  (* syn_preserve = "true" *) reg cmp_phs_inc_2;
  (* syn_preserve = "true" *) reg cmp_phs_inc_3;

  (* syn_keep = "true" *) wire [10:0] vt_cmp_rom_1;
  (* syn_keep = "true" *) wire [10:0] vt_cmp_rom_2;
  (* syn_keep = "true" *) wire [10:0] vt_cmp_rom_3;
  (* syn_keep = "true" *) wire [10:0] vt_cur_cmp_phase_1;
  (* syn_keep = "true" *) wire [10:0] vt_cur_cmp_phase_2;
  (* syn_keep = "true" *) wire [10:0] vt_cur_cmp_phase_3;
  (* syn_keep = "true" *) wire [10:0] vt_cmp_phase_1;
  (* syn_keep = "true" *) wire [10:0] vt_cmp_phase_2;
  (* syn_keep = "true" *) wire [10:0] vt_cmp_phase_3;
  (* syn_keep = "true" *) wire vt_cmp_phs_chg_m1_1;
  (* syn_keep = "true" *) wire vt_cmp_phs_chg_m1_2;
  (* syn_keep = "true" *) wire vt_cmp_phs_chg_m1_3;
  (* syn_keep = "true" *) wire vt_cmp_phs_change_1;
  (* syn_keep = "true" *) wire vt_cmp_phs_inc_1;
  (* syn_keep = "true" *) wire vt_cmp_phs_inc_2;
  (* syn_keep = "true" *) wire vt_cmp_phs_inc_3;
	
  assign vt_cmp_rom_1        = (cmp_rom_1[CMP_CLK_PHASE] & cmp_rom_2[CMP_CLK_PHASE]) | (cmp_rom_2[CMP_CLK_PHASE] & cmp_rom_3[CMP_CLK_PHASE]) | (cmp_rom_1[CMP_CLK_PHASE] & cmp_rom_3[CMP_CLK_PHASE]); // Majority logic
  assign vt_cmp_rom_2        = (cmp_rom_1[CMP_CLK_PHASE] & cmp_rom_2[CMP_CLK_PHASE]) | (cmp_rom_2[CMP_CLK_PHASE] & cmp_rom_3[CMP_CLK_PHASE]) | (cmp_rom_1[CMP_CLK_PHASE] & cmp_rom_3[CMP_CLK_PHASE]); // Majority logic
  assign vt_cmp_rom_3        = (cmp_rom_1[CMP_CLK_PHASE] & cmp_rom_2[CMP_CLK_PHASE]) | (cmp_rom_2[CMP_CLK_PHASE] & cmp_rom_3[CMP_CLK_PHASE]) | (cmp_rom_1[CMP_CLK_PHASE] & cmp_rom_3[CMP_CLK_PHASE]); // Majority logic
  assign vt_cur_cmp_phase_1  = (cur_cmp_phase_1  & cur_cmp_phase_2 ) | (cur_cmp_phase_2  & cur_cmp_phase_3 ) | (cur_cmp_phase_1  & cur_cmp_phase_3 ); // Majority logic
  assign vt_cur_cmp_phase_2  = (cur_cmp_phase_1  & cur_cmp_phase_2 ) | (cur_cmp_phase_2  & cur_cmp_phase_3 ) | (cur_cmp_phase_1  & cur_cmp_phase_3 ); // Majority logic
  assign vt_cur_cmp_phase_3  = (cur_cmp_phase_1  & cur_cmp_phase_2 ) | (cur_cmp_phase_2  & cur_cmp_phase_3 ) | (cur_cmp_phase_1  & cur_cmp_phase_3 ); // Majority logic
  assign vt_cmp_phase_1      = (cmp_phase_1      & cmp_phase_2     ) | (cmp_phase_2      & cmp_phase_3     ) | (cmp_phase_1      & cmp_phase_3     ); // Majority logic
  assign vt_cmp_phase_2      = (cmp_phase_1      & cmp_phase_2     ) | (cmp_phase_2      & cmp_phase_3     ) | (cmp_phase_1      & cmp_phase_3     ); // Majority logic
  assign vt_cmp_phase_3      = (cmp_phase_1      & cmp_phase_2     ) | (cmp_phase_2      & cmp_phase_3     ) | (cmp_phase_1      & cmp_phase_3     ); // Majority logic
  assign vt_cmp_phs_chg_m1_1 = (cmp_phs_chg_m1_1 & cmp_phs_chg_m1_2) | (cmp_phs_chg_m1_2 & cmp_phs_chg_m1_3) | (cmp_phs_chg_m1_1 & cmp_phs_chg_m1_3); // Majority logic
  assign vt_cmp_phs_chg_m1_2 = (cmp_phs_chg_m1_1 & cmp_phs_chg_m1_2) | (cmp_phs_chg_m1_2 & cmp_phs_chg_m1_3) | (cmp_phs_chg_m1_1 & cmp_phs_chg_m1_3); // Majority logic
  assign vt_cmp_phs_chg_m1_3 = (cmp_phs_chg_m1_1 & cmp_phs_chg_m1_2) | (cmp_phs_chg_m1_2 & cmp_phs_chg_m1_3) | (cmp_phs_chg_m1_1 & cmp_phs_chg_m1_3); // Majority logic
  assign vt_cmp_phs_change_1 = (cmp_phs_change_1 & cmp_phs_change_2) | (cmp_phs_change_2 & cmp_phs_change_3) | (cmp_phs_change_1 & cmp_phs_change_3); // Majority logic
  assign vt_cmp_phs_inc_1    = (cmp_phs_inc_1    & cmp_phs_inc_2)    | (cmp_phs_inc_2    & cmp_phs_inc_3   ) | (cmp_phs_inc_1    & cmp_phs_inc_3   ); // Majority logic
  assign vt_cmp_phs_inc_2    = (cmp_phs_inc_1    & cmp_phs_inc_2)    | (cmp_phs_inc_2    & cmp_phs_inc_3   ) | (cmp_phs_inc_1    & cmp_phs_inc_3   ); // Majority logic
  assign vt_cmp_phs_inc_3    = (cmp_phs_inc_1    & cmp_phs_inc_2)    | (cmp_phs_inc_2    & cmp_phs_inc_3   ) | (cmp_phs_inc_1    & cmp_phs_inc_3   ); // Majority logic


	initial begin
		$readmemh ("comp_phase", cmp_rom_1, 0, 31);
		$readmemh ("comp_phase", cmp_rom_2, 0, 31);
		$readmemh ("comp_phase", cmp_rom_3, 0, 31);
	end
	
	always @(posedge CLK40) begin
		cmp_phs_inc_1   <= (vt_cmp_phase_1 >  vt_cur_cmp_phase_1);
		cmp_phs_inc_2   <= (vt_cmp_phase_2 >  vt_cur_cmp_phase_2);
		cmp_phs_inc_3   <= (vt_cmp_phase_3 >  vt_cur_cmp_phase_3);
		
		cmp_phs_chg_m1_1 <= !(vt_cmp_phase_1 == vt_cur_cmp_phase_1);
		cmp_phs_chg_m1_2 <= !(vt_cmp_phase_2 == vt_cur_cmp_phase_2);
		cmp_phs_chg_m1_3 <= !(vt_cmp_phase_3 == vt_cur_cmp_phase_3);
		
		cmp_phs_change_1 <= vt_cmp_phs_chg_m1_1;                // delay signaling phase change to allow change to settle
		cmp_phs_change_2 <= vt_cmp_phs_chg_m1_2;                // delay signaling phase change to allow change to settle
		cmp_phs_change_3 <= vt_cmp_phs_chg_m1_3;                // delay signaling phase change to allow change to settle
		
		cmp_phase_1 <= vt_cmp_rom_1;
		cmp_phase_2 <= vt_cmp_rom_2;
		cmp_phase_3 <= vt_cmp_rom_3;
	end

// Track current phase value presumed inside MMCM
	always @(posedge CLK40 or posedge CMP_PHS_RST) begin
		if (CMP_PHS_RST) begin
			cur_cmp_phase_1 <= 11'h000;		// must match MMCM initial preset phase (normally 0)
			cur_cmp_phase_2 <= 11'h000;		// must match MMCM initial preset phase (normally 0)
			cur_cmp_phase_3 <= 11'h000;		// must match MMCM initial preset phase (normally 0)
		end
		else
			if (CMP_PHS_PSEN) begin
				cur_cmp_phase_1 <= vt_cmp_phs_inc_1 ? vt_cur_cmp_phase_1 + 1 : vt_cur_cmp_phase_1 - 1;
				cur_cmp_phase_2 <= vt_cmp_phs_inc_2 ? vt_cur_cmp_phase_2 + 1 : vt_cur_cmp_phase_2 - 1;
				cur_cmp_phase_3 <= vt_cmp_phs_inc_3 ? vt_cur_cmp_phase_3 + 1 : vt_cur_cmp_phase_3 - 1;
			end
			else begin
				cur_cmp_phase_1 <= vt_cur_cmp_phase_1;
				cur_cmp_phase_2 <= vt_cur_cmp_phase_2;
				cur_cmp_phase_3 <= vt_cur_cmp_phase_3;
			end
	end
	
	if(TMR_Err_Det==1) 
	begin : with_Err_Det
		dyn_phase_shift_FSM_TMR_Err_Det
		Comp_Phase_FSM(
		  .BUSY(CMP_PHS_BUSY),
		  .PSEN(CMP_PHS_PSEN),
		  .DYN_PHS_STATE(CMP_PHS_STATE),
		  .TMR_ERR_COUNT(CMP_PHS_ERRCNT),
		  .CLK(CLK40),
		  .LOCKED(TRG_MMCM_LOCK),
		  .PH_CHANGE(vt_cmp_phs_change_1),
		  .PS_DONE(CMP_PHS_PSDONE),
		  .RST(CMP_PHS_RST)
		);
	end
	else 
	begin : no_Err_Det
		dyn_phase_shift_FSM_TMR
		Comp_Phase_FSM(
		  .BUSY(CMP_PHS_BUSY),
		  .PSEN(CMP_PHS_PSEN),
		  .DYN_PHS_STATE(CMP_PHS_STATE),
		  .CLK(CLK40),
		  .LOCKED(TRG_MMCM_LOCK),
		  .PH_CHANGE(vt_cmp_phs_change_1),
		  .PS_DONE(CMP_PHS_PSDONE),
		  .RST(CMP_PHS_RST)
		);
		assign CMP_PHS_ERRCNT = 0;
	end
	assign CMP_PHASE = vt_cmp_phase_1;
	assign CMP_PHS_CHANGE = vt_cmp_phs_change_1;
	assign cmp_phs_inc_i = vt_cmp_phs_inc_1;
	
end
else 
begin : Comp_Phase_FSM
// signals for comparator clock managment
	reg [10:0] cur_cmp_phase;
	reg [10:0] cmp_rom [31:0];	
	reg [10:0] cmp_phase;
	reg cmp_phs_chg_m1;
	reg cmp_phs_change;
	reg cmp_phs_inc;
	
	initial begin
		$readmemh ("comp_phase", cmp_rom, 0, 31);
	end
	
	always @(posedge CLK40) begin
		cmp_phs_inc   <= (cmp_phase >  cur_cmp_phase);
		cmp_phs_chg_m1 <= !(cmp_phase == cur_cmp_phase);
		cmp_phs_change <= cmp_phs_chg_m1;                // delay signaling phase change to allow change to settle
		cmp_phase <= cmp_rom[CMP_CLK_PHASE];
	end

// Track current phase value presumed inside MMCM
	always @(posedge CLK40 or posedge CMP_PHS_RST) begin
		if (CMP_PHS_RST)
			cur_cmp_phase <= 11'h000;		// must match MMCM initial preset phase (normally 0)
		else
			if (CMP_PHS_PSEN)
				if (cmp_phs_inc)
					cur_cmp_phase <= cur_cmp_phase+1;
				else
					cur_cmp_phase <= cur_cmp_phase-1;
			else
				cur_cmp_phase <= cur_cmp_phase;
			
	end
	
   dyn_phase_shift_FSM
	Comp_Phase_FSM(
     .BUSY(CMP_PHS_BUSY),
     .PSEN(CMP_PHS_PSEN),
     .DYN_PHS_STATE(CMP_PHS_STATE),
     .CLK(CLK40),
     .LOCKED(TRG_MMCM_LOCK),
     .PH_CHANGE(cmp_phs_change),
     .PS_DONE(CMP_PHS_PSDONE),
     .RST(CMP_PHS_RST)
	);
	assign CMP_PHS_ERRCNT = 0;
	assign CMP_PHASE = cmp_phase;
	assign CMP_PHS_CHANGE = cmp_phs_change;
	assign cmp_phs_inc_i = cmp_phs_inc;
	
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

  BUFG gbt_dskw_clk_buf (
	.O   (GBT_DSKW_CLK),
	.I   (gbt_deskew_clk_0)
	);


endmodule
