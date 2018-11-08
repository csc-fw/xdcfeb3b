`timescale 1ns / 1ps


module reset_manager #(
	parameter Strt_dly = 20'h7FFFF,
	parameter POR_tmo = 7'd120,
	parameter ADC_Init_tmo = 12'd1000, // 10ms
	parameter TDIS_pulse_duration = 12'd4000, // 100us
	parameter TDIS_on_Startup = 0,
	parameter TMR = 0
)(
    input STUP_CLK,
    input CLK,
    input COMP_CLK,
    input CLK1MHZ,           // 1 MHz Clock
    input CLK100KHZ,
	 input RESYNC,
	 input RST_RESYNC,
    input EOS,
    input JTAG_SYS_RST,
	 input CSP_SYS_RST,
    input DAQ_MMCM_LOCK,
    input TRG_MMCM_LOCK,
    input CMP_PHS_CHANGE,
    input TRG_SYNC_DONE,
    input QP_ERROR,
    input QP_LOCKED,
	 input AL_DONE,
	 input AL_RESTART,
	 input ADC_INIT_DONE,
	 input DAQ_OP_RST,
	 input TRG_OP_RST,
	 input JTAG_GBT_PWR_ENA,
	 input JTAG_GBT_PWR_DIS,
	 
	 output ADC_INIT_RST,
	 output ADC_INIT,
	 output ADC_RDY,
	 output AL_START,
    output TRG_GTXTXRESET,
    output MMCM_RST,
    output SYS_MON_RST,
    output ADC_RST,
    output TRG_RST,
	 output DSR_RST,
    output SYS_RST,
	 output DAQ_FIFO_RST,
	 output SLOW_FIFO_RST,
	 output SLOW_FIFO_RST_DONE,
	 output RUN,
	 output QPLL_LOCK,
	 output QPLL_ERROR,
	 output DAQ_OP_TX_DISABLE,
	 output TRG_OP_TX_DISABLE,
	 output V15GBT_ENA,
	 output [3:0] POR_STATE
    );

wire inc_tmr;
wire adc_init_rst_i;
wire al_start_i;  
wire por_i;  
wire run_i;  
wire restart_all;
wire daq_fifo_rst_done;
wire slow_fifo_rst_done_i;

wire adc_rdy_r2_i;
wire al_done_r2_i;
wire daq_mmcm_lock_r2_i;
wire qpll_lock_r2_i;
wire [11:0] dsr_tmr_i;

wire strt_op_rst;
reg  ena_gbt;

 IBUF IBUF_QP_ERROR (.O(QPLL_ERROR),.I(QP_ERROR));
 IBUF IBUF_QP_LOCKED (.O(QPLL_LOCK),.I(QP_LOCKED));
 OBUF #(.DRIVE(12),.IOSTANDARD("DEFAULT"),.SLEW("SLOW")) OBUF_GBT_ENA (.O(V15GBT_ENA),.I(ena_gbt));

assign restart_all = (JTAG_SYS_RST || CSP_SYS_RST);
assign SLOW_FIFO_RST_DONE = slow_fifo_rst_done_i;
assign DSR_RST     = ~ADC_RDY || SYS_RST;

generate
if(TDIS_on_Startup==1) 
begin : tx_dis_on_strtup
	assign strt_op_rst = AL_START;
end
else
begin : no_tx_dis_on_strtup
	assign strt_op_rst = 0;
end
endgenerate

generate
if(TMR==1) 
begin : RSTman_logic_TMR

	(* syn_preserve = "true" *) reg [11:0] dsr_tmr_1;
	(* syn_preserve = "true" *) reg [11:0] dsr_tmr_2;
	(* syn_preserve = "true" *) reg [11:0] dsr_tmr_3;
	(* syn_preserve = "true" *) reg adc_rdy_r1_1;
	(* syn_preserve = "true" *) reg adc_rdy_r1_2;
	(* syn_preserve = "true" *) reg adc_rdy_r1_3;
	(* syn_preserve = "true" *) reg adc_rdy_r2_1;
	(* syn_preserve = "true" *) reg adc_rdy_r2_2;
	(* syn_preserve = "true" *) reg adc_rdy_r2_3;
	(* syn_preserve = "true" *) reg al_done_r1_1;
	(* syn_preserve = "true" *) reg al_done_r1_2;
	(* syn_preserve = "true" *) reg al_done_r1_3;
	(* syn_preserve = "true" *) reg al_done_r2_1;
	(* syn_preserve = "true" *) reg al_done_r2_2;
	(* syn_preserve = "true" *) reg al_done_r2_3;
	(* syn_preserve = "true" *) reg daq_mmcm_lock_r1_1;
	(* syn_preserve = "true" *) reg daq_mmcm_lock_r1_2;
	(* syn_preserve = "true" *) reg daq_mmcm_lock_r1_3;
	(* syn_preserve = "true" *) reg daq_mmcm_lock_r2_1;
	(* syn_preserve = "true" *) reg daq_mmcm_lock_r2_2;
	(* syn_preserve = "true" *) reg daq_mmcm_lock_r2_3;
	(* syn_preserve = "true" *) reg qpll_lock_r1_1;
	(* syn_preserve = "true" *) reg qpll_lock_r1_2;
	(* syn_preserve = "true" *) reg qpll_lock_r1_3;
	(* syn_preserve = "true" *) reg qpll_lock_r2_1;
	(* syn_preserve = "true" *) reg qpll_lock_r2_2;
	(* syn_preserve = "true" *) reg qpll_lock_r2_3;
	(* syn_preserve = "true" *) reg adc_init_rst_r1_1;
	(* syn_preserve = "true" *) reg adc_init_rst_r1_2;
	(* syn_preserve = "true" *) reg adc_init_rst_r1_3;
	(* syn_preserve = "true" *) reg adc_init_rst_r2_1;
	(* syn_preserve = "true" *) reg adc_init_rst_r2_2;
	(* syn_preserve = "true" *) reg adc_init_rst_r2_3;
	(* syn_preserve = "true" *) reg al_start_r1_1;  
	(* syn_preserve = "true" *) reg al_start_r1_2;  
	(* syn_preserve = "true" *) reg al_start_r1_3;  
	(* syn_preserve = "true" *) reg al_start_r2_1;  
	(* syn_preserve = "true" *) reg al_start_r2_2;  
	(* syn_preserve = "true" *) reg al_start_r2_3;  
	(* syn_preserve = "true" *) reg por_r1_1;  
	(* syn_preserve = "true" *) reg por_r1_2;  
	(* syn_preserve = "true" *) reg por_r1_3;  
	(* syn_preserve = "true" *) reg por_r2_1;  
	(* syn_preserve = "true" *) reg por_r2_2;  
	(* syn_preserve = "true" *) reg por_r2_3;  
	(* syn_preserve = "true" *) reg run_r1_1;
	(* syn_preserve = "true" *) reg run_r1_2;
	(* syn_preserve = "true" *) reg run_r1_3;
	(* syn_preserve = "true" *) reg run_r2_1;
	(* syn_preserve = "true" *) reg run_r2_2;
	(* syn_preserve = "true" *) reg run_r2_3;

	(* syn_keep = "true" *) wire [11:0] vt_dsr_tmr_1;
	(* syn_keep = "true" *) wire [11:0] vt_dsr_tmr_2;
	(* syn_keep = "true" *) wire [11:0] vt_dsr_tmr_3;
	(* syn_keep = "true" *) wire vt_adc_rdy_r1_1;
	(* syn_keep = "true" *) wire vt_adc_rdy_r1_2;
	(* syn_keep = "true" *) wire vt_adc_rdy_r1_3;
	(* syn_keep = "true" *) wire vt_adc_rdy_r2_1;
	(* syn_keep = "true" *) wire vt_al_done_r1_1;
	(* syn_keep = "true" *) wire vt_al_done_r1_2;
	(* syn_keep = "true" *) wire vt_al_done_r1_3;
	(* syn_keep = "true" *) wire vt_al_done_r2_1;
	(* syn_keep = "true" *) wire vt_daq_mmcm_lock_r1_1;
	(* syn_keep = "true" *) wire vt_daq_mmcm_lock_r1_2;
	(* syn_keep = "true" *) wire vt_daq_mmcm_lock_r1_3;
	(* syn_keep = "true" *) wire vt_daq_mmcm_lock_r2_1;
	(* syn_keep = "true" *) wire vt_qpll_lock_r1_1;
	(* syn_keep = "true" *) wire vt_qpll_lock_r1_2;
	(* syn_keep = "true" *) wire vt_qpll_lock_r1_3;
	(* syn_keep = "true" *) wire vt_qpll_lock_r2_1;
	(* syn_keep = "true" *) wire vt_adc_init_rst_r1_1;
	(* syn_keep = "true" *) wire vt_adc_init_rst_r1_2;
	(* syn_keep = "true" *) wire vt_adc_init_rst_r1_3;
	(* syn_keep = "true" *) wire vt_adc_init_rst_r2_1;
	(* syn_keep = "true" *) wire vt_al_start_r1_1;  
	(* syn_keep = "true" *) wire vt_al_start_r1_2;  
	(* syn_keep = "true" *) wire vt_al_start_r1_3;  
	(* syn_keep = "true" *) wire vt_al_start_r2_1;  
	(* syn_keep = "true" *) wire vt_por_r1_1;  
	(* syn_keep = "true" *) wire vt_por_r1_2;  
	(* syn_keep = "true" *) wire vt_por_r1_3;  
	(* syn_keep = "true" *) wire vt_por_r2_1;  
	(* syn_keep = "true" *) wire vt_por_r2_2;  
	(* syn_keep = "true" *) wire vt_por_r2_3;  
	(* syn_keep = "true" *) wire vt_run_r1_1;
	(* syn_keep = "true" *) wire vt_run_r1_2;
	(* syn_keep = "true" *) wire vt_run_r1_3;
	(* syn_keep = "true" *) wire vt_run_r2_1;

	(* syn_keep = "true" *) wire sys_mon_rst_1;
	(* syn_keep = "true" *) wire sys_mon_rst_2;
	(* syn_keep = "true" *) wire sys_mon_rst_3;

	assign vt_dsr_tmr_1          = (dsr_tmr_1          & dsr_tmr_2         ) | (dsr_tmr_2          & dsr_tmr_3         ) | (dsr_tmr_1          & dsr_tmr_3         ); // Majority logic
	assign vt_dsr_tmr_2          = (dsr_tmr_1          & dsr_tmr_2         ) | (dsr_tmr_2          & dsr_tmr_3         ) | (dsr_tmr_1          & dsr_tmr_3         ); // Majority logic
	assign vt_dsr_tmr_3          = (dsr_tmr_1          & dsr_tmr_2         ) | (dsr_tmr_2          & dsr_tmr_3         ) | (dsr_tmr_1          & dsr_tmr_3         ); // Majority logic
	assign vt_adc_rdy_r1_1       = (adc_rdy_r1_1       & adc_rdy_r1_2      ) | (adc_rdy_r1_2       & adc_rdy_r1_3      ) | (adc_rdy_r1_1       & adc_rdy_r1_3      ); // Majority logic
	assign vt_adc_rdy_r1_2       = (adc_rdy_r1_1       & adc_rdy_r1_2      ) | (adc_rdy_r1_2       & adc_rdy_r1_3      ) | (adc_rdy_r1_1       & adc_rdy_r1_3      ); // Majority logic
	assign vt_adc_rdy_r1_3       = (adc_rdy_r1_1       & adc_rdy_r1_2      ) | (adc_rdy_r1_2       & adc_rdy_r1_3      ) | (adc_rdy_r1_1       & adc_rdy_r1_3      ); // Majority logic
	assign vt_adc_rdy_r2_1       = (adc_rdy_r2_1       & adc_rdy_r2_2      ) | (adc_rdy_r2_2       & adc_rdy_r2_3      ) | (adc_rdy_r2_1       & adc_rdy_r2_3      ); // Majority logic
	assign vt_al_done_r1_1       = (al_done_r1_1       & al_done_r1_2      ) | (al_done_r1_2       & al_done_r1_3      ) | (al_done_r1_1       & al_done_r1_3      ); // Majority logic
	assign vt_al_done_r1_2       = (al_done_r1_1       & al_done_r1_2      ) | (al_done_r1_2       & al_done_r1_3      ) | (al_done_r1_1       & al_done_r1_3      ); // Majority logic
	assign vt_al_done_r1_3       = (al_done_r1_1       & al_done_r1_2      ) | (al_done_r1_2       & al_done_r1_3      ) | (al_done_r1_1       & al_done_r1_3      ); // Majority logic
	assign vt_al_done_r2_1       = (al_done_r2_1       & al_done_r2_2      ) | (al_done_r2_2       & al_done_r2_3      ) | (al_done_r2_1       & al_done_r2_3      ); // Majority logic
	assign vt_daq_mmcm_lock_r1_1 = (daq_mmcm_lock_r1_1 & daq_mmcm_lock_r1_2) | (daq_mmcm_lock_r1_2 & daq_mmcm_lock_r1_3) | (daq_mmcm_lock_r1_1 & daq_mmcm_lock_r1_3); // Majority logic
	assign vt_daq_mmcm_lock_r1_2 = (daq_mmcm_lock_r1_1 & daq_mmcm_lock_r1_2) | (daq_mmcm_lock_r1_2 & daq_mmcm_lock_r1_3) | (daq_mmcm_lock_r1_1 & daq_mmcm_lock_r1_3); // Majority logic
	assign vt_daq_mmcm_lock_r1_3 = (daq_mmcm_lock_r1_1 & daq_mmcm_lock_r1_2) | (daq_mmcm_lock_r1_2 & daq_mmcm_lock_r1_3) | (daq_mmcm_lock_r1_1 & daq_mmcm_lock_r1_3); // Majority logic
	assign vt_daq_mmcm_lock_r2_1 = (daq_mmcm_lock_r2_1 & daq_mmcm_lock_r2_2) | (daq_mmcm_lock_r2_2 & daq_mmcm_lock_r2_3) | (daq_mmcm_lock_r2_1 & daq_mmcm_lock_r2_3); // Majority logic
	assign vt_qpll_lock_r1_1     = (qpll_lock_r1_1     & qpll_lock_r1_2    ) | (qpll_lock_r1_2     & qpll_lock_r1_3    ) | (qpll_lock_r1_1     & qpll_lock_r1_3    ); // Majority logic
	assign vt_qpll_lock_r1_2     = (qpll_lock_r1_1     & qpll_lock_r1_2    ) | (qpll_lock_r1_2     & qpll_lock_r1_3    ) | (qpll_lock_r1_1     & qpll_lock_r1_3    ); // Majority logic
	assign vt_qpll_lock_r1_3     = (qpll_lock_r1_1     & qpll_lock_r1_2    ) | (qpll_lock_r1_2     & qpll_lock_r1_3    ) | (qpll_lock_r1_1     & qpll_lock_r1_3    ); // Majority logic
	assign vt_qpll_lock_r2_1     = (qpll_lock_r2_1     & qpll_lock_r2_2    ) | (qpll_lock_r2_2     & qpll_lock_r2_3    ) | (qpll_lock_r2_1     & qpll_lock_r2_3    ); // Majority logic
	assign vt_adc_init_rst_r1_1  = (adc_init_rst_r1_1  & adc_init_rst_r1_2 ) | (adc_init_rst_r1_2  & adc_init_rst_r1_3 ) | (adc_init_rst_r1_1  & adc_init_rst_r1_3 ); // Majority logic
	assign vt_adc_init_rst_r1_2  = (adc_init_rst_r1_1  & adc_init_rst_r1_2 ) | (adc_init_rst_r1_2  & adc_init_rst_r1_3 ) | (adc_init_rst_r1_1  & adc_init_rst_r1_3 ); // Majority logic
	assign vt_adc_init_rst_r1_3  = (adc_init_rst_r1_1  & adc_init_rst_r1_2 ) | (adc_init_rst_r1_2  & adc_init_rst_r1_3 ) | (adc_init_rst_r1_1  & adc_init_rst_r1_3 ); // Majority logic
	assign vt_adc_init_rst_r2_1  = (adc_init_rst_r2_1  & adc_init_rst_r2_2 ) | (adc_init_rst_r2_2  & adc_init_rst_r2_3 ) | (adc_init_rst_r2_1  & adc_init_rst_r2_3 ); // Majority logic
	assign vt_al_start_r1_1      = (al_start_r1_1      & al_start_r1_2     ) | (al_start_r1_2      & al_start_r1_3     ) | (al_start_r1_1      & al_start_r1_3     ); // Majority logic
	assign vt_al_start_r1_2      = (al_start_r1_1      & al_start_r1_2     ) | (al_start_r1_2      & al_start_r1_3     ) | (al_start_r1_1      & al_start_r1_3     ); // Majority logic
	assign vt_al_start_r1_3      = (al_start_r1_1      & al_start_r1_2     ) | (al_start_r1_2      & al_start_r1_3     ) | (al_start_r1_1      & al_start_r1_3     ); // Majority logic
	assign vt_al_start_r2_1      = (al_start_r2_1      & al_start_r2_2     ) | (al_start_r2_2      & al_start_r2_3     ) | (al_start_r2_1      & al_start_r2_3     ); // Majority logic
	assign vt_por_r1_1           = (por_r1_1           & por_r1_2          ) | (por_r1_2           & por_r1_3          ) | (por_r1_1           & por_r1_3          ); // Majority logic
	assign vt_por_r1_2           = (por_r1_1           & por_r1_2          ) | (por_r1_2           & por_r1_3          ) | (por_r1_1           & por_r1_3          ); // Majority logic
	assign vt_por_r1_3           = (por_r1_1           & por_r1_2          ) | (por_r1_2           & por_r1_3          ) | (por_r1_1           & por_r1_3          ); // Majority logic
	assign vt_por_r2_1           = (por_r2_1           & por_r2_2          ) | (por_r2_2           & por_r2_3          ) | (por_r2_1           & por_r2_3          ); // Majority logic
	assign vt_por_r2_2           = (por_r2_1           & por_r2_2          ) | (por_r2_2           & por_r2_3          ) | (por_r2_1           & por_r2_3          ); // Majority logic
	assign vt_por_r2_3           = (por_r2_1           & por_r2_2          ) | (por_r2_2           & por_r2_3          ) | (por_r2_1           & por_r2_3          ); // Majority logic
	assign vt_run_r1_1           = (run_r1_1           & run_r1_2          ) | (run_r1_2           & run_r1_3          ) | (run_r1_1           & run_r1_3          ); // Majority logic
	assign vt_run_r1_2           = (run_r1_1           & run_r1_2          ) | (run_r1_2           & run_r1_3          ) | (run_r1_1           & run_r1_3          ); // Majority logic
	assign vt_run_r1_3           = (run_r1_1           & run_r1_2          ) | (run_r1_2           & run_r1_3          ) | (run_r1_1           & run_r1_3          ); // Majority logic
	assign vt_run_r2_1           = (run_r2_1           & run_r2_2          ) | (run_r2_2           & run_r2_3          ) | (run_r2_1           & run_r2_3          ); // Majority logic

	assign ADC_INIT_RST = vt_adc_init_rst_r2_1;
	assign AL_START     = vt_al_start_r2_1;
	assign SYS_RST      = vt_por_r2_1;
	assign RUN          = vt_run_r2_1;
	assign SYS_MON_RST  = (sys_mon_rst_1 & sys_mon_rst_2) | (sys_mon_rst_2 & sys_mon_rst_3) | (sys_mon_rst_1 & sys_mon_rst_3); // Majority logic

 	assign adc_rdy_r2_i       = vt_adc_rdy_r2_1;
 	assign al_done_r2_i       = vt_al_done_r2_1;
 	assign daq_mmcm_lock_r2_i = vt_daq_mmcm_lock_r2_1;
 	assign qpll_lock_r2_i     = vt_qpll_lock_r2_1;
 	assign dsr_tmr_i          = vt_dsr_tmr_1;

	SRL16E #(
		.INIT(16'HFFFF)
	) SysMonRst_1 (
		.Q(sys_mon_rst_1),
		.A0(1'b1),
		.A1(1'b1),
		.A2(1'b1),
		.A3(1'b1),
		.CE(1'b1),
		.CLK(STUP_CLK),
		.D(1'b0)
	);

	SRL16E #(
		.INIT(16'HFFFF)
	) SysMonRst_2 (
		.Q(sys_mon_rst_2),
		.A0(1'b1),
		.A1(1'b1),
		.A2(1'b1),
		.A3(1'b1),
		.CE(1'b1),
		.CLK(STUP_CLK),
		.D(1'b0)
	);

	SRL16E #(
		.INIT(16'HFFFF)
	) SysMonRst_3 (
		.Q(sys_mon_rst_3),
		.A0(1'b1),
		.A1(1'b1),
		.A2(1'b1),
		.A3(1'b1),
		.CE(1'b1),
		.CLK(STUP_CLK),
		.D(1'b0)
	);
		
	// Synchronize inputs to startup clock for POR state machine

	always @(posedge STUP_CLK) begin
		adc_rdy_r1_1       <= ADC_RDY;
		al_done_r1_1       <= AL_DONE;
		daq_mmcm_lock_r1_1 <= DAQ_MMCM_LOCK;
		qpll_lock_r1_1     <= QPLL_LOCK;
		
		adc_rdy_r2_1       <= vt_adc_rdy_r1_1;
		al_done_r2_1       <= vt_al_done_r1_1;
		daq_mmcm_lock_r2_1 <= vt_daq_mmcm_lock_r1_1;
		qpll_lock_r2_1     <= vt_qpll_lock_r1_1;

		adc_rdy_r1_2       <= ADC_RDY;
		al_done_r1_2       <= AL_DONE;
		daq_mmcm_lock_r1_2 <= DAQ_MMCM_LOCK;
		qpll_lock_r1_2     <= QPLL_LOCK;
		
		adc_rdy_r2_2       <= vt_adc_rdy_r1_2;
		al_done_r2_2       <= vt_al_done_r1_2;
		daq_mmcm_lock_r2_2 <= vt_daq_mmcm_lock_r1_2;
		qpll_lock_r2_2     <= vt_qpll_lock_r1_2;

		adc_rdy_r1_3       <= ADC_RDY;
		al_done_r1_3       <= AL_DONE;
		daq_mmcm_lock_r1_3 <= DAQ_MMCM_LOCK;
		qpll_lock_r1_3     <= QPLL_LOCK;
		
		adc_rdy_r2_3       <= vt_adc_rdy_r1_3;
		al_done_r2_3       <= vt_al_done_r1_3;
		daq_mmcm_lock_r2_3 <= vt_daq_mmcm_lock_r1_3;
		qpll_lock_r2_3     <= vt_qpll_lock_r1_3;
	end

	// Synchronize outputs to 40MHz clock 

	always @(posedge CLK or negedge EOS) begin
		if(!EOS) begin
			adc_init_rst_r1_1  <= 1'b1;
			al_start_r1_1      <= 1'b0;
			por_r1_1           <= 1'b1;
			run_r1_1           <= 1'b0;
			adc_init_rst_r2_1  <= 1'b1;
			al_start_r2_1      <= 1'b0;
			por_r2_1           <= 1'b1;
			run_r2_1           <= 1'b0;

			adc_init_rst_r1_2  <= 1'b1;
			al_start_r1_2      <= 1'b0;
			por_r1_2           <= 1'b1;
			run_r1_2           <= 1'b0;
			adc_init_rst_r2_2  <= 1'b1;
			al_start_r2_2      <= 1'b0;
			por_r2_2           <= 1'b1;
			run_r2_2           <= 1'b0;

			adc_init_rst_r1_3  <= 1'b1;
			al_start_r1_3      <= 1'b0;
			por_r1_3           <= 1'b1;
			run_r1_3           <= 1'b0;
			adc_init_rst_r2_3  <= 1'b1;
			al_start_r2_3      <= 1'b0;
			por_r2_3           <= 1'b1;
			run_r2_3           <= 1'b0;
		end
		else begin
			adc_init_rst_r1_1  <= adc_init_rst_i;
			al_start_r1_1      <= al_start_i;
			por_r1_1           <= por_i;
			run_r1_1           <= run_i;
			
			adc_init_rst_r2_1  <= vt_adc_init_rst_r1_1;
			al_start_r2_1      <= vt_al_start_r1_1;
			por_r2_1           <= vt_por_r1_1;
			run_r2_1           <= vt_run_r1_1;

			adc_init_rst_r1_2  <= adc_init_rst_i;
			al_start_r1_2      <= al_start_i;
			por_r1_2           <= por_i;
			run_r1_2           <= run_i;
			
			adc_init_rst_r2_2  <= vt_adc_init_rst_r1_2;
			al_start_r2_2      <= vt_al_start_r1_2;
			por_r2_2           <= vt_por_r1_2;
			run_r2_2           <= vt_run_r1_2;

			adc_init_rst_r1_3  <= adc_init_rst_i;
			al_start_r1_3      <= al_start_i;
			por_r1_3           <= por_i;
			run_r1_3           <= run_i;
			
			adc_init_rst_r2_3  <= vt_adc_init_rst_r1_3;
			al_start_r2_3      <= vt_al_start_r1_3;
			por_r2_3           <= vt_por_r1_3;
			run_r2_3           <= vt_run_r1_3;
		end
	end

	always @(posedge CLK100KHZ or posedge vt_por_r2_1) begin
		if(vt_por_r2_1) begin
			dsr_tmr_1 <= 12'h000;
		end
		else begin
			dsr_tmr_1 <= inc_tmr ? vt_dsr_tmr_1 +1 : vt_dsr_tmr_1;
		end
	end
	always @(posedge CLK100KHZ or posedge vt_por_r2_2) begin
		if(vt_por_r2_2) begin
			dsr_tmr_2 <= 12'h000;
		end
		else begin
			dsr_tmr_2 <= inc_tmr ? vt_dsr_tmr_2 +1 : vt_dsr_tmr_2;
		end
	end
	always @(posedge CLK100KHZ or posedge vt_por_r2_3) begin
		if(vt_por_r2_3) begin
			dsr_tmr_3 <= 12'h000;
		end
		else begin
			dsr_tmr_3 <= inc_tmr ? vt_dsr_tmr_3 +1 : vt_dsr_tmr_3;
		end
	end

end
else 
begin : RSTman_logic

	reg [11:0] dsr_tmr;
	reg adc_rdy_r1;
	reg adc_rdy_r2;
	reg al_done_r1;
	reg al_done_r2;
	reg daq_mmcm_lock_r1;
	reg daq_mmcm_lock_r2;
	reg qpll_lock_r1;
	reg qpll_lock_r2;
	reg adc_init_rst_r1;
	reg adc_init_rst_r2;
	reg al_start_r1;  
	reg al_start_r2;  
	reg por_r1;  
	reg por_r2;  
	reg run_r1;
	reg run_r2;

	assign ADC_INIT_RST = adc_init_rst_r2;
	assign AL_START     = al_start_r2;
	assign SYS_RST      = por_r2;
	assign RUN          = run_r2;

 	assign adc_rdy_r2_i       = adc_rdy_r2;
 	assign al_done_r2_i       = al_done_r2;
 	assign daq_mmcm_lock_r2_i = daq_mmcm_lock_r2;
 	assign qpll_lock_r2_i     = qpll_lock_r2;
 	assign dsr_tmr_i          = dsr_tmr;

	SRL16E #(
		.INIT(16'HFFFF)
	) SysMonRst_i (
		.Q(SYS_MON_RST),
		.A0(1'b1),
		.A1(1'b1),
		.A2(1'b1),
		.A3(1'b1),
		.CE(1'b1),
		.CLK(STUP_CLK),
		.D(1'b0)
	);
		
	// Synchronize inputs to startup clock for POR state machine

	always @(posedge STUP_CLK) begin
		adc_rdy_r1       <= ADC_RDY;
		al_done_r1       <= AL_DONE;
		daq_mmcm_lock_r1 <= DAQ_MMCM_LOCK;
		qpll_lock_r1     <= QPLL_LOCK;
		
		adc_rdy_r2       <= adc_rdy_r1;
		al_done_r2       <= al_done_r1;
		daq_mmcm_lock_r2 <= daq_mmcm_lock_r1;
		qpll_lock_r2     <= qpll_lock_r1;
	end

	// Synchronize outputs to 40MHz clock 

	always @(posedge CLK or negedge EOS) begin
		if(!EOS) begin
			adc_init_rst_r1  <= 1'b1;
			al_start_r1      <= 1'b0;
			por_r1           <= 1'b1;
			run_r1           <= 1'b0;
			adc_init_rst_r2  <= 1'b1;
			al_start_r2      <= 1'b0;
			por_r2           <= 1'b1;
			run_r2           <= 1'b0;
		end
		else begin
			adc_init_rst_r1  <= adc_init_rst_i;
			al_start_r1      <= al_start_i;
			por_r1           <= por_i;
			run_r1           <= run_i;
			
			adc_init_rst_r2  <= adc_init_rst_r1;
			al_start_r2      <= al_start_r1;
			por_r2           <= por_r1;
			run_r2           <= run_r1;
		end
	end

	always @(posedge CLK100KHZ or posedge por_r2) begin
		if(por_r2) begin
			dsr_tmr <= 12'h000;
		end
		else begin
			dsr_tmr <= inc_tmr ? dsr_tmr +1 : dsr_tmr;
		end
	end

end
endgenerate


generate
if(TMR==1) 
begin : RSTman_FSMs_TMR
	Pow_on_Rst_FSM_TMR #(
			.Strt_dly(Strt_dly),
			.POR_tmo(POR_tmo)
	)
	POW_on_Reset_FSM_xdcfeb_i (
		 // Outputs
		.ADC_INIT_RST(adc_init_rst_i),
		.AL_START(al_start_i),
		.MMCM_RST(MMCM_RST),
		.POR(por_i),
		.RUN(run_i),
		.POR_STATE(POR_STATE),
		// Inputs
		.ADC_RDY( adc_rdy_r2_i),
		.AL_DONE(al_done_r2_i),
		.CLK(STUP_CLK),
		.EOS(EOS),
		.MMCM_LOCK(daq_mmcm_lock_r2_i),
		.QPLL_LOCK(qpll_lock_r2_i),
		.RESTART_ALL(restart_all),
		.SLOW_FRST_DONE(slow_fifo_rst_done_i)
	);
													 
	FIFO_Rst_FSM_TMR
	DAQ_FIFO_Rst_FSM_i ( // reset all DAQ FIFOs on Resync
		.DONE(daq_fifo_rst_done),
		.FIFO_RST(DAQ_FIFO_RST),
		.AL_RESTART(0),
		.CLK(CLK),
		.RST(RST_RESYNC) 
	);
													 

	FIFO_Rst_FSM_TMR
	SLOW_FIFO_Rst_FSM_i ( // reset AUTO_LOAD FIFO
		.DONE(slow_fifo_rst_done_i),
		.FIFO_RST(SLOW_FIFO_RST),
		.AL_RESTART(AL_RESTART),
		.CLK(~CLK1MHZ),
		.RST(SYS_RST) 
	);

	Trg_Clock_Strt_FSM_TMR
	Trg_Clock_Strt_FSM_i (
		 // Outputs
		.GTX_RST(TRG_GTXTXRESET),
		.TRG_RST(TRG_RST),
		// Inputs
		.CLK(COMP_CLK),
		.CLK_PHS_CHNG(CMP_PHS_CHANGE),
		.MMCM_LOCK(TRG_MMCM_LOCK),
		.RST(SYS_RST),
		.SYNC_DONE(TRG_SYNC_DONE)
	);

	ADC_Init_FSM_TMR  #(.TIME_OUT(ADC_Init_tmo)) // 10ms  
	ADC_Init_FSM_i (
		 // Outputs
		.ADC_INIT(ADC_INIT),
		.ADC_RST(ADC_RST),
		.INC_TMR(inc_tmr),
		.RUN(ADC_RDY),
		// Inputs
		.CLK(CLK),
		.INIT_DONE(ADC_INIT_DONE),
		.RST(ADC_INIT_RST),
		.SLOW_CNT(dsr_tmr_i)
	);
	
	op_link_rst_FSM_TMR #(.PULSE_DUR(TDIS_pulse_duration)) // 100us
	op_link_rst_FSM_i (
		 //Outputs
		.DAQ_TDIS(DAQ_OP_TX_DISABLE),
		.TRG_TDIS(TRG_OP_TX_DISABLE),
		 //inputs
		.CLK(CLK),
		.RST(SYS_RST),
		.STRTUP_OP_RST(strt_op_rst),
		.DAQ_OP_RST(DAQ_OP_RST),
		.TRG_OP_RST(TRG_OP_RST)
	);
	
end
else 
begin : RSTman_FSMs
	Pow_on_Rst_FSM #(
			.Strt_dly(Strt_dly),
			.POR_tmo(POR_tmo)
	)
	POW_on_Reset_FSM_xdcfeb_i (
		 // Outputs
		.ADC_INIT_RST(adc_init_rst_i),
		.AL_START(al_start_i),
		.MMCM_RST(MMCM_RST),
		.POR(por_i),
		.RUN(run_i),
		.POR_STATE(POR_STATE),
		// Inputs
		.ADC_RDY( adc_rdy_r2_i),
		.AL_DONE(al_done_r2_i),
		.CLK(STUP_CLK),
		.EOS(EOS),
		.MMCM_LOCK(daq_mmcm_lock_r2_i),
		.QPLL_LOCK(qpll_lock_r2_i),
		.RESTART_ALL(restart_all),
		.SLOW_FRST_DONE(slow_fifo_rst_done_i)
	);
													 
	FIFO_Rst_FSM
	DAQ_FIFO_Rst_FSM_i ( // reset all DAQ FIFOs on Resync
		.DONE(daq_fifo_rst_done),
		.FIFO_RST(DAQ_FIFO_RST),
		.AL_RESTART(0),
		.CLK(CLK),
		.RST(RST_RESYNC) 
	);
	
	FIFO_Rst_FSM
	SLOW_FIFO_Rst_FSM_i ( // reset AUTO_LOAD FIFO
		.DONE(slow_fifo_rst_done_i),
		.FIFO_RST(SLOW_FIFO_RST),
		.AL_RESTART(AL_RESTART),
		.CLK(~CLK1MHZ),
		.RST(SYS_RST) 
	);

	Trg_Clock_Strt_FSM
	Trg_Clock_Strt_FSM_i (
		 // Outputs
		.GTX_RST(TRG_GTXTXRESET),
		.TRG_RST(TRG_RST),
		// Inputs
		.CLK(COMP_CLK),
		.CLK_PHS_CHNG(CMP_PHS_CHANGE),
		.MMCM_LOCK(TRG_MMCM_LOCK),
		.RST(SYS_RST),
		.SYNC_DONE(TRG_SYNC_DONE)
	);

	ADC_Init_FSM  #(.TIME_OUT(ADC_Init_tmo)) // 10ms  
	ADC_Init_FSM_i (
		 // Outputs
		.ADC_INIT(ADC_INIT),
		.ADC_RST(ADC_RST),
		.INC_TMR(inc_tmr),
		.RUN(ADC_RDY),
		// Inputs
		.CLK(CLK),
		.INIT_DONE(ADC_INIT_DONE),
		.RST(ADC_INIT_RST),
		.SLOW_CNT(dsr_tmr_i)
	);
	
	op_link_rst_FSM #(.PULSE_DUR(TDIS_pulse_duration)) // 100us
	op_link_rst_FSM_i (
		 //Outputs
		.DAQ_TDIS(DAQ_OP_TX_DISABLE),
		.TRG_TDIS(TRG_OP_TX_DISABLE),
		 //inputs
		.CLK(CLK),
		.RST(SYS_RST),
		.STRTUP_OP_RST(strt_op_rst),
		.DAQ_OP_RST(DAQ_OP_RST),
		.TRG_OP_RST(TRG_OP_RST)
	);

end
endgenerate

always @(posedge CLK or posedge SYS_RST) begin
	if(SYS_RST) begin
		ena_gbt <= 1'b1;
	end
	else
		if (JTAG_GBT_PWR_ENA) begin
			ena_gbt <= 1'b1;
		end
		else if (JTAG_GBT_PWR_DIS) begin
			ena_gbt <= 1'b0;
		end
end


endmodule
